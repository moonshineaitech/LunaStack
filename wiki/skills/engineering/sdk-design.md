---
name: sdk-design
description: Use when building or overhauling a client library/SDK for an API, across one or more languages. Covers surface-area minimalism, errors as first-class API, built-in pagination and retries, cross-language versioning, and generating docs from types. Produces an SDK design spec with surface inventory, error taxonomy, and deprecation policy.
---

# /sdk-design — Small Surface, Batteries Included

Use to design client libraries where the happy path is one line, the failure path is typed, and pagination/retry/auth are the SDK's job — not the caller's.

**Persona: Developer Experience Architect.** You own the SDK's public surface, error contract, and versioning policy across languages. You do NOT design the underlying API's resources or business logic — you make the existing API feel native, safe, and hard to misuse in each target language.

Every public symbol is a liability you support forever, so budget the surface: a v1 SDK should commonly expose **≤50 public types/functions** — if you're over, you're leaking transport internals (raw request builders, HTTP enums) that belong behind one escape hatch (`client.request()` for unsupported endpoints, which also decouples SDK releases from API releases). **Errors are API**: define a typed hierarchy (`AuthError`, `RateLimitError` carrying `retryAfter`, `InvalidRequestError` carrying the offending field) rather than strings or bare status codes — callers write `catch RateLimitError`, and that contract is as breaking-change-sensitive as method signatures. Build in what every caller reimplements badly: **auto-pagination** (return a lazy iterator, never make users touch cursors), **retries with jittered exponential backoff** (default ~2 retries, honor `Retry-After`, retry only idempotent or idempotency-keyed calls), timeouts, and keepalive. For multi-language fleets, generate from a single source of truth — **OpenAPI/protobuf through Stainless, Fern, or Speakeasy-class generators** with hand-written ergonomic wrappers on top; hand-porting five SDKs guarantees drift. Version each language SDK independently with SemVer, but pin all to a dated **API version header** so server changes don't break old SDKs; deprecate with runtime warnings ≥1 minor version and commonly ~6-12 months before removal. Docs come from types: rich docstrings on generated models plus one runnable quickstart per language — if the types are good, IDE autocomplete is your primary documentation channel. Rule: **If a caller must write a loop, a sleep, or a string-match on an error message to use your SDK correctly, that logic belongs inside the SDK.**

BAD: "Expose the full HTTP layer so users have maximum flexibility" (now every internal refactor is a breaking change, and every user hand-rolls broken retry loops). GOOD: "Ship `client.invoices.list()` returning an auto-paginating iterator with typed errors and backoff built in, plus a single documented `client.request()` escape hatch."

```
SDK DESIGN SPEC
═══════════════
Languages: [list] · generator: [Stainless|Fern|Speakeasy|hand] · source of truth: [OpenAPI|proto]
Surface: [N public symbols, budget ≤50 v1] · escape hatch: [raw request method]
Errors: [taxonomy tree] · retryable: [classes] · fields carried: [retryAfter, param, requestId]
Built-in: pagination [iterator] · retries [N, backoff, idempotency rule] · timeout [default]
Versioning: SemVer per-lang · API pin: [date header] · deprecation window: [~6-12 mo]
Docs: types→reference · quickstart per language · [runnable examples CI-tested Y/N]
```

Skip when: an internal API with 1-2 consumers in one language — a thin typed client in the consumer's repo beats a maintained SDK. If the API changes weekly pre-v1, ship the OpenAPI spec and let early users generate their own.

Gotchas: idiomatic beats consistent — Python users expect snake_case and context managers, Go users expect `ctx` first and returned errors; a uniform cross-language surface feels foreign everywhere. Retrying non-idempotent POSTs without idempotency keys silently duplicates writes. Bundling heavyweight transitive dependencies (a whole HTTP framework, a crypto lib) causes version conflicts in the host app — keep the dependency tree near zero. Docstring drift: if docs aren't generated from the same spec as the code, they lie within two releases.
