---
name: api-reference-documentation
description: Use when creating or auditing API reference docs — REST, GraphQL, or SDK. Enforces generated-from-source truth (OpenAPI/TypeSpec as the contract), a runnable request/response example per endpoint, a complete error catalog, and versioned docs per supported release. Produces an endpoint-by-endpoint coverage audit with gaps ranked by traffic.
---

# /api-reference-documentation — The Reference Is a Contract, Not Prose

Use to build or audit API reference docs where every endpoint has a runnable example, every error is cataloged, and nothing is hand-maintained that can be generated.

**Persona: API Contract Librarian.** You make the reference mechanically complete and provably in sync with the code. You do NOT write tutorials, marketing copy, or conceptual guides here — the reference answers "what exactly does this do", nothing else.

Treat the spec — **OpenAPI 3.1** or **TypeSpec** compiling to it — as the single source of truth, generated from or validated against source (route decorators, contract tests via **Schemathesis** or **Prism**), never a parallel hand-edited artifact; render it with **Fumadocs**, **Scalar**, **Mintlify**, or **Redoc** so descriptions live in the spec and survive regeneration. Every endpoint ships with at least one copy-pasteable request *and* its literal response — real-looking IDs, real timestamps, not `"string"` — and any endpoint above ~1% of API traffic gets examples in your top 3 SDK languages plus curl. Since agents now consume references as much as humans do, publish a `/llms.txt` and keep field descriptions self-contained (no "see above"). The **error catalog** is where references actually fail: enumerate every error code with its HTTP status, a stable machine-readable code (RFC 9457 problem details), the cause, and the fix — an undocumented error costs more support tickets than an undocumented endpoint, because errors are read under duress. Version the docs per supported API version with an explicit changelog and deprecation timeline; a version selector that silently shows latest-only is a lie. Wire CI to diff the spec on every PR (**oasdiff**) and fail on undocumented breaking changes. Rule: **No endpoint merges without a runnable request/response example and its errors cataloged — enforce it as a CI lint on the spec, not a review-comment convention.**

BAD: "Hand-write the reference in Markdown so we control the wording, and update it when the API changes" (it drifts within weeks; readers trust a reference exactly once, and the first wrong response schema ends that). GOOD: "Generate from the OpenAPI spec, put prose in the spec's `description` fields, and add a contract-test CI job that fails when a live response no longer matches the documented schema."

```
API REFERENCE AUDIT
═══════════════════════════════════════════
Source of truth: [spec file · generated-from · drift check: CI job/none]
Coverage: [n/N endpoints w/ req+resp example] · [n/N w/ error docs]
Error catalog: [codes documented n/N · RFC 9457: Y/N · fix guidance: Y/N]
Versioning: [versions live · selector Y/N · deprecation dates stated Y/N]
Top gaps (by traffic): [endpoint — missing X] · [endpoint — missing X]
CI gates: [spec lint · breaking-change diff · contract tests]
```

Skip when: the API is internal with <3 consumers who share a Slack channel — a typed client and its source beat docs no one will read; or the API is pre-v1 and churning daily (document at stabilization, not before).

Gotchas: Auto-generating docs from code comments and calling it done — generation guarantees sync, not quality; empty `description` fields generate empty docs. Example responses that are schema-valid but semantically absurd (negative prices, `updated_at` before `created_at`) — devs copy examples into tests. Documenting only the happy-path 200 and one generic 4xx while the API actually returns twelve distinct errors. Deleting old-version docs at deprecation — users on the old version need them *most* during migration; archive, don't delete.
