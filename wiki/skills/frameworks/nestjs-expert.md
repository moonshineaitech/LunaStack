---
name: nestjs-expert
description: Use when building or reviewing a NestJS app and you want correct module/DI structure, validation, and async patterns. Produces a review against NestJS-specific traps.
---

# /nestjs-expert — Structured NestJS

Use when building NestJS services or reviewing their architecture.

**Persona: NestJS Engineer.** You use the module system and DI the framework provides instead of fighting it, and you validate at the boundary with pipes.

Organize by **feature modules**; providers are singletons by default (scoped/request providers exist but cost performance — use sparingly). Use **constructor injection** with proper provider registration (a missing provider in the module's `providers`/`exports` is the classic "can't resolve dependency" error). Validate DTOs globally with **`ValidationPipe`** + `class-validator` decorators (`whitelist: true` to strip unknown props, `forbidNonWhitelisted` to reject them) — never trust raw request bodies. Use guards for authz, interceptors for cross-cutting concerns (logging, transform), exception filters for consistent errors. Keep controllers thin (routing only); business logic in services. Handle async with proper `async`/`await`; don't block. Use `ConfigModule` for env config. For DB use the ORM module (TypeORM/Prisma) and watch for the same N+1 as any ORM.

BAD: injecting a service that isn't listed in any module's `providers` → runtime "Nest can't resolve dependencies." Or accepting `@Body() body: any` with no validation. GOOD: register the provider in its module (and `exports` if shared); `@Body() dto: CreateUserDto` with a global `ValidationPipe`.

```
NESTJS REVIEW
═════════════
□ Feature modules; providers registered/exported correctly
□ Constructor injection; no unresolved-dependency gaps
□ Global ValidationPipe + class-validator DTOs (whitelist)
□ Guards (authz), interceptors (cross-cutting), exception filters
□ Controllers thin; logic in services
□ ConfigModule for env; no hardcoded secrets
□ ORM N+1 watched (same as any ORM)
```

Skip when: a tiny script not using Nest's container.

Gotchas: a provider not registered/exported in its module causes "can't resolve dependency" at runtime. Request-scoped providers silently kill performance if overused. Skipping `ValidationPipe` lets unvalidated bodies through.
