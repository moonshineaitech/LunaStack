---
name: sqlite-in-production
description: Use when evaluating SQLite as the production server database, or when operating one (WAL mode, backups, write contention). Produces a fit verdict plus a deployment checklist: WAL and pragma settings, single-writer mitigations, Litestream/LiteFS replication, and the explicit triggers that mean it's time to move to Postgres.
---

# /sqlite-in-production — One File, Zero Ops, Known Limits

Use to decide whether SQLite is the right server database and to configure it so it survives production.

**Persona: Small-Infrastructure Pragmatist.** Judges SQLite on the actual workload — writes/sec, concurrency, node count — not on reputation, and configures it deliberately rather than accepting defaults. Does NOT evangelize SQLite everywhere, and does NOT design multi-node write topologies on top of it: one writer node is the contract.

SQLite is a legitimate server database in 2026 when the app runs on **one node** (or one writer with read replicas) and sustained writes stay modest — commonly under ~1k write TPS with millisecond transactions; reads scale nearly for free since they cost no network hop. The non-negotiable setup: `PRAGMA journal_mode=WAL` (readers stop blocking the writer), `PRAGMA busy_timeout=5000`, `PRAGMA synchronous=NORMAL` (safe in WAL, much faster), `PRAGMA foreign_keys=ON`, and in your driver use `BEGIN IMMEDIATE` for write transactions so lock acquisition fails fast at start instead of deadlocking mid-transaction. The single-writer reality means one connection pool for writes (size 1) and a separate read pool; long write transactions are the whole failure mode, so keep them under ~100ms. For durability, **Litestream** streams the WAL to S3-compatible storage continuously (near-zero RPO for pennies), and **LiteFS** or **Turso/libSQL** cover the read-replica / edge-replication era — but the moment you need multiple independent writer nodes, multi-region writes, or connections from many app servers, that is the Postgres trigger, and migrating early is cheap while migrating late is a rewrite. Never back up by copying the live `.db` file — use `VACUUM INTO`, the `.backup` API, or Litestream snapshots. Rule: **Adopt SQLite only if you can name the single writer node today and describe the Postgres migration trigger in one sentence.**

BAD: "We'll run SQLite on each of our three app servers behind the load balancer" (three divergent databases, no single source of truth — corruption of the business, not the file). GOOD: "One Fly.io/VM writer node with WAL + Litestream to R2; scale reads with LiteFS replicas; move to Postgres when we need a second writer."

```
SQLITE PRODUCTION CHECKLIST
═══════════════════════════
FIT: nodes [1?] · write TPS [~n] · verdict [adopt/skip]
PRAGMAS: WAL [on] · synchronous [NORMAL] · busy_timeout [ms] · fk [on]
WRITES: pool size [1] · txn style [BEGIN IMMEDIATE] · max txn [ms]
REPLICATION: [Litestream→bucket / LiteFS / Turso] · RPO [~s]
BACKUP: method [VACUUM INTO/.backup/snapshot] · restore tested [date]
EXIT TRIGGER: [condition that forces Postgres]
```

Skip when: you already need multiple writer nodes, >~1k sustained write TPS, or DB connections from many horizontally-scaled app servers — start on Postgres; or the platform is serverless-per-request with no persistent disk.

Gotchas: forgetting `busy_timeout` turns routine lock contention into `SQLITE_BUSY` errors that look like bugs; deferred transactions that upgrade to write locks mid-flight are the classic deadlock — `BEGIN IMMEDIATE` fixes it; the WAL file grows unbounded if a long-lived read connection blocks checkpoints (watch for multi-GB `-wal` files); and network filesystems (NFS, EFS) break SQLite's locking — local disk only, always.
