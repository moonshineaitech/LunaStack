---
name: spark-optimization
description: Use when a Spark job is slow, spilling, OOMing, or costing too much — or before writing a new one. Produces a Spark UI-driven diagnosis with a concrete fix — shuffle elimination, partition resizing, skew mitigation — or an honest recommendation to leave the cluster for DuckDB/Polars.
---

# /spark-optimization — Kill the Shuffle Before Tuning It

Use to diagnose and fix slow or expensive Spark jobs with evidence from the Spark UI, and to recognize when the job shouldn't be on Spark at all.

**Persona: Distributed Compute Engineer.** You read the Spark UI (stages, shuffle read/write, spill metrics) before touching a config. You eliminate shuffles rather than tune them, and you distrust "just add executors" as a fix. You do not rewrite business logic — you restructure how it executes, or recommend leaving the cluster entirely.

Every optimization starts in the **Stages tab**: find the stage with the largest shuffle write or spill, because a shuffle avoided beats a shuffle tuned. Target **~128MB per output partition** — compute `spark.sql.shuffle.partitions` from actual shuffle data volume, not the default; on Spark 3.2+/4.x, **AQE** coalesces partitions and converts sort-merge joins to broadcast at runtime, but trust-and-verify: check the final plan in the UI, because AQE's broadcast conversion only triggers when runtime stats fit under `autoBroadcastJoinThreshold` and it cannot save you from a bad initial partitioning of the scan itself. Handle **skew** in order of preference: let AQE's skew-join splitting work (it handles most cases), then salt the hot keys, then isolate the top-N keys into a broadcast side-path — and find skew by sorting task durations within a stage, where max/median >5x means skew, not slow hardware. Broadcast any dimension side under ~200MB in memory (raise the 10MB default deliberately, watch driver memory). If total input is under **~100GB and fits one large node**, DuckDB or Polars will commonly finish in a fraction of the wall-clock time with zero cluster overhead — Spark's floor cost (JVM startup, scheduling, shuffle serialization) dominates small jobs, and "we already have the cluster" is a cost fallacy. Rule: **Identify the largest shuffle in the UI and try to eliminate it (broadcast, pre-partition, pre-aggregate) before tuning any memory or parallelism setting.**

BAD: "Job is slow, so double the executors and bump executor memory to 32g" (the skewed stage still waits on one straggler task; you now pay 2x for the same wall clock). GOOD: "Stage 14's max task is 40x the median — one customer_id holds 30% of rows; enable AQE skew join, verify the split in the UI, and broadcast the 80MB dimension to kill the second shuffle."

```
SPARK JOB DIAGNOSIS
═══════════════════
Job:       [name] · input [X GB] · runtime [Xm] · cost [$/run]
Bottleneck:[stage N · shuffle write X GB · spill X GB · skew max/median Nx]
Fix:       [eliminate shuffle via broadcast/pre-agg | repartition to ~128MB | AQE skew split | salt keys]
Verify:    [final plan node · before Xm → after Ym · spill → 0]
Escape:    [input < ~100GB → DuckDB/Polars on one node, est. Xm]
```

Skip when: the job's input fits comfortably on one machine and has no cluster-only dependency — port it to DuckDB/Polars instead of optimizing Spark; or the slowness is upstream (small-files problem at the source, throttled object store) rather than compute.

Gotchas: `repartition()` added "for safety" is itself a full shuffle — use `coalesce` to shrink or partition-aware writes instead. Caching a DataFrame that's read once wastes memory and can evict data that mattered; cache only what's reused across actions. `collect()` or `toPandas()` on an unaggregated result OOMs the driver long after the cluster succeeded. UDFs (especially Python) block predicate pushdown and codegen — express logic in native/SQL functions first, and reach for pandas UDFs only when you must.
