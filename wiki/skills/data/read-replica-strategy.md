---
name: read-replica-strategy
description: Use when routing reads to a database replica and a read might need to reflect a recent write — read-your-writes, monotonic reads, or lag-based routing across Postgres/MySQL/Aurora replicas. Produces a per-read routing decision that fences staleness by replication position instead of assuming the replica caught up.
---

# /read-replica-strategy — Read Replicas Without Serving Stale Data

Use when adding replica reads to a write path, or reviewing one where a user can see their own change go missing.

**Persona: Database reliability engineer who owns the read path.** You route for correctness before latency — above all you hold that a silently stale read is a data-integrity bug, not a performance tradeoff, and you never *assume* a replica is current: you prove it by log position or you go to the primary.

**Replication lag is real and nonzero on every replica** — Postgres streaming, MySQL, and even Aurora's shared-storage replicas (redo-apply lag, typically ~10–20ms). A bare read on a round-robin replica right after a write returns pre-write data. Fence on replication position, not a wall-clock "route to primary for N seconds" timer that connection pooling defeats.

**Classify each read first:** strong, read-your-writes (RYW), bounded-staleness, or eventual. Only strong and RYW need fencing; the rest may take any replica.

**Fence RYW by position.** On commit, capture the write position — Postgres `pg_current_wal_lsn()`, MySQL `@@GLOBAL.gtid_executed` — and stash it in the *user's session store*, not on the DB connection. On the fenced read, require the replica to have replayed past it: Postgres `SELECT pg_last_wal_replay_lsn() >= '<lsn>'::pg_lsn`; MySQL `SELECT WAIT_FOR_EXECUTED_GTID_SET('<set>', 0.5)` (returns 0 if caught up within 500ms). If it hasn't, fall back to the primary.

**Lag-gate the pool:** evict a replica from RYW routing when its lag exceeds **250ms**, or when its lag metric is NULL/unknown — treat unknown as *infinite*, never zero. Health-check the replication applier thread, not just the TCP socket.

**Pin a session to one replica** (or fence every read by LSN) so successive reads never move backward in time — otherwise two reads hit replicas at different positions and the user watches data un-happen (monotonic-reads violation).

BAD: after `UPDATE users SET email=$1 WHERE id=$2` on the primary, the next request runs `SELECT email FROM users WHERE id=$2` on a round-robin replica; it hasn't replayed the change and returns the old email, so the user thinks the save failed and submits again.
GOOD: capture `pg_current_wal_lsn()` into the session at commit; serve that read only from a replica where `pg_last_wal_replay_lsn()` has passed it, else route to the primary. One position check, no stale read.

Report only measured lag; if not measured, write "not measured", never estimate.

```
═══ REPLICA READ ROUTING ═══
Read:         [endpoint / query]
Consistency:  [strong | read-your-writes | bounded | eventual]
Write pos:    [pg_lsn | gtid_set | none]
Replica lag:  [N ms | NULL→treated-infinite | not measured]
Decision:     [replica <id> | primary-fallback | wait <N>ms→replica]
Reason:       [replay_lsn ≥ write_pos | lag > 250ms | position unknown]
═══════════════════════════
```

Skip when: there are no replicas, or the read is analytics/reporting/ETL where staleness is expected and acceptable — don't fence an eventual read you'll only slow down.

Gotchas: MySQL `Seconds_Behind_Source` reads 0 on an idle replica and NULL when the SQL applier thread is stopped, so a *broken* replica looks perfectly caught-up — alert on NULL and thread state, not the number. PgBouncer in transaction mode hands each transaction a different server connection, so a "pin to primary" flag set on the connection leaks to other clients — the LSN must live in application session state. Aurora "shared storage" is not zero-lag: the reader still applies redo, so read-after-write can still be stale.
