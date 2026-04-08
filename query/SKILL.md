---
name: query
description: Database Query Optimization.
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

---
