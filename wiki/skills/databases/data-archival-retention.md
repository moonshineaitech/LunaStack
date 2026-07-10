---
name: data-archival-retention
description: Use when tables grow without bound, compliance demands retention limits, or deletes are melting the database. Produces a retention design: per-data-class retention policy, hot/warm/cold tier mapping, partition-drop archival so retention is O(1) instead of DELETE storms, restore-tested archive procedure, and a delete-actually-deletes audit for GDPR-class erasure.
---

# /data-archival-retention — Retention as Architecture, Not a Cron DELETE

Use to design data lifecycle so aging data gets cheaper to keep, cheap to drop, and provably gone when the law says gone.

**Persona: Data Lifecycle Engineer.** Classifies data before choosing storage, designs deletion into the schema from the start, and does NOT run mass `DELETE` jobs on large tables or call data "deleted" while it lives on in backups, replicas, and analytics exports unacknowledged.

Start with a **retention policy per data class**, not per table: regulated financial records (commonly 7 years), auth/security logs (~1 year), operational events and telemetry (30–90 days), PII under GDPR/CCPA (only as long as the stated purpose — plus erasure on request). Then map classes to tiers: **hot** in the OLTP database, **warm** in cheap columnar (Parquet on S3/GCS, queryable via DuckDB, Athena, or Iceberg tables), **cold** in Glacier-class storage with retrieval SLAs documented. The mechanism that makes this survivable: **time-based partitioning** (pg_partman on Postgres, or native range partitions) so retention is `DETACH`/`DROP PARTITION` — an O(1) metadata operation — instead of a DELETE that bloats the table, lags replicas, and starves autovacuum for days; adopt partitioning once a table passes ~100GB or a retention cycle would delete more than ~5% of rows. Export the partition to Parquet before dropping (archive-then-drop, verified row counts), and treat an archive nobody has restored as nonexistent: schedule a quarterly **restore test** that pulls a random archived partition and runs a checksum/row-count reconciliation. For erasure requests, run the **delete-actually-deletes audit**: enumerate every copy — replicas (fine, they follow), backups (deleted data persists until backup retention expires — lawful under GDPR if disclosed and your restore runbook replays pending erasures), search indexes, caches, analytics warehouse, data lake, logs, and vendor exports — and either purge each or use **crypto-shredding** (per-user encryption keys; destroy the key, all copies become ciphertext) where purging is impractical. Rule: **If honoring your retention policy requires DELETE on a large table, the schema is wrong — repartition so retention is a partition drop with an archived, restore-tested copy.**

BAD: "Nightly cron: DELETE FROM events WHERE created_at < now() - interval '90 days'" (on a 2TB table this runs for hours, doubles WAL, lags replicas, and the space never returns without VACUUM FULL). GOOD: "Daily partitions via pg_partman; the retention job exports the 91st-oldest partition to Parquet, verifies counts, then DROPs it — milliseconds, zero bloat."

```
RETENTION DESIGN
════════════════
DATA CLASSES: [class → retention → legal basis] (one line each)
TIERS: hot [DB, n days] · warm [Parquet/S3 via DuckDB/Athena, n months] · cold [Glacier, n yrs]
MECHANISM: [pg_partman daily/monthly partitions] · retention op: [export→verify→drop]
RESTORE TEST: cadence [quarterly] · last pass: [date] · check: [rowcount+checksum]
ERASURE AUDIT: copies enumerated [backups/indexes/warehouse/logs/vendors]
  · purge or crypto-shred per copy · backup-replay runbook: [link/status]
```

Skip when: total data is under ~50GB with no compliance retention limits — a simple indexed DELETE job is fine at that scale; or the data lives in a system with native TTL (DynamoDB TTL, ClickHouse TTL clauses, S3 lifecycle rules) — configure that instead of building your own.

Gotchas: partitioning an existing huge table is itself a migration project (pg_partman helps, but plan a backfill window) — retrofitting at 2TB is 10× the pain of designing it in at 100GB; foreign keys pointing at partitioned tables constrain what you can detach, so archive-bound tables should be referenced loosely (no FK) or via the partition key; "anonymized" data that keeps user_id joins is pseudonymized, not erased, and fails a GDPR audit; and S3 lifecycle rules that transition tiny Parquet files to Glacier can cost more in transition requests than the storage saved — compact files to ≥~100MB first.
