---
name: database-replication-topologies
description: Use when designing or auditing database replication — adding read replicas, choosing async vs semi-sync, planning automated failover, or debugging stale reads. Produces a topology design with an explicit lag budget, a read-your-writes strategy, failover automation with split-brain guards, and a logical-vs-physical replication decision.
---

# /database-replication-topologies — Replication Is a Consistency Contract, Not a Checkbox

Use to design replication with honest answers to the two questions teams dodge: how stale can a read be, and who is allowed to promote a new primary.

**Persona: Replication Architect.** Writes down the lag budget and durability requirement before picking a mode, designs failover as a state machine with fencing, and tests promotion quarterly. Does NOT add read replicas as a performance fix without solving read-your-writes, and does NOT hand-roll failover scripts when Patroni, MySQL Group Replication, or the cloud provider's orchestrator exists.

Start async (it's the right default) but be honest that async replicas serve the past: replica lag is normally sub-second and spikes to minutes during bulk writes, vacuums, or DDL — so every read-replica rollout needs a **read-your-writes strategy**, chosen per app: (1) session pinning — route a user's reads to the primary for ~5–10 s after their write; (2) causal tokens — capture the primary's LSN/GTID after write and have the replica wait for it (`pg_last_wal_replay_lsn` comparison, MySQL `WAIT_FOR_EXECUTED_GTID_SET`), which routers like PgCat/ProxySQL can automate; or (3) declare the surface eventually-consistent on purpose (feeds, analytics). Additionally, health-check lag and eject any replica beyond your budget (commonly 10–30 s) from the read pool rather than serving arbitrarily stale data. **Semi-sync/quorum commit** (Postgres `synchronous_standby_names = ANY 1(...)`, MySQL semi-sync, Aurora/AlloyDB storage-level quorum) buys zero-data-loss failover for one extra network RTT per commit — take that deal for money-moving writes, but know the failure mode: a dead standby either stalls commits (Postgres, until you edit config) or silently degrades to async (MySQL after timeout) — decide which you want and alert on it. Failover automation is a consensus problem: use **Patroni** (etcd/Consul-backed) or Group Replication/Orchestrator rather than a cron script, require an odd-numbered quorum of observers across failure domains, and make **fencing** non-negotiable — the old primary must be provably unable to accept writes (kill via DCS lock expiry, block at the VIP/proxy layer, or STONITH) before promotion, because split-brain from a network partition is how you lose data twice. Choose **physical replication** (WAL/redo shipping) for HA and identical replicas — it's simpler and byte-faithful; choose **logical replication** (Postgres publications, Debezium CDC, binlog consumers) for major-version upgrades, selective table replication, cross-engine feeds, and multi-tenant splits — accepting its costs: DDL doesn't replicate, sequences need handling, and slot retention on the primary can fill disks if a consumer stalls (cap with `max_slot_wal_keep_size`). Rule: **No automated failover without fencing plus an odd-quorum arbiter, and no read replica in the pool without a defined lag budget and eviction check.**

BAD: "Two nodes with a keepalived VIP and a script that promotes the standby when it can't ping the primary" (a network partition makes both nodes primary; writes diverge and someone hand-merges rows at 3 a.m.). GOOD: "Patroni with a 3-node etcd cluster across AZs; leader key expiry demotes the isolated primary before the standby is promoted, and the proxy only routes to the DCS-confirmed leader."

```
REPLICATION TOPOLOGY DESIGN
═══════════════════════════
DURABILITY: RPO [0 / seconds] → mode [async / semi-sync ANY n / quorum]
TOPOLOGY: primary [az] · sync standbys [n] · async replicas [n, regions]
LAG BUDGET: [s] · eviction check [probe + threshold] · alert [channel]
READ-YOUR-WRITES: strategy [pin ns / LSN-wait / eventual-by-design] · router [PgCat/ProxySQL/app]
FAILOVER: orchestrator [Patroni/GR/cloud] · quorum [n nodes, domains] · fencing [mechanism]
LOGICAL STREAMS: [publication/CDC → consumer] · slot cap [max_slot_wal_keep_size]
DRILL: last promotion test [date] · measured RTO [s]
```

Skip when: a managed platform owns the topology end-to-end (Aurora, Cloud SQL HA, Neon) — audit its RPO/RTO claims and failover behavior instead of designing your own; or a single node with tested PITR backups meets the availability target (many internal apps).

Gotchas: adding replicas to "fix performance" while the app reads its own writes produces heisenbugs that vanish in dev where lag is zero; semi-sync confirms the standby *received* the WAL, not that it *applied* it — reads on the standby can still trail an acknowledged commit; failover automation that's never drilled fails at 3 a.m. in the one state you didn't test, so schedule promotions (commonly quarterly) and measure RTO; and an orphaned logical replication slot quietly retains WAL until the primary's disk fills — the outage arrives weeks after the consumer died.
