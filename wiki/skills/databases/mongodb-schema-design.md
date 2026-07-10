---
name: mongodb-schema-design
description: Use when designing or refactoring MongoDB collections — deciding embed vs reference, planning indexes, or hitting document-growth or 16MB-limit problems. Produces a workload-driven schema decision sheet: access patterns first, embed/reference verdict per relationship, index plan, and growth guards.
---

# /mongodb-schema-design — Model the Queries, Not the Entities

Use to design MongoDB schemas from the workload backward instead of from an ER diagram forward.

**Persona: Document-Model Architect.** Lists every query and write path before drawing a single collection, then chooses embed vs reference per relationship with stated reasons. Does NOT normalize by reflex (that's relational thinking) or embed by reflex (that's the unbounded-array trap), and does not pick the database itself — the schema assumes MongoDB is already chosen.

The core discipline is **workload-first modeling**: enumerate the top queries with their frequency and latency needs, then shape documents so the hottest reads are satisfied by one document fetch. Embed when data is accessed together, owned by the parent, and **bounded** — a good heuristic is embed arrays you can cap at ~a few hundred elements; reference when the child is queried independently, shared across parents, or grows without limit (comments, events, logs). The **16MB document limit** is a cliff, but performance dies first: documents that grow past ~1–2MB churn the WiredTiger cache and make every update expensive, so treat unbounded growth as a bug, not a scaling milestone. For high-cardinality one-to-squillions data use the **bucket pattern** (or native **time series collections** for metrics), and use the **extended reference** pattern — copy the 2–3 fields you actually display — instead of `$lookup` on the hot path. Index for the workload too: follow the **ESR rule** (Equality, Sort, Range) for compound index field order, keep write-heavy collections to roughly ≤ 5–8 indexes, and confirm with `explain("executionStats")` that hot queries are `IXSCAN` with `totalDocsExamined` within ~10× of docs returned. Schema changes ship with a `schema_version` field and lazy migration, not a big-bang rewrite. Rule: **Every embed/reference choice must cite a named query it speeds up and a growth bound that keeps the document under ~1MB.**

BAD: "Embed all of a user's orders in the user document so profile loads are one read" (orders are unbounded — the array bloats, updates rewrite megabytes, and you eventually hit 16MB mid-checkout). GOOD: "Reference orders in their own collection indexed on `{userId: 1, createdAt: -1}`; embed only the last-5 order summaries as an extended reference for the profile card."

```
MONGODB SCHEMA DECISION SHEET
═════════════════════════════
WORKLOAD: [query] · freq [n/s] · latency target [ms] (top 5)
RELATIONSHIP: [parent→child] · verdict [embed/reference/bucket]
  reason: [access pattern] · bound: [max size/count]
INDEXES: [collection: {fields}] · ESR order [E,S,R] · count [n/limit]
GROWTH GUARDS: [field] · cap [n] · doc size ceiling [~MB]
MIGRATION: schema_version [n] · strategy [lazy/backfill]
```

Skip when: the data is genuinely relational with many-to-many joins and multi-document transactional invariants everywhere — pick Postgres instead of contorting the document model; or it's a throwaway prototype where any shape works.

Gotchas: `$lookup` in every hot query means you built a relational schema in Mongo and get the worst of both worlds; unbounded arrays pass code review because they're small in dev; indexing every field "to be safe" doubles write latency and blows the cache; and forgetting that unsharded collections live on one shard — choose the shard key with the schema, not after, because re-sharding under load is the most expensive migration you'll ever run.
