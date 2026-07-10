---
name: api-first-design
description: Use when building any API that another team, service, or external customer will consume. Produces a reviewed OpenAPI/AsyncAPI contract before implementation starts, a mock server so consumers build in parallel, and a breaking-change policy with CI-enforced diff checks.
---

# /api-first-design — The Contract Ships Before the Code

Use to design, review, and freeze an API contract before anyone writes a handler.

**Persona: Contract Negotiator.** Becomes the designer who treats the spec as the product: drafts it from consumer use-cases, walks real consumers through it, and gates implementation on their sign-off. Does NOT generate specs from finished code, rubber-stamp breaking changes, or let "internal-only" excuse contract sloppiness.

API-first means the **OpenAPI 3.1** document (or **AsyncAPI 3** for event-driven interfaces) is authored, reviewed, and merged before implementation — because changing a field name costs minutes in a spec review and quarters once three consumers depend on it. Design from the consumer's call sequence, not your table schema: write the 3-5 primary use-cases as example requests/responses first, then generalize. The parallelism payoff is mechanical: stand up a **mock server** from the spec (Prism, Microcks, or WireMock's OpenAPI mode) within a day of contract merge, so frontend and consuming teams build against mocks while the backend implements — commonly a 30-50% cycle-time win on cross-team features, and the mock doubles as the fixture for **contract tests** (Schemathesis fuzzing the implementation against the spec; Pact when consumers want to pin their exact expectations). Governance is where API-first lives or dies: lint every spec PR with **Spectral** or **vacuum** against a house ruleset, and run **oasdiff** (or Optic) in CI to classify each change — additive changes (new optional fields, new endpoints) flow freely; breaking changes (removed/renamed fields, type changes, tightened validation) require a new version plus a deprecation window, commonly ~6 months or 2 major consumer release cycles for external APIs, with `Deprecation`/`Sunset` headers on the old surface. Rule: **No implementation PR merges before the contract PR is approved by at least one real consumer — and no breaking change ships without a CI-detected diff, a version bump, and a dated sunset.**

BAD: "Build the endpoints, then auto-generate the OpenAPI from code annotations and publish it" (the spec becomes a mirror of implementation accidents; consumers inherit your table schema and every rename is a breaking change discovered in production). GOOD: "Contract PR with example-first design, consumer approval, Prism mock live on day one, Schemathesis + oasdiff gating the implementation."

```
API CONTRACT PLAN
═════════════════
Spec: [OpenAPI 3.1 / AsyncAPI 3] · Path: [specs/name.yaml] · Consumers signed off: [teams]
Use-cases designed first: [1-liner each, with example req/resp]
Mock: [Prism/Microcks endpoint] · Contract tests: [Schemathesis/Pact job]
Lint: [Spectral ruleset] · Diff gate: [oasdiff — breaking = block]
Versioning: [scheme] · Deprecation window: [~6 mo] · Sunset headers: [y/n]
```

Skip when: the API is private to a single codebase and team (a module facade, not a contract — see /modular-monolith), or you're prototyping solo and will throw the interface away within weeks.

Gotchas: generating the spec from code inverts the dependency and silently exposes implementation details as contract; designing resources as a 1:1 mirror of database tables leaks your schema and makes every migration a consumer negotiation; mocks that only return the happy path let consumers ship untested error handling — spec your 4xx/5xx bodies and mock them too; "it's internal, we can break it" is how internal APIs accumulate the exact coordination cost microservices were supposed to remove.
