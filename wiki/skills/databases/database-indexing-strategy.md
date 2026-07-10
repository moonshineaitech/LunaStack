---
name: database-indexing-strategy
description: Use when adding, reviewing, or pruning database indexes — new feature queries, slow-query fixes, or write-latency creep. Produces an index plan: composite column order justified per query, covering/partial index choices, a write-amplification budget per table, and an unused-index audit with drop candidates.
---

# /database-indexing-strategy — Every Index Is a Write Tax

Use to design and prune indexes as a portfolio with a write budget, not as one-off reactions to slow queries.

**Persona: Index Portfolio Manager.** Treats each index as a purchase — names the queries it serves and the write cost it charges — and audits holdings quarterly. Does NOT rewrite application queries or touch schema normalization; the queries are the given, the indexes are the lever.

Composite order is where most indexes go wrong: put **equality columns first, then the sort column, then range predicates** (the ESR rule — identical logic in Postgres, MySQL, and MongoDB), because a range or sort column placed early makes everything after it unusable for filtering. A leftmost prefix serves shorter queries, so `(tenant_id, status, created_at)` usually makes a separate `(tenant_id)` index redundant — delete it. Reach for a **covering index** (`INCLUDE` in Postgres 11+, wide composite in MySQL) when a hot query's `EXPLAIN` shows heap fetches dominating and it reads few columns; reach for a **partial index** (`WHERE status = 'pending'`) when queries only ever touch a small slice — commonly under ~10% of rows — of a large table, cutting both size and write cost. Budget writes explicitly: each secondary index adds roughly one extra write per row change, so hold OLTP tables to ~5 indexes as a soft ceiling and treat every addition past that as needing a named victim. Audit with `pg_stat_user_indexes` (`idx_scan = 0` over a stats window of 30+ days, checked on the primary AND replicas since replica reads don't show on the primary) or MySQL's `sys.schema_unused_indexes`; drop safely in Postgres by observing, then `DROP INDEX CONCURRENTLY`. Rule: **No index ships without the exact query it serves written next to it, and no table exceeds its index budget without dropping a named loser.**

BAD: "Add single-column indexes on every column in the WHERE clause and let the planner combine them" (bitmap-AND rarely beats one correct composite, and you've quintupled write amplification). GOOD: "One composite `(tenant_id, status, created_at DESC)` serving the three dashboard queries; drop the now-redundant `(tenant_id)` index in the same PR."

```
INDEX PLAN
══════════
TABLE: [name] · rows [~n] · write rate [~n/s] · index count [n / budget 5]
ADD: [index def] · serves: [query] · type [composite/covering/partial]
  ESR check: [E cols][S col][R cols] · est. size [~MB]
REDUNDANT: [index] ⊂ [prefix of new index] → drop
UNUSED AUDIT: [index] · idx_scan [0 over Nd, primary+replicas] → drop candidate
VERIFY: EXPLAIN before [plan/cost] → after [plan/cost]
```

Skip when: the table is small (commonly <~10k rows) and sequential scans are already sub-millisecond; or the workload is append-only analytics where a columnar store, not more B-trees, is the answer.

Gotchas: indexing a boolean or low-cardinality column alone buys nothing — fold it into a composite or a partial index's WHERE clause; unused-index audits that ignore replicas delete indexes the read path depended on; unique indexes and those backing constraints can look "unused" but are load-bearing — never drop them on scan counts; and building indexes without `CONCURRENTLY` on a live Postgres table takes a lock that becomes an outage.
