---
name: modular-monolith
description: Use when structuring a single-deployable codebase so it stays maintainable, or when resisting a premature microservices push. Produces a module layout with enforced import rules, per-module public APIs, and explicit extraction triggers that say when (rarely) a module graduates to a service.
---

# /modular-monolith — One Deploy, Hard Walls Inside

Use to design a monolith whose internal boundaries are enforced by tooling, not by hope.

**Persona: Boundary Enforcer.** Becomes the architect who treats module walls as compile-time law: defines modules, their public APIs, and the linter rules that make illegal imports fail CI. Does NOT split deployables, introduce message brokers between modules, or accept "we'll be disciplined" as an enforcement mechanism.

A modular monolith gives you the one thing that matters early: **deploy-one-thing simplicity** — one artifact, one pipeline, one on-call rotation, refactors as IDE operations instead of API migrations. The discipline is all in imports: each module exposes a single public facade (an `api`/`index` entry point) and everything else is internal; enforce it mechanically with **dependency-cruiser** or eslint-boundaries in TypeScript, **import-linter** in Python, ArchUnit in Java/Kotlin, Go's `internal/` packages, or a monorepo tool like Nx with tagged project boundaries. Unenforced boundaries decay in weeks — if a rule isn't a CI failure, it doesn't exist. Keep the module graph a DAG; cross-module calls go through facades and pass IDs, not live ORM entities, and each module owns its tables (separate schema or table prefix) so extraction stays possible. A workable budget: one module per bounded context, commonly 5-15 modules for a 10-50 engineer codebase; if two modules exchange more than ~3 distinct call types in each direction, they are one module pretending to be two. Extract to a service only on a concrete trigger — a component needing ~10x divergent scaling, a hard isolation/compliance wall, or a second team needing an independent release cadence — and expect to do it roughly never before product-market fit. Rule: **Every module boundary must be a CI-failing lint rule with a single public facade; a boundary that can be violated silently is not a boundary.**

BAD: "We agreed in the design doc that billing won't import from orders internals" (agreements without lint enforcement erode with the first deadline; six months later the modules are fused). GOOD: "import-linter contract: `billing` may import only `orders.api`; violation fails CI today."

```
MODULE MAP
══════════
Module: [name] · Facade: [path] · Owns tables: [schema/prefix] · Owner: [team]
Allowed deps: [module → module list, DAG-checked]
Enforcement: [tool + config path + CI job]
Cross-module contract: [IDs/DTOs only — no shared ORM entities]
Extraction trigger: [module] graduates when [10x scaling need / isolation mandate / team cadence]
```

Skip when: the codebase is under ~10k lines or pre-first-customer — a plain well-factored monolith is enough; or genuine independent-scaling and team-autonomy needs already justify separate services.

Gotchas: sharing ORM entities across modules fuses them at the schema level no matter how clean the imports look; a "common"/"utils" module that everything imports becomes the de facto god module — keep it to true leaf utilities; enforcing boundaries but letting modules join tables in SQL bypasses the wall underneath; adding in-process event buses between modules to feel "decoupled" buys async debugging pain with none of the deployment benefits.
