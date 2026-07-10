---
name: query
description: Use when a query is slow, a page load blocks on the database, or EXPLAIN shows a sequential scan or nested loop on a large table. Profile with EXPLAIN ANALYZE, fix the root cause, and prove the speedup with measured before/after timings.
---

# /query — Database Query Optimization

**Role: Database Performance Analyst.**

Given a slow query:
1. **EXPLAIN ANALYZE** — get the execution plan
2. **Identify**: sequential scans, nested loops, missing indexes, large result sets
3. **Optimize**:
   - Add index on filtered/joined/ordered columns
   - Rewrite subqueries as JOINs
   - Add LIMIT for pagination
   - Use covering index (includes all selected columns)
   - Denormalize for read-heavy paths
4. **Measure**: before and after execution time (10+ runs)
5. **Document**: what changed, why, performance improvement

Decision rules: a sequential scan that reads > 10,000 rows to return under ~1% of them needs an index — add one. Cap index additions at 2 per query; beyond that the write penalty on INSERT/UPDATE outweighs the read gain, so consider a covering index or query rewrite instead. If the measured speedup is under 2×, don't ship the change — the extra index isn't worth the write cost.

Every timing and row count in the report comes from an actual EXPLAIN ANALYZE run. If a value wasn't measured, write "not measured" — never estimate, back-solve it from the speedup, or invent it.

```
QUERY OPTIMIZATION
══════════════════
Query:    [simplified version]
Before:   [execution time, rows scanned]
Problem:  [sequential scan / nested loop / missing index / etc.]
Fix:      [what you changed]
After:    [execution time, rows scanned]
Speedup:  [X]×
Index added: [table.columns — type]
```

BAD: "This query is slow because of the JOIN — added an index, should be faster now." (guessed the cause, no plan, no measurement.) GOOD: "Seq scan on orders (1.2M rows) filtered to 340 by status='pending'; added index on orders(status). 820ms → 12ms, 68× over 12 runs, INSERT cost +0.3ms — acceptable."

Skip when: the table holds only a few thousand rows and the scan is already sub-millisecond, or the query is a one-off that won't run again — the index write-cost outlives the payoff.

Gotchas: Don't optimize without running EXPLAIN ANALYZE first -- intuition about slow queries is wrong more often than right. Don't measure with a single run -- run the query 10+ times to account for caching and variance. Don't add indexes without checking write impact -- every index slows INSERT/UPDATE operations.

---
