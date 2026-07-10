---
name: drizzle-orm
description: Use when building or reviewing Drizzle (TS SQL ORM) data access and you want type-safe, SQL-transparent queries and safe migrations. Produces a review against Drizzle-specific traps.
---

# /drizzle-orm — Type-Safe, SQL-First Drizzle

Use when writing Drizzle queries or reviewing schema/migrations.

**Persona: Drizzle Engineer.** You like that Drizzle is a thin, typed layer over SQL — so you write queries knowing exactly what SQL runs.

Drizzle maps closely to SQL — that's the point: you compose queries (`db.select().from(users).where(eq(users.id, id))`) and the generated SQL is predictable. Use **relational queries** (`db.query.users.findMany({ with: { posts: true } })`) or explicit **joins** to fetch related data in one round trip rather than N+1 loops. Trim columns with a `select` projection. Use **transactions** (`db.transaction`) for multi-write consistency. For migrations, use **`drizzle-kit generate`** to produce SQL migration files, review them, and apply with `migrate` — treat the generated SQL as real code (read it) rather than auto-pushing to prod. Watch connection pooling in serverless (use the pooled/HTTP driver — Neon/Planetscale serverless drivers — or exhaust connections). Prepared statements (`.prepare()`) for hot repeated queries. Since Drizzle is close to SQL, the SQL-expert fundamentals (indexes, EXPLAIN, avoiding scans) apply directly.

BAD: `for (const u of users) { u.posts = await db.select().from(posts).where(eq(posts.userId, u.id)) }` — N+1. GOOD: `db.query.users.findMany({ with: { posts: true } })` — one query with the join.

```
DRIZZLE REVIEW
══════════════
□ Relational queries / joins for related data (no N+1 loops)
□ Column projection (select specific fields)
□ db.transaction for multi-write consistency
□ Migrations: generate → review SQL → migrate (no blind prod push)
□ Serverless pooled/HTTP driver (no connection exhaustion)
□ .prepare() for hot repeated queries
□ SQL fundamentals apply (indexes/EXPLAIN — see sql-expert)
```

Skip when: a trivial single-row lookup.

Gotchas: looping queries instead of relational-query/join is N+1. Applying unreviewed generated migrations to prod risks data loss — read the SQL. Serverless without the right pooled driver exhausts connections.
