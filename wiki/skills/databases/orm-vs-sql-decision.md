---
name: orm-vs-sql-decision
description: Use when choosing a data-access strategy for a service, or when an existing ORM codebase shows N+1 storms, unreadable generated SQL, or migration fights. Produces a layered decision: where the ORM earns its keep, which query classes go to raw SQL, N+1 detection guardrails, and honest escape-hatch conventions.
---

# /orm-vs-sql-decision — Draw the Line Per Query Class, Not Per Project

Use to decide where an ORM serves you and where raw SQL takes over — as a written boundary, not a religious war.

**Persona: Data-Access Layer Arbiter.** Splits the decision by query class instead of picking one tool for the whole codebase, and writes the boundary down so the next engineer doesn't relitigate it. Does NOT ban ORMs (CRUD boilerplate is real) or worship them (the ORM is a productivity tool, not an abstraction that survives contact with reporting queries).

The honest split: ORMs (Prisma, Drizzle, SQLAlchemy 2.x, Ecto, ActiveRecord) earn their keep on **single-aggregate CRUD** — fetch/update an entity and its owned children, schema migrations, type-safe simple filters — which is commonly ~80% of queries and ~20% of query-time. Raw SQL (via typed query builders or checked-SQL tools like sqlc, PgTyped, jOOQ, or `$queryRaw`/`text()` escape hatches) owns the rest: reports and aggregations, multi-join reads shaped unlike your entities, bulk writes (`INSERT ... ON CONFLICT`, `UPDATE ... FROM`), window functions, CTEs, and anything performance-critical enough to have an `EXPLAIN` in review. Enforce a numeric guardrail for the ORM zone: any request issuing more than ~10 queries fails CI — wire an N+1 detector (query counts per request in tests, Prisma/Django `assertNumQueries`-style assertions, or APM span-count alerts) because lazy loading makes N+1 the ORM's default behavior, not a rare bug. Be honest about the **repository pattern**: wrapping an ORM in repositories "so we can swap databases later" almost never pays — you'll never swap, but a thin data-access module per aggregate still helps by giving raw SQL a sanctioned home instead of letting `queryRaw` leak through controllers. Escape hatches need conventions: raw queries live next to the ORM code, are typed/checked at build time, and carry the `EXPLAIN`-verified plan in the PR when they're hot-path. Rule: **The ORM handles single-aggregate reads and writes; any query with 3+ joins, an aggregate, or a bulk write is written as SQL — decided per query class, in writing, once.**

BAD: "We standardized on the ORM everywhere for consistency, so the analytics endpoint composes 14 chained includes" (the generated SQL is an unreviewable 200-line join, the planner gives up, and no one can EXPLAIN it). GOOD: "CRUD stays in Drizzle; the analytics endpoint is one hand-written CTE in sqlc with its EXPLAIN pasted in the PR."

```
DATA-ACCESS BOUNDARY
════════════════════
ORM: [tool] · owns: [CRUD/migrations/simple filters]
RAW SQL: [sqlc/jOOQ/queryRaw] · owns: [reports/bulk/3+ joins/window fns]
N+1 GUARD: max queries/request [~10] · enforced by [test assertion/APM alert]
ESCAPE HATCH RULES: location [module] · typed [y] · EXPLAIN in PR [hot path]
REPOSITORY VERDICT: [thin module per aggregate / none] · reason [1 line]
```

Skip when: the service is a tiny internal tool where any access pattern works; or the team already runs a pure-SQL toolchain (sqlc/jOOQ) happily — don't introduce an ORM for ideology either.

Gotchas: "we'll optimize the ORM queries later" ships N+1 to production because dev datasets are too small to feel it; ORM-generated migrations applied blind can rewrite or lock large tables — read the SQL before running it; fighting the ORM to express a window function costs more than writing the SQL and keeps nobody's SQL skills alive; and the database-swap argument for repositories is a fantasy that costs real indirection today for a migration that never comes.
