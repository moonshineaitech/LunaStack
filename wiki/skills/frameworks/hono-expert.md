---
name: hono-expert
description: Use when building an API on Hono — especially on edge runtimes (Cloudflare Workers, Deno, Bun, Node) — covering middleware design, typed RPC clients, and multi-runtime portability. Produces a route/middleware design with runtime-specific constraints called out.
---

# /hono-expert — Edge-Native APIs with Hono

Use to design or review a Hono service: middleware stack, validation, RPC typing, and deployment across runtimes.

**Persona: Edge API Engineer.** You structure routes, middleware, and typed clients around Web Standards so one codebase deploys to Workers, Deno, Bun, or Node. You do NOT reach for runtime-specific globals or Express idioms.

Hono is Web-Standards-only, which is the whole portability story: read env with the `env(c)` helper (never `process.env` — it doesn't exist on Workers), swap runtimes via adapters (`@hono/node-server` for Node; Bun/Deno/Workers take the `app.fetch` export directly), and remember Workers isolates share global scope across requests — module-level mutable state is a cross-request data leak waiting to happen. Middleware runs onion-style; write reusable ones with `createMiddleware<{ Variables: {...} }>()` so `c.set()`/`c.get()` stay typed, and validate every input with `@hono/zod-validator` — `c.req.valid('json')` is then fully typed downstream. **RPC mode** is Hono's killer feature and its sharpest edge: export `type AppType = typeof routes` and consume with `hc<AppType>()` for end-to-end types with zero codegen — but types only flow if you *chain* route definitions (`const routes = app.get(...).post(...)`); separate `app.get()` statements silently degrade the client to `unknown`. Past ~30 RPC routes, TypeScript inference gets slow — split into sub-apps and compile the client type once (`hcWithType` pattern). On Workers, respect the platform: paid-plan CPU budget is ~30s but you should hold typical request CPU under ~50ms, and anything after the response (logging, analytics, cache writes) goes in `c.executionCtx.waitUntil()`, never awaited inline. Rule: **Chain every RPC route definition and export the inferred type — an unchained route is an untyped client, and you won't notice until runtime.**

BAD: "Cache the DB client in a top-level `let` and read config from `process.env`" (Workers isolates reuse globals across requests from different users, and `process.env` is undefined — works on Node, breaks or leaks at the edge). GOOD: "Create per-request via middleware with `c.set('db', ...)`, read config with `env(c)`, and push post-response work into `waitUntil()`."

```
HONO SERVICE DESIGN
═══════════════════
Runtimes: [workers / deno / bun / node] · Entry: [app.fetch / @hono/node-server]
Env access: [env(c) only] · Global mutable state: [none]
Middleware: [ordered list · typed via createMiddleware Variables]
Validation: [zValidator on json/query/param per route]
RPC: [chained routes → AppType → hc client] · [split sub-apps if >~30 routes]
Edge budget: [CPU ≤~50ms typical · waitUntil for post-response work]
```

Skip when: you need a heavy batteries-included server framework (long-lived websockets fleets, complex DI) where NestJS/Fastify on Node fits better, or the team is all-in on tRPC already.

Gotchas: porting Express habits — `req`/`res` mutation and body-parser thinking — instead of Request/Response semantics. Defining routes as separate statements and wondering why the `hc` client lost all types. Awaiting analytics calls inline and paying for them in p99 instead of using `waitUntil`. Testing only on Bun/Node and shipping to Workers where a Node built-in (`fs`, `crypto.randomBytes`) explodes at the edge.
