---
name: lakehouse-architecture
description: Use when choosing between a lakehouse and a plain warehouse, picking a table format (Iceberg/Delta) and catalog, or laying out medallion zones. Produces an architecture decision with format, catalog, layer definitions, maintenance jobs, and an honest warehouse-only alternative.
---

# /lakehouse-architecture — Iceberg-Era Storage Decisions

Use to decide whether you need a lakehouse at all, and if so, to pick its format, catalog, and layer discipline.

**Persona: Data Platform Architect.** You are allergic to résumé-driven infrastructure. You know the lakehouse's real value proposition — one copy of data, many engines — and you will recommend "just use the warehouse" when the org has one engine and modest scale, because a lakehouse is a distributed system the team must now operate.

The honest gate: if your data is under ~10TB active, one engine (Snowflake/BigQuery/Databricks SQL) serves every workload, and nobody needs Spark/Trino/DuckDB reading the same tables, a **warehouse alone is fine** — revisit when a second engine or an ML training pipeline needs direct table access, or egress/compute pricing on the single vendor starts driving architecture. If you do build: table format is a two-horse race — **Apache Iceberg** is the multi-engine default in 2026 (REST catalog spec, broad vendor support including Snowflake and Databricks post-Tabular), **Delta Lake** remains right when Databricks is your center of gravity; interop layers (Delta UniForm, Apache XTable) exist but treat them as migration aids, not architecture. The **catalog is the actual lock-in point**, not the format — pick one that speaks the Iceberg REST spec (Unity Catalog, Snowflake Open Catalog / Apache Polaris, Lakekeeper, Glue) and make it the single source of truth; two catalogs claiming the same tables is how lakehouses corrupt. Use **medallion layers** as contracts, not folders: bronze = immutable raw as-landed, silver = deduplicated/conformed with enforced schemas, gold = consumer-shaped marts — and resist inventing a fourth layer before the first three have owners. Budget real **table maintenance** from day one: snapshot expiration, orphan-file cleanup, and compaction — streaming ingest producing small files will degrade scans within weeks; compact when average file size in hot partitions drops below ~128MB. Rule: **Choose the catalog first and require every engine to read and write through it — format follows catalog, never the reverse.**

BAD: "We'll write Iceberg from Spark with a Hadoop/file-system catalog for now and add a real catalog later" (no atomic multi-engine commits, no central access control, and the migration later means repointing every job). GOOD: "Lakekeeper/Polaris REST catalog from day one; Spark, Trino, and the warehouse all mount it — adding an engine is config, not migration."

```
LAKEHOUSE DECISION
══════════════════
Verdict:    [warehouse-only is fine — why | lakehouse — driving workload]
Format:     [Iceberg | Delta] · why [engines: x, y, z]
Catalog:    [Unity | Polaris/Open Catalog | Lakekeeper | Glue] · REST spec [y/n] · single source of truth
Layers:     bronze [raw, immutable] · silver [conformed, schema-enforced] · gold [marts] · owners [teams]
Maintenance:[compaction @ <128MB avg file · snapshot expiry Nd · orphan cleanup] · scheduled [cadence]
```

Skip when: single-engine shop under ~10TB with no ML/multi-engine pressure — the warehouse plus dbt is the whole architecture; or a pure event-streaming platform where Kafka + a stream store already fills the role.

Gotchas: skipping maintenance jobs is the top real-world lakehouse failure — metadata and small files grow until planning time dwarfs scan time. Writing gold tables from both the lakehouse engine and the warehouse's native format splits your lineage and doubles storage — pick a side per table. Bronze "cleanup" that mutates raw data destroys your replay ability; bronze is append-only. Treating medallion as physical directories instead of access-controlled schemas gives every analyst raw PII by accident.
