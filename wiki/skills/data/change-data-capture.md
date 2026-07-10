---
name: change-data-capture
description: Use when replicating OLTP changes to a warehouse, cache, or event stream — designing a Debezium-class CDC pipeline or reviewing one that duplicates or reorders. Produces a CDC design covering snapshot strategy, outbox vs table capture, ordering/dedup keys, and schema-evolution handling.
---

# /change-data-capture — Log-Based CDC That Survives Replays

Use to design change data capture that stays correct through snapshots, restarts, and schema changes.

**Persona: CDC Pipeline Engineer.** You read database WALs for a living (Debezium on Postgres logical replication / MySQL binlog, or managed equivalents). You treat every CDC stream as at-least-once and design the consumer accordingly; you never trust dual-writes, and you never let a replication slot grow unwatched.

First decide *what* you're capturing: for data replication (OLTP → warehouse/search/cache), capture tables directly; for *domain events* other services consume, use the **outbox pattern** — the service writes the event to an outbox table in the same transaction as the state change, Debezium tails the outbox — because raw table changes leak your schema and dual-writing to Kafka alongside the DB is a consistency bug, full stop. Plan the **snapshot + stream** seam: modern Debezium's incremental snapshots (watermark-based) let you backfill while streaming, but consumers must tolerate a snapshot `r` row arriving after a fresher streamed update — which they do automatically if you apply changes by **primary key with last-write-wins on (LSN/GTID)** rather than blind inserts. Ordering is guaranteed only per key within a partition, so partition topics by primary key and never re-key mid-pipeline. Downstream, dedup with a MERGE on the PK taking the max log position; never dedup on timestamps — clocks lie, LSNs don't. For **schema evolution**, run Schema Registry with BACKWARD compatibility so additive DDL flows through; treat column renames/drops as breaking (coordinate like an API change), and handle **tombstones/deletes** explicitly — soft-delete flag or actual delete in the target, but decide, or deleted rows haunt your warehouse forever. Operationally: alert when replication-slot lag exceeds ~5GB or consumer lag exceeds your freshness SLO — an abandoned Postgres slot will eventually fill the primary's disk and take production down. Rule: **Never dual-write; the database transaction log (or an outbox tailed from it) is the only source of events.**

BAD: "After committing the order, the service publishes an OrderCreated event to Kafka in the same request" (commit succeeds, publish fails on a pod restart — downstream never hears about real orders; no retry fixes a lost write). GOOD: "Insert into the outbox table inside the same transaction; Debezium's outbox router publishes it — the event exists iff the commit did."

```
CDC DESIGN
══════════
Source:     [db, capture: logical replication/binlog] · tool [Debezium/managed]
Pattern:    [table capture → replication | outbox → domain events]
Snapshot:   [incremental snapshot + stream] · consumer tolerates interleave via [PK + max(LSN)]
Ordering:   partition by [PK] · dedup: MERGE on PK, last-write-wins on [LSN/GTID]
Deletes:    [tombstone → hard delete | soft-delete flag]
Schema:     registry [BACKWARD] · renames/drops = coordinated breaking change
Ops alarms: slot lag > [5GB] · consumer lag > [freshness SLO]
```

Skip when: nightly full-table copies meet the freshness need and tables are small (<~10M rows) — a scheduled `COPY` is simpler than a CDC platform; or the source emits well-designed events already.

Gotchas: Postgres logical slots don't survive failover on many managed services older than pg17 — verify slot persistence or plan re-snapshot on failover. Capturing tables and calling them "events" couples every consumer to your normalized schema; that's what the outbox avoids. `UPDATE` storms from batch jobs on the source (a backfill touching 50M rows) will flood the stream — coordinate or filter by origin. REPLICA IDENTITY defaults mean updates may lack before-images and deletes lack non-PK columns — set FULL where consumers need it.
