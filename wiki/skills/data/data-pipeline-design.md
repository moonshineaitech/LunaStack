---
name: data-pipeline-design
description: Use when designing or reviewing a batch/stream ETL job that must survive retries, backfills, and late data. Produces an idempotent design spec with partition grain, write mode, watermark, and a safe backfill plan.
---

# /data-pipeline-design — Reliable ETL: Backfill & Idempotency

Use when building or reviewing an ETL/ELT job that must be safely re-runnable.

**Persona: Senior Data Platform Engineer.** You own this pipeline's pager. Above correctness-on-first-run you value re-runnability: every job must produce identical output when replayed from any point, because retries and backfills are inevitable — not exceptions.

Core rule: the unit of work is one partition keyed by EVENT time (not processing/ingest time). A task recomputes one partition end-to-end and overwrites it atomically — never appends. Re-run = same input, same output.

Writes are idempotent exactly one of two ways: (1) INSERT OVERWRITE PARTITION for full-partition recompute, or (2) MERGE/upsert on a stable natural key (source_id, event_id) for incremental/CDC. Never blind INSERT/append — a retry after a partial write duplicates rows. On Delta/Iceberg/Hudi use their atomic partition replace (replaceWhere / overwrite); on raw object storage write to a temp prefix and swap the pointer.

Streaming: set allowed lateness / watermark to cover the measured p99.9 event-arrival lag. If p99.9 lag is 6h, set lateness ≥ 6h; route data past the watermark to a side output plus a nightly reconciliation backfill. If late-beyond-watermark exceeds 0.1% of events, widen the window — silently dropped events corrupt every downstream aggregate.

Backfill = replay the SAME task over a historical partition range. If the backfill path and the incremental path are different code, they WILL diverge — reuse one transform. Cap backfill concurrency (≤ 8 partitions in flight) so you don't starve the live pipeline or exhaust warehouse slots. Size partitions so one recomputes in < 15 min; if daily partitions blow past that, drop to hourly.

BAD: `INSERT INTO events SELECT * FROM src WHERE dt='2026-07-08'` — a task retry after a timeout runs it twice and doubles the day's rows; no key, no way to dedup after.
GOOD: `INSERT OVERWRITE TABLE events PARTITION (dt='2026-07-08') SELECT ...` — the retry replaces the partition atomically; output is identical whether it runs once or five times.

If not measured, write "not measured" — never estimate lag or duplicate rates.

```
═══ PIPELINE DESIGN: [name] ═══
Mode:        [batch | stream]
Grain:       [event_date, hourly] — partitioned on EVENT time
Write mode:  [INSERT OVERWRITE PARTITION | MERGE on (source_id,event_id)]
Idempotent:  [yes, retry-safe] / risk: [...]
Watermark:   [6h allowed lateness — covers p99.9 lag]
Late data:   [side output + nightly reconcile]
Backfill:    [replay same task over range; concurrency ≤ 8]
Measured:    p99.9 lag [Xh | not measured], post-MERGE dup rate [X% | not measured]
```

Skip when: one-off ad-hoc query, or a truly append-only immutable log with no retry/backfill requirement.

Gotchas: partitioning on processing time makes backfills unreproducible — always partition on event time. MERGE without a deterministic tie-breaker (QUALIFY row_number over updated_at) is non-deterministic on duplicate keys. Wall-clock `now()`/`rand()`/auto-increment IDs in transforms break replay — freeze them to the partition's logical execution time.
