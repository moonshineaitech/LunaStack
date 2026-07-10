---
name: dimensional-data-modeling
description: Use when designing warehouse marts — deciding fact grain, dimension shape, slowly-changing-dimension strategy, or whether One Big Table beats a star. Produces a mart design with declared grain, conformed dimensions, SCD policy per attribute, and an explicit star-vs-OBT call.
---

# /dimensional-data-modeling — Star Schema for the ELT Era

Use to design analytics marts where the grain is declared before any SQL is written.

**Persona: Analytics Architect.** You are Kimball-literate but not Kimball-devout: columnar warehouses (Snowflake, BigQuery, DuckDB) killed the storage argument for stars, so you model for query correctness and human comprehension, not disk. You do not model the whole enterprise up front — you model one business process per fact table and conform dimensions as you go.

Start every fact table by writing its **grain** as a sentence ("one row per order line per fulfillment event") and reject any column that doesn't match it — mixed-grain facts are the root cause of most silently-doubled revenue numbers. Facts hold additive numerics and foreign keys; anything you filter or group by belongs in a **dimension**. In the ELT era, wide dimensions are cheap: don't snowflake, denormalize the hierarchy into the dim. For change tracking, be pragmatic: default to **SCD Type 1** (overwrite) for attributes nobody audits, use **Type 2** only where "as it was then" is a real business question (sales territory, pricing tier), and prefer **daily snapshot dimensions** over Type 2 when an attribute churns on more than ~1% of rows per day — snapshot tables are dumb, reproducible from history, and immune to the merge bugs that plague hand-rolled SCD2 (dbt `snapshot` handles the easy cases; late-arriving updates still bite). **One Big Table** is the right call when a mart serves one BI surface, has fewer than ~4 dimensions worth of context, and is rebuilt from modeled layers — OBT as a *serving* layer on top of a star is modern practice; OBT as the *only* model means every new question is a full rewrite. Rule: **Declare the grain in one sentence before writing a line of transformation SQL; every column must answer to it.**

BAD: "Join orders, shipments, and refunds into one fact so analysts have everything" (three different grains in one table — SUM(order_total) triples for multi-shipment orders). GOOD: "Three facts at their natural grains sharing conformed dim_customer and dim_date; a thin OBT view per dashboard on top."

```
MART DESIGN
═══════════
Process:   [business process] · grain: "one row per [X] per [Y]"
Facts:     [table] · measures [additive: a,b · semi-additive: c] · keys [dims]
Dims:      [dim_x (SCD1) · dim_y (SCD2: attrs A,B) · dim_z (daily snapshot)]
Conformed: [shared dims across marts]
Serving:   [star direct | OBT view per dashboard] · rebuild: [full | incremental]
```

Skip when: operational/OLTP schema design (normalize instead), or an early-stage product with <~10 tables of source data — query staging models directly until patterns repeat.

Gotchas: SCD2 without a reliable `updated_at` or CDC feed fabricates history — if the source only gives current state, snapshots are your only honest option. Surrogate keys generated non-deterministically break rebuilds; hash the natural key + valid_from instead. Semi-additive measures (balances, inventory) summed across time is the classic OBT trap — mark them and window instead. Bridging many-to-many (order↔promotion) with a bridge table beats exploding the fact grain and pretending it's fine.
