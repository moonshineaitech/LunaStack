---
name: graphql-api-design
description: Use when designing, reviewing, or evolving a GraphQL schema and its resolvers. Produces a schema that batches N+1 with per-request DataLoaders, bounds cost via depth/complexity limits and cursor pagination, and evolves without versioning through additive changes plus @deprecated.
---

# /graphql-api-design — GraphQL Schemas Without N+1, Over-fetching, or Versioning Pain

Use when designing, reviewing, or evolving a GraphQL schema and its resolvers.

**Persona: Graph API architect who owns the schema as a public contract.** You optimize for the client's query shape and the schema's decade-long evolvability over any single resolver's convenience; a schema is a promise you can add to but never break.

Rule 1 — kill N+1 at the resolver boundary: any field that resolves by fetching another entity (DB row, RPC, cache) MUST go through a per-request DataLoader. DataLoader coalesces every `.load(key)` fired within one event-loop tick into one batch call and dedupes keys — your batch function turns that key array into a single `WHERE id IN (...)`. Per-request instances only, never module-global: a global loader's cache leaks one user's rows into another's response. If a resolver can run N times in one query, it batches or it ships a bug.

Rule 2 — bound every query before execution, in a validation rule not in resolvers: reject on depth > 10 (graphql-depth-limit) and on static complexity cost over budget (graphql-query-complexity). Anchor the number to a real system — GitHub caps at 500k nodes/query, Shopify at a 1000-point bucket refilling 50/s. Never expose a field returning a raw unbounded list; use a Relay cursor Connection, default `first` to 20 and reject `first`/`last` > 100. In production, allowlist persisted queries.

Rule 3 — evolve, don't version: no `/v2` endpoints, ever. Change the live schema additively. Make new output fields nullable so one backend failure degrades that field instead of nulling its parent — a non-null field that errors propagates null up to the nearest nullable ancestor, cascading across the response. Never remove or retype a field in use; mark it `@deprecated(reason: "use X instead")` and delete only after field usage reads 0 for 30+ days in Apollo Studio (or a tracing plugin).

BAD: `Post.author` resolves `db.user.findById(post.authorId)` — 50 posts fire 50 queries.
GOOD: `Post.author: (p, _, { loaders }) => loaders.user.load(p.authorId)` — 50 `.load` calls collapse to one `IN (...)` query, deduped.

If usage or timings are not measured, write "not measured" — never estimate.

```
═══ GRAPHQL SCHEMA REVIEW ═══
Schema: [file / service]
N+1 risks: [count] — [entity-fetching fields lacking a DataLoader]
Unbounded lists: [count] — [fields returning raw arrays, not Connections]
Cost controls: depth-limit=[n] complexity-cap=[n] persisted-queries=[on/off]
Non-null hazards: [fields marked ! backed by fallible I/O]
Breaking vs prod schema: [count] — [removed / retyped fields, new required args]
Deprecations: [field → usage over 30d: [n]% | not measured]
Verdict: [SHIP | FIX-FIRST] — [blocking items]
```

Skip when: designing REST/gRPC, or a one-off internal query with no resolver fan-out and no external clients.

Gotchas: DataLoader caches for the request's lifetime — after a mutation, `.clear(key)` or later reads in that request return the pre-mutation value. `@deprecated` is valid on fields, enum values, and (only on 2021+ spec servers) arguments and input fields, but never on object/interface types — you cannot deprecate a whole type at once. Adding a required argument or making an input field non-null is a BREAKING change even though it feels additive: existing queries omitting it now fail validation.
