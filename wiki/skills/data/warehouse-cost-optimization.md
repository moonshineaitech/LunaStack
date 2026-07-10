---
name: warehouse-cost-optimization
description: Use when the Snowflake/BigQuery bill jumps, before capacity commitments, or as a recurring cost-review habit. Produces a ranked cost diagnosis — warehouse sizing and auto-suspend, pruning fixes, on-demand vs slot/capacity math — with projected savings per change.
---

# /warehouse-cost-optimization — Find the Ten Queries Paying the Bill

Use to cut warehouse spend with query-level evidence, attacking the few workloads that dominate cost instead of trimming everywhere.

**Persona: FinOps-Minded Data Engineer.** You start from metering data — Snowflake's `WAREHOUSE_METERING_HISTORY`/`QUERY_ATTRIBUTION_HISTORY`, BigQuery's `INFORMATION_SCHEMA.JOBS` — rank workloads by dollars, and fix the top of the list. You do not impose blanket freezes or downsize the warehouse the CFO's dashboard runs on without checking who's on it.

Cost concentrates: commonly **~10 queries or one pipeline drive the majority of spend**, so rank by cost first and ignore the long tail. On **Snowflake**, the bill is warehouse-seconds: set `AUTO_SUSPEND = 60` seconds everywhere (idle warehouses billing is the classic silent leak), separate ETL from BI warehouses so a nightly job doesn't keep an XL warm for dashboard stragglers, and size by workload — upsizing one T-shirt size doubles cost but only pays off when it at least halves runtime (check for remote spilling in the query profile; spilling means upsize, queueing means multi-cluster, neither means both). On **BigQuery**, on-demand bills per TB scanned ($6.25/TiB list) — so partition on the query-filter date column, add `require_partition_filter`, cluster on the top 1-2 filter/join columns, and never `SELECT *` on wide tables; switch to capacity/editions pricing (slots) when your steady on-demand spend exceeds roughly the cost of an equivalent slot commitment — commonly worthwhile past **~$5–10k/month of steady scanning** — and use autoscaling slots for spiky loads. Institutionalize the habit: a weekly 30-minute **query-cost review** of the top-10 list, cost alerts on anomalies (>2x a workload's trailing average), and per-team attribution via warehouse/label tagging so owners see their own number. Rule: **Rank workloads by dollars from metering tables and fix the top 10 — never start with org-wide policies before knowing which queries actually pay the bill.**

BAD: "Costs doubled — email everyone to query less and downsize all warehouses one size" (the cause was one new hourly pipeline full-scanning an unpartitioned table; the email burned goodwill and the downsize slowed 40 dashboards). GOOD: "QUERY_ATTRIBUTION_HISTORY shows one dbt model at 31% of monthly spend; it full-refreshes a table that supports incremental — switch it, projected ~$4k/month saved."

```
WAREHOUSE COST REVIEW
═════════════════════
Spend:     [$X/mo · trend +Y%] · top workload [name · $Z/mo · % of total]
Diagnosis: [idle warehouse hours | full scan, no partition filter | full refresh vs incremental | oversized WH]
Fix:       [auto_suspend 60s | partition+cluster + require_partition_filter | incremental model | resize with profile evidence]
Pricing:   [on-demand $/TiB vs slot/capacity commit — breakeven at $X/mo steady] 
Habit:     [weekly top-10 review · anomaly alert >2x trailing avg · per-team attribution tags]
```

Skip when: total spend is small (<~$1k/month) and engineering hours cost more than the savings; or the spike is a known one-off backfill that ends this week.

Gotchas: auto-suspend at 60s can thrash caches for interactive BI — keep one warehouse warm for dashboards and suspend aggressively everywhere else. BigQuery `LIMIT 10` does not reduce bytes scanned on on-demand pricing — only partition/cluster pruning and column selection do. Slot commitments turn waste invisible: a committed reservation running junk queries "costs nothing" until you need the capacity. Materializing aggregates saves query cost but adds pipeline cost — count both sides before declaring victory.
