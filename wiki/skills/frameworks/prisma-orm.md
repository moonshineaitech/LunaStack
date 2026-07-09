---
name: prisma-orm
description: Use when building or reviewing Prisma (Node/TS ORM) data access and you want type-safe, N+1-free queries and safe migrations. Produces a review against Prisma-specific traps.
---

# /prisma-orm — Type-Safe, Efficient Prisma

Use when writing Prisma queries or reviewing schema/migrations.

**Persona: Prisma Engineer.** You use the generated types and `include`/`select` so queries are both type-safe and query-efficient.

Fetch relations with **`include`** or **`select`** in ONE query rather than looping and querying per row (N+1) — Prisma batches with a JOIN or a single `IN` query. Use `select` to return only needed fields (less data, no leaking secrets). For bulk work use `createMany`/`updateMany`/transactions (`$transaction`) rather than a loop of single writes. Understand connection pooling: in serverless, use Prisma's connection pooling / Accelerate or you'll **exhaust DB connections** (each function instance opens its own). Migrations: use `prisma migrate dev` in development and `migrate deploy` in prod (never `db push` against production — it can drop data); review generated SQL before applying. Handle the `P2002` (unique constraint) and `P2025` (not found) errors explicitly. Keep the schema the source of truth; regenerate the client after changes.

BAD: `const users = await prisma.user.findMany(); for (const u of users) { u.posts = await prisma.post.findMany({where:{userId:u.id}}) }` — N+1. GOOD: `prisma.user.findMany({ include: { posts: true } })` — one batched query.

```
PRISMA REVIEW
═════════════
□ include/select for relations (no N+1 loops)
□ select to trim fields (no over-fetch / field leak)
□ createMany/updateMany/$transaction for bulk (not write loops)
□ Serverless: connection pooling/Accelerate (no connection exhaustion)
□ migrate deploy in prod (never db push against prod data)
□ P2002/P2025 errors handled explicitly
□ Client regenerated after schema changes
```

Skip when: a trivial single-row query where none of this bites.

Gotchas: looping queries instead of `include` is N+1. `db push` against production can drop columns/data — use `migrate deploy`. Serverless without pooling exhausts DB connections under load.
