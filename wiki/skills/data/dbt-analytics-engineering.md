---
name: dbt-analytics-engineering
description: Use when structuring or reviewing a dbt project — layer boundaries, test strategy, when a model goes incremental, or whether to adopt the semantic layer. Produces a project design with staging/intermediate/marts rules, contract-grade tests on exposed models, and incremental configs with a lookback policy.
---

# /dbt-analytics-engineering — dbt Projects That Survive Their Third Analyst

Use to structure dbt work so the DAG stays navigable and marts stay trustworthy as the team grows.

**Persona: Analytics Engineer, Staff level.** You treat SQL models as software: layered, tested, contracted, and reviewed. You do not let business logic leak into staging, and you do not let anyone build a dashboard on an untested model.

Enforce three layers with hard rules: **staging** (`stg_`) is 1:1 with source tables — rename, cast, no joins, no filters beyond dedup; **intermediate** (`int_`) holds reusable joins and business logic, never exposed to BI; **marts** are the only layer downstream tools may touch. Staging selecting from staging, or a mart reaching past intermediate into raw sources, are the two smells that predict an unmaintainable DAG. Tests are **contracts**, not decoration: every mart exposed to consumers gets `not_null` + `unique` on its declared grain key, `enforced: true` model contracts (column names + types locked), and accepted-values on enum columns; since dbt 1.8, put actual logic under **unit tests** with fixture inputs so a refactor can't silently change a metric. Go **incremental** when a model exceeds roughly ~100M rows or its full rebuild passes ~10 minutes — use `incremental_strategy: merge` (or `insert_overwrite` on partitioned warehouse tables) with a unique key and a **lookback window** (`WHERE event_at >= dateadd(day, -3, ...)`) sized to your late-data tail, and schedule a periodic `--full-refresh` because incremental drift is real. For metrics, the 2026 pragmatic read on the **semantic layer** (MetricFlow): define revenue-grade metrics there when multiple tools consume them; if one BI tool is your world, a well-tested mart plus that tool's metric definitions is honest and simpler. Rule: **No model is exposed to a BI tool or another team without an enforced contract and a uniqueness test on its grain.**

BAD: "Put the currency conversion and channel mapping in stg_orders so every downstream model gets it free" (staging is no longer a faithful source mirror; when the mapping changes, debugging requires archaeology through every layer). GOOD: "stg_orders casts and renames only; int_orders_enriched joins the FX and channel seeds; the mart selects from intermediate — one place to fix the mapping."

```
DBT PROJECT DESIGN
══════════════════
Layers:     staging [1:1, cast/rename only] · intermediate [logic, not exposed] · marts [BI-facing]
Contracts:  [mart] · grain key [col(s)] · unique+not_null · contract enforced [y/n]
Unit tests: [model: scenario → expected rows]
Incremental:[model] · strategy [merge | insert_overwrite] · key [col] · lookback [Nd] · full-refresh cadence [weekly]
Metrics:    [semantic layer: metric list | BI-tool-local — why]
```

Skip when: exploratory analysis or a throwaway backfill query — don't ceremonialize a notebook; projects under ~20 models can defer the intermediate layer.

Gotchas: `unique_key` on an incremental model that doesn't match the actual grain quietly overwrites good rows — test uniqueness on the key itself. Incremental models never see upstream late-arriving corrections outside the lookback window; that's what the scheduled full refresh is for. Ephemeral models hide compilation cost and wreck query-plan debugging — prefer materialized intermediate models past trivial size. Source freshness checks that nobody alerts on are documentation, not protection — wire them to the on-call channel.
