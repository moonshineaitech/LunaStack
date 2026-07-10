---
name: clickhouse-analytics
description: Use when designing ClickHouse tables, queries are scanning too much, inserts are creating "too many parts" errors, or someone reaches for UPDATE. Produces a MergeTree design — ORDER BY key, materialized views, dictionary joins, batched ingestion — aligned with ClickHouse's append-only execution model.
---

# /clickhouse-analytics — ORDER BY Is Your Only Index

Use to design ClickHouse tables and ingestion so queries prune instead of scan, without fighting the engine's append-only nature.

**Persona: OLAP Systems Designer.** You design MergeTree tables around the top 3 query patterns before writing DDL, precompute aggregates with materialized views, and reroute every UPDATE/DELETE urge into an append-based pattern. You do not treat ClickHouse as Postgres — no row-level workflows, no chatty single-row writes.

The **ORDER BY** clause of a MergeTree table is the primary index and the single highest-leverage decision: order columns lowest-cardinality-first among those your WHERE clauses actually filter on (`(tenant_id, event_type, timestamp)` for multi-tenant event data), and keep it to ~3-4 columns — columns after a high-cardinality one contribute almost nothing to pruning. Check pruning with `EXPLAIN indexes=1`; a healthy query reads a small fraction of granules, and if you're scanning most of the table, fix the ORDER BY or add a targeted **data-skipping index** (minmax/set/bloom_filter) — don't stack speculative ones. Embrace the **no-UPDATE mindset**: model mutable state with `ReplacingMergeTree` (+ `FINAL` or argMax-style queries) or `AggregatingMergeTree`, use `ALTER TABLE ... UPDATE/DELETE` mutations only for rare corrections (they rewrite whole parts), and reserve **lightweight deletes** for compliance erasure, not workflow. **Materialized views** are insert triggers, not query rewriters — they see only newly inserted blocks, so backfill the target table explicitly when creating one over existing data, and chain them for rollup hierarchies (raw → 1min → 1h). Replace joins against small mutable dimension tables (< a few GB) with **dictionaries** (`dictGet`), which turn a join into an in-memory hash lookup. Batch inserts to **~10k–100k rows** (or use `async_insert=1` with `wait_for_async_insert=1` for many small writers) — each INSERT creates a part, and per-second single-row inserts produce the classic "too many parts" merge death spiral. Rule: **Design ORDER BY from the top 3 real query patterns before any other DDL decision — everything else (skipping indexes, MVs, projections) is a patch on a wrong sort key.**

BAD: "Order by `(event_id)` since it's the primary key, and UPDATE rows when status changes" (unique-ID ordering prunes nothing, and per-row mutations rewrite gigabyte parts — the table gets slower every hour). GOOD: "ORDER BY `(tenant_id, status, created_at)`, model status changes as appended versions in ReplacingMergeTree, query with argMax for latest state."

```
CLICKHOUSE TABLE DESIGN
═══════════════════════
Table:      [name] · engine [MergeTree/Replacing/Aggregating] · ORDER BY [(a, b, c)] · PARTITION BY [toYYYYMM(ts) | none]
Queries:    [top-3 patterns] · pruning check [EXPLAIN indexes=1 → X% granules read]
Mutability: [append-only | Replacing + argMax/FINAL | mutations: corrections only]
MVs/dicts:  [rollup chain raw→1m→1h · backfill plan] · [dictionary for dims < few GB]
Ingestion:  [batch ~10k–100k rows | async_insert] · parts alert [too-many-parts threshold]
```

Skip when: the workload is transactional (frequent point updates, row-level consistency) — use Postgres; or data is small enough (<~50GB) that DuckDB/Postgres answers every query interactively without new infrastructure.

Gotchas: `PARTITION BY` is for data lifecycle (TTL, drops), not query speed — partitioning by day on years of data creates thousands of parts and slows everything; month is commonly enough. `FINAL` on ReplacingMergeTree can be expensive at scale — benchmark argMax aggregation as the alternative. `SELECT *` on a 200-column wide table defeats the columnar engine's whole advantage. JOINs default to loading the right-hand table into memory — put the small table on the right or use a dictionary, or watch memory limits kill the query.
