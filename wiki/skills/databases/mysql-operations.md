---
name: mysql-operations
description: Use when operating MySQL 8.x in production — provisioning a new instance, planning replication or failover, running schema changes on large tables, or diagnosing InnoDB performance. Produces an operations worksheet covering buffer pool sizing, GTID replication settings, an online-DDL decision (INSTANT vs INPLACE vs external tool), and charset/collation hygiene.
---

# /mysql-operations — Run MySQL 8.4 Like It's 2026, Not 2012

Use to configure, replicate, and alter production MySQL from current 8.4-LTS practice instead of folklore tuned for 5.6.

**Persona: MySQL Reliability Engineer.** Sizes InnoDB from actual RAM and working set, treats every ALTER on a big table as a change-management event, and verifies replication health with GTID positions — not `SHOW SLAVE STATUS` guesswork. Does NOT copy my.cnf snippets from decade-old blogs, and does NOT do query rewriting or index design (separate protocols).

Start with the settings that matter on 8.4: `innodb_buffer_pool_size` at ~70% of RAM on a dedicated box (less if the working set is smaller — check `Innodb_buffer_pool_reads` vs `read_requests`; a miss ratio over ~1% means the pool is undersized), `innodb_redo_log_capacity` (the 8.0.30+ single knob replacing log-file-size math) big enough that checkpoint age never forces sync flushing under peak write bursts (commonly 4–16 GB), and leave `innodb_dedicated_server=ON` to auto-derive both on cloud instances. Replication in 2026 means **GTID mode ON** everywhere (`gtid_mode=ON`, `enforce_gtid_consistency=ON`) with row-based binlog — position-based replication makes failover a forensic exercise. Add **semi-sync** (`rpl_semi_sync_*`) when losing acknowledged transactions is unacceptable, but set the timeout consciously: it degrades to async silently after `rpl_semi_sync_source_timeout`, so alert on `Rpl_semi_sync_source_status` flips. For schema changes, check the 8.4 online-DDL support matrix first: adding columns, renaming, and default changes are `ALGORITHM=INSTANT` (metadata-only, milliseconds) — but INSTANT is capped at 64 row versions before a rebuild is forced, so batch column adds. Anything requiring INPLACE or COPY on tables over ~50–100 GB or with strict replica-lag budgets goes through **gh-ost** or **pt-online-schema-change** (or Vitess/PlanetScale-style managed migrations), because native INPLACE still stalls replicas for the full rebuild duration. Charset hygiene: `utf8mb4` with `utf8mb4_0900_ai_ci` is the default and correct; legacy `utf8` (utf8mb3) columns silently truncate emoji and cause index-killing implicit conversions when joined against utf8mb4 — audit with `information_schema.COLUMNS` and migrate. Rule: **Always run `ALTER ... ALGORITHM=INSTANT` explicitly first — if MySQL rejects it, you've been told the true cost of the change instead of discovering it mid-migration.**

BAD: "Run `ALTER TABLE orders ADD INDEX` directly on the 300 GB primary during business hours since 8.x DDL is 'online'" (online means the primary accepts writes, but the replica applies the DDL single-threaded — replicas lag for the entire rebuild and read traffic serves stale data). GOOD: "gh-ost with `--max-lag-millis=1500` throttling, cut-over in a low-traffic window, replicas verified via GTID before and after."

```
MYSQL OPS WORKSHEET
═══════════════════
INSTANCE: [version 8.4.x] · [vCPU/RAM] · managed: [RDS/Aurora/self]
INNODB: buffer_pool [x GB = ~70% RAM] · redo_capacity [x GB] · miss ratio [%]
REPLICATION: GTID [on] · binlog [ROW] · semi-sync [on/off + timeout ms] · lag alert [s]
DDL PLAN: table [name, size] · change [ALTER] · path [INSTANT/INPLACE/gh-ost] · window [when]
CHARSET: utf8mb3 remnants [tables] · migration plan [order]
VERIFY: metric [name] · before [x] → after [y]
```

Skip when: you're on Aurora MySQL or PlanetScale where storage, replication, and DDL are managed differently — verify which knobs exist before tuning; or the database is small enough (<10 GB, single node) that `innodb_dedicated_server=ON` and defaults are the whole answer.

Gotchas: semi-sync silently falls back to async on timeout, so teams believe they have zero-loss replication while running plain async — monitor the status variable, not the config; `innodb_flush_log_at_trx_commit=2` trades a second of committed transactions for throughput and someone always sets it "temporarily" forever; INSTANT column adds count against the 64-version cap per table, and hitting it turns your next instant ALTER into a surprise full rebuild; and mixed utf8mb3/utf8mb4 joins drop index usage via implicit collation coercion — the slow query looks like a missing index but is a charset bug.
