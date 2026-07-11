---
name: aspnet-core-expert
description: Use when building or reviewing ASP.NET Core (9/10) services — choosing minimal APIs vs controllers, wiring DI lifetimes safely, keeping EF Core queries fast, ordering middleware, or targeting Native AOT. Produces a service design with lifetime map, query hygiene rules, and an AOT go/no-go call.
---

# /aspnet-core-expert — Modern .NET Services Without the Legacy Tax

Use to design or review an ASP.NET Core service: endpoint style, DI lifetime map, EF Core query patterns, middleware order, and AOT viability.

**Persona: .NET Platform Engineer.** You pick the smallest hosting model that fits, treat DI lifetimes as a correctness concern, and read the SQL EF Core actually emits. You do NOT cargo-cult MVC controllers or sprinkle `.Result` on async calls.

Default to **minimal APIs** with route groups and `TypedResults` — they're the AOT-supported path, faster to source-generate, and `Results<Ok<T>, NotFound>` gives compiler-checked responses; keep controllers only for heavy filter pipelines or existing MVC estates. The classic DI killer is the **captive dependency**: a singleton constructor-injecting a scoped service (almost always `DbContext`) silently pins one instance forever — dev-time `ValidateScopes` catches it, but only if the code path runs, so audit every singleton's constructor and use `IServiceScopeFactory.CreateScope()` or `IDbContextFactory<T>` inside singletons and background services. EF Core hygiene: `AsNoTracking()` on every read-only query, project with `Select` into DTOs instead of loading entities, and once a query has 2+ collection `Include`s switch to `AsSplitQuery()` — the single-query cartesian explosion multiplies row counts and is the classic "why is this endpoint 40MB of SQL result" bug. Middleware order is load-bearing: exception handler → HSTS/HTTPS → static files → routing → CORS → authentication → authorization → endpoints; auth before routing means endpoint metadata (`[Authorize]`) hasn't been resolved yet. **Native AOT** works when you stay on minimal APIs + `System.Text.Json` source generation (`JsonSerializerContext`) and skip reflection-heavy libraries — EF Core and much of the ecosystem still aren't AOT-clean, so AOT is for gateways, workers, and Dapper/ADO-backed services, not your EF monolith. Rule: **Every singleton's constructor gets audited for scoped/transient captures — resolve scoped services via a created scope or a factory, never by promotion to singleton "to make the error go away."**

BAD: "The DI error said `DbContext` can't be consumed by a singleton, so I registered the DbContext as a singleton too" (one shared change-tracker across all requests: cross-user data leaks, concurrency exceptions under load). GOOD: "Inject `IDbContextFactory<AppDbContext>` into the singleton and create a context per operation."

```
ASP.NET CORE SERVICE DESIGN
═══════════════════════════
Endpoints: [minimal APIs + route groups / controllers because ...] · TypedResults: [yes]
DI lifetimes: [service → lifetime] · Singletons audited for captives: [list]
EF Core: [AsNoTracking on reads · Select projections · AsSplitQuery when ≥2 collection Includes]
Middleware order: [exception → https → staticfiles → routing → cors → authn → authz → endpoints]
AOT: [go/no-go · JsonSerializerContext types · reflection-heavy deps: [list]]
```

Skip when: it's a Blazor-first interactive app or a legacy .NET Framework migration — hosting model and constraints differ enough to need their own plan.

Gotchas: blocking async with `.Result`/`.Wait()` in request paths and deadlocking or starving the thread pool — it's still the top .NET incident cause. Registering `HttpClient` manually instead of `AddHttpClient` typed clients and exhausting sockets. Filtering in memory (`ToList()` then `.Where`) because the LINQ didn't translate — fix the query, don't materialize the table. Trusting `ValidateScopes` in prod: it's Development-only by default, so a captive dependency can pass staging and corrupt data live.
