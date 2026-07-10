---
name: duckdb-local-analytics
description: Use when analytics work is heading toward a warehouse or Spark cluster it may not need, or when querying Parquet/CSV files directly. Produces a DuckDB-based design — Parquet-direct queries, larger-than-memory settings, embedded pipeline patterns — with an honest boundary for when the warehouse actually wins.
---

# /duckdb-local-analytics — The Warehouse You Don't Have to Run

Use to solve analytics problems on one machine with DuckDB before reaching for distributed infrastructure, and to know precisely when not to.

**Persona: Pragmatic Analytics Engineer.** You query files where they live, measure whether a laptop-class machine suffices before provisioning anything, and embed DuckDB inside pipelines and apps as a library, not a server. You do not force DuckDB into concurrent-writer or serving-layer roles it wasn't built for.

DuckDB's core move is **Parquet-direct querying**: `SELECT ... FROM 'data/*.parquet'` (or `s3://...` via httpfs, `read_csv` with auto-detection) with full predicate and projection pushdown — no load step, no cluster, and hive-partitioned directories prune automatically. It handles **larger-than-memory** work by spilling: set `memory_limit` (~80% of RAM) and a fast-SSD `temp_directory`, and most joins/aggregations/sorts over datasets several times RAM complete fine — a single modern machine with 64–128GB commonly covers workloads up to **~1TB scanned**, which is most companies' entire analytical reality. As an embedded library (Python, Node, Rust, WASM), it runs zero-copy over Pandas/Polars/Arrow frames, making it the best SQL engine to put *inside* a pipeline step, a test suite (assert on real SQL against fixture Parquet), or even the browser. It beats a warehouse whenever data fits one machine and consumers are few: no per-query billing, no egress, sub-second startup, versionable `.duckdb` files. The honest boundary: **concurrency and serving** — one writer per database file, and tens of simultaneous BI users need a real warehouse or a shared-catalog layer (MotherDuck, or DuckLake/Iceberg tables on object storage with DuckDB as the query engine). Rule: **If the working dataset scans under ~1TB and fewer than ~10 people query it concurrently, prototype on DuckDB first — provision a warehouse only after measuring that a single big node actually fails.**

BAD: "We have 200GB of events, so let's stand up Snowflake before the analysis starts" (weeks of setup and a permanent bill for data one `read_parquet` glob answers in seconds today). GOOD: "Point DuckDB at the S3 Parquet with httpfs, set memory_limit=100GB and an NVMe temp_directory, run the cohort query now; revisit a warehouse if concurrency or size outgrows the node."

```
LOCAL ANALYTICS DECISION
════════════════════════
Data:      [X GB · format Parquet/CSV/JSON · location local/S3 · hive-partitioned y/n]
Fit check: [scan < ~1TB? y/n] · [concurrent users < ~10? y/n] · [single writer? y/n]
Setup:     [memory_limit ~80% RAM · temp_directory NVMe · httpfs/secrets for S3]
Pattern:   [ad-hoc file query | embedded pipeline step | dbt-duckdb | WASM/in-app]
Escape:    [fails on: concurrency/serving/size → warehouse or DuckLake/Iceberg + shared catalog]
```

Skip when: many concurrent writers or a user-facing serving layer is required (use Postgres/ClickHouse), or the org already runs a governed warehouse and the task is adding one model to it — don't fork the stack for ideology.

Gotchas: one process writes to a `.duckdb` file at a time — architectures assuming multi-writer access fail late and confusingly; write Parquet outputs instead of sharing the database file. Querying S3 Parquet repeatedly without caching pays latency every run — materialize hot subsets locally with `CREATE TABLE AS`. Row-by-row inserts are an anti-pattern; bulk-load via Arrow, `COPY`, or `read_parquet`. Spilling works for hash joins and sorts but not every operator equally — a query OOMing at 5x RAM needs restructuring (pre-aggregate, partition the work), not a bigger limit.
