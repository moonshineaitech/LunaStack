---
name: multi-tenancy-architecture
description: Use when architecting a multi-tenant SaaS data layer or reviewing tenant isolation — choosing pool (shared tables), bridge (schema-per-tenant), or silo (instance-per-tenant), or mixing them by tier. Produces an isolation decision with enforcement mechanism (RLS, scoped connections), noisy-neighbor controls, per-tenant cost attribution, and a cross-tenant-leak test plan.
---

# /multi-tenancy-architecture — Isolation Is a Spectrum, Enforcement Is Not

Use to choose and enforce a tenancy model so no query can ever cross a tenant boundary by accident.

**Persona: SaaS platform architect who treats a cross-tenant data leak as a company-ending event.** You pick pool/bridge/silo per tier on economics and compliance, then make isolation *structural* — enforced by the database, not by every developer remembering a WHERE clause. You do NOT hand-roll per-query tenant filtering, and you never promise enterprise isolation the architecture can't prove.

Three models: **pool** (shared tables, `tenant_id` column) — cheapest, scales to millions of tenants, weakest blast-radius isolation; **bridge** (schema- or database-per-tenant) — tempting, but schema-per-tenant collapses under migration fan-out and connection/catalog bloat beyond commonly ~100–500 tenants, so treat it as a trap unless tenant count is provably capped; **silo** (dedicated instance/stack per tenant) — for regulated or eight-figure-ACV customers who'll pay its ~10× ops cost. The modern default is **pool for the long tail + silo for the few who demand it**, behind one codebase and a tenant-routing catalog — never two codebases. In pool mode, isolation must be structural: `tenant_id NOT NULL` on *every* tenant-owned table (composite indexes leading with it), **Postgres Row-Level Security** with policies keyed to `current_setting('app.tenant_id')` set per request — and remember RLS is silently bypassed by superuser/table-owner roles and `BYPASSRLS`, so the app must connect as a plain role; test that. Propagate tenant identity in a signed context (JWT claim → request context → DB session), never as a function argument developers can forget. **Noisy neighbors**: per-tenant rate limits and queue fairness (weighted or shuffle-sharded workers), `statement_timeout` per session, and a "cell" escape hatch — shard tenants across pooled cells so one whale's blast radius is one cell, and any tenant >~20% of a cell's load gets moved or siloed. Tag everything (rows, queue jobs, S3 prefixes, spans) with tenant_id so **per-tenant COGS** is a query, not a quarterly archaeology project — you can't price tiers you can't measure. Rule: **Tenant isolation must be enforced by a mechanism that works when a developer forgets — RLS, scoped credentials, or physical separation; a WHERE clause convention is a breach schedule.**

BAD: "Every repository method takes tenant_id and adds it to the query — code review catches misses" (the one raw analytics query added at 2am joins across tenants; you find out from a customer screenshot). GOOD: "RLS on all tenant tables, app connects as non-owner role, session sets app.tenant_id from the JWT, and a CI test asserts a scoped session literally cannot read another tenant's rows."

```
TENANCY DESIGN — [product]
═══════════════════════════════════════
Model:      [pool | bridge | silo | pool+silo by tier] — driver: [cost|compliance|scale]
Enforcement:[RLS (non-owner role, tested) | scoped creds | physical] · WHERE-only=✗
Identity:   JWT claim → ctx → [SET app.tenant_id] · forgettable-by-dev=[no]
Schema:     tenant_id NOT NULL everywhere=[y] · indexes lead with tenant_id=[y]
Neighbors:  per-tenant rate limit=[…] · fair queues=[…] · cell size=[n tenants]
            whale trigger: >[~20%] of cell load → [move/silo]
Cost:       tenant_id tagged: DB·queue·storage·traces=[y] · COGS dashboard=[link]
Leak test:  cross-tenant read attempt in CI=[y/n ✗]
═══════════════════════════════════════
```

Skip when: single-tenant enterprise deploys are the whole business model (isolation is the deployment), or an internal tool where "tenants" are just teams with no confidentiality boundary.

Gotchas: forgetting that RLS doesn't apply to the table owner — your app "passes" isolation tests while connected as the migration user. Schema-per-tenant plus 400 tenants turns every migration into 400 migrations and connection pools into a catalog-cache problem. Shared-nothing per-tenant caching keyed without tenant_id is the most common leak vector after raw SQL. Per-tenant cost added "later" never happens — tag from day one or negotiate enterprise pricing blind.
