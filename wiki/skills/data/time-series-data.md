---
name: time-series-data
description: Use when storing or querying high-volume time-series (metrics, events, sensor/IoT, financial ticks) and ingest rate, cardinality, or query latency is a concern. Produces an engine + schema + partitioning + rollup decision that keeps index growth bounded and dashboard queries fast.
---

# /time-series-data — High-Volume Time-Series Storage & Query

Use when designing or fixing storage/queries for high-volume time-series (metrics, IoT, ticks, logs-as-metrics).

**Persona: Time-Series Storage Engineer.** You treat cardinality as the primary cost driver and time-partitioning as non-negotiable; bounded index growth and partition pruning outrank query cleverness every time.

Model the data first: split columns into low-cardinality dimensions (region, status, device_type → tags/labels or ORDER BY keys), high-cardinality identifiers (user_id, request_id, uuid), and measured values. Decision rule: any dimension with > 100k distinct values is a FIELD/column, never a tag/label — in Prometheus/InfluxDB each distinct label combination is one stored series, so a high-cardinality label multiplies the inverted index and OOMs the instance. Keep active series per Prometheus/VictoriaMetrics instance in the low millions.

Partition by time, always. Size the chunk/partition interval so the actively-written chunk plus its indexes fit in ~25% of RAM (TimescaleDB hypertable default 7 days; tune down for heavy ingest). This buys partition pruning on reads and O(1) retention — drop the chunk, never DELETE rows.

Compress cold chunks: delta-of-delta for timestamps + Gorilla/XOR (or ZSTD) for values reaches ~1.37 bytes/point (~10x) — but only if rows are stored ordered by (series, time). Downsample: pre-compute continuous aggregates / materialized rollups at 1m, 1h, 1d; dashboards query the rollup matching their resolution, never raw over long windows. Trigger a rollup when a dashboard query's p99 > 200ms or it scans > 10M raw rows. Tier retention: raw short TTL (e.g. 7–30d), rollups long (1–2y). Batch writes 5k–10k+ rows; on ClickHouse cap inserts at ~1/s per table.

Engine fit: metrics/monitoring → Prometheus + VictoriaMetrics/Mimir/Thanos; SQL + relational joins → TimescaleDB; heavy analytical scans over wide aggregations → ClickHouse (MergeTree, PARTITION BY toYYYYMM, ORDER BY (series, ts)); extreme ingest → QuestDB.

BAD: `http_requests_total{user_id="u_8f3...", path="/checkout"}` — user_id as a label. 2M users → 2M+ series, inverted index explodes, Prometheus OOMs and even queries that ignore user_id slow down.
GOOD: labels = bounded dimensions only (`{route="/checkout", status="200", region="us-east"}`); keep user_id as an exemplar or in a separate event store (ClickHouse column), queried by time range.

If the output reports cardinality or compression ratio: if not measured, write "not measured", never estimate.

```
═══ TIME-SERIES SCHEMA — [dataset] ═══
Engine:       [TimescaleDB | ClickHouse | Prometheus+VM | QuestDB]
Partition:    by time, [interval] chunks   pruning:[yes/no]
Tags/labels:  [list] — max cardinality [N | not measured]
Fields:       [list]  (high-card IDs + values live here)
Compression:  [delta-of-delta ts + Gorilla/ZSTD]  ratio:[Nx | not measured]
Rollups:      raw TTL [Nd] → [1m/1h/1d] agg TTL [N]
Scale:        [N] active series | ingest [N rows/s] batched [N]
```

Skip when: low volume (< ~1M rows total, or a single dashboard) where a plain indexed Postgres/SQLite table is simpler; or one-off analysis of a static export (use DuckDB/Parquet, not a TSDB).

Gotchas: retention via DELETE scans and bloats the table — DROP the partition/chunk (metadata-only) instead. ClickHouse "Too many parts" comes from many small inserts — batch and stay under ~1 insert/s/table or merges storm. Compression ratio silently collapses when ingest is out-of-order — Gorilla/columnar assume monotonic (series, time) on disk.
