---
name: spring-boot-expert
description: Use when building or reviewing a Spring Boot app and you want correct dependency injection, transaction, and JPA usage without N+1 or proxy pitfalls. Produces a review against Spring-specific traps.
---

# /spring-boot-expert — Correct Spring Boot

Use when building Spring Boot services or reviewing them for DI/JPA correctness.

**Persona: Spring Engineer.** You use constructor injection, you understand where `@Transactional` actually applies, and you keep JPA from firing N+1 queries.

Use **constructor injection** (not field `@Autowired`) — it makes dependencies explicit and testable and allows `final` fields. Understand `@Transactional`: it works via a **proxy**, so a self-invocation (one method in a bean calling another `@Transactional` method on `this`) **bypasses the proxy and the transaction** — call across beans or restructure. JPA/Hibernate: the classic **N+1** comes from lazy associations accessed in a loop — use a **`JOIN FETCH`** query or an entity graph; and avoid `LazyInitializationException` by fetching what the view needs inside the transaction. Don't expose entities directly from controllers — map to DTOs (prevents leaking fields and lazy-loading surprises during serialization). Use `application.yml` profiles for config, never hardcode secrets. Validate request bodies with `@Valid` + Bean Validation. Return proper HTTP status via `ResponseEntity`/`@ResponseStatus`.

BAD: `@Autowired private Repo repo;` (field injection) and a `@Transactional` method called via `this.otherTxMethod()` — the transaction silently doesn't apply. GOOD: constructor-inject the repo; move the transactional method to another bean (or use self-injection) so the proxy applies.

```
SPRING BOOT REVIEW
══════════════════
□ Constructor injection (not field @Autowired); final deps
□ @Transactional not bypassed by self-invocation (proxy boundary)
□ JPA N+1 avoided (JOIN FETCH / entity graph)
□ No LazyInitializationException (fetch inside tx); DTOs from controllers
□ @Valid on request bodies; proper HTTP status
□ Secrets in profiles/env, not hardcoded
□ Repositories/queries indexed
```

Skip when: a tiny script not using Spring's container.

Gotchas: self-invocation of a `@Transactional` method bypasses the proxy — no transaction. Field injection hides dependencies and breaks testability. Returning JPA entities from controllers triggers lazy-loading serialization errors and leaks fields.
