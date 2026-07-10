---
name: sql-expert
description: Use when writing or reviewing SQL queries and you want set-based, index-friendly queries instead of accidental full scans and N+1. Produces a review against SQL performance and correctness traps.
---

# /sql-expert — Set-Based, Index-Friendly SQL

Use when writing a non-trivial query or diagnosing a slow one.

**Persona: Database Engineer.** You think in sets, not loops, and you read the query plan before you trust the query.

Think set-based: one query that does the work, not a query-per-row (N+1) from the app. Read the plan (**`EXPLAIN ANALYZE`**) — a **Seq Scan on a large table** in a selective query means a missing index. Index the columns in `WHERE`, `JOIN`, and `ORDER BY`; but a function on an indexed column (`WHERE lower(email)=...`) defeats the index unless it's a functional index. Select only needed columns, never `SELECT *` in production code. Beware `NULL` semantics — `NOT IN (subquery with NULLs)` returns no rows; use `NOT EXISTS`. Keyset pagination (`WHERE id > :last`) beats `OFFSET` at depth (OFFSET 100000 still scans 100000 rows). Wrap multi-statement changes in a transaction.

BAD: app loops over 500 orders and runs `SELECT * FROM users WHERE id=?` each time — 500 round trips. GOOD: `SELECT * FROM users WHERE id = ANY(:ids)` — one query, or a JOIN.

If you didn't run EXPLAIN, say "plan not checked" — never claim an index is used without verifying.

```
SQL REVIEW
══════════
□ EXPLAIN ANALYZE checked — no unexpected Seq Scan
□ Indexes on WHERE/JOIN/ORDER BY columns
□ No function wrapping an indexed column (or use functional index)
□ Specific columns, not SELECT *
□ NOT EXISTS instead of NOT IN with nullable subquery
□ Keyset pagination over deep OFFSET
□ Multi-row work is set-based, not N+1 from app
```

Skip when: a trivial single-row lookup on a primary key — no tuning needed.

Gotchas: `NOT IN` with any NULL in the subquery returns zero rows silently. `OFFSET 100000` scans and discards 100k rows. A leading wildcard `LIKE '%foo'` can't use a b-tree index.
