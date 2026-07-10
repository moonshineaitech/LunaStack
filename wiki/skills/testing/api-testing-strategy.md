---
name: api-testing-strategy
description: Use when defining how an API service gets tested across layers — contract, integration, and smoke — or when an API suite is slow, gappy, or only tests happy paths. Produces a layered test plan with schema validation gates, a negative-case matrix, and per-environment run policy.
---

# /api-testing-strategy — Layered API Confidence

Use to layer contract, integration, and smoke tests so each API bug is caught at the cheapest layer that can catch it.

**Persona: API Test Strategist.** Decides what runs where: which guarantees belong to contract tests, which to integration tests against real dependencies, and which to post-deploy smoke. Does NOT write consumer-driven contract tooling setup (see /contract-testing), load-test (see /load-testing), or design UI flows.

Structure the suite as three layers with distinct jobs. **Schema/contract layer** (fast, on every PR): validate every response against the **OpenAPI 3.1** spec — tools like Schemathesis or spec-driven request validation catch the silent killers (field renamed, nullable flipped, enum value added) that handler-level assertions miss because assertions only check fields the author remembered. **Integration layer** (PR or merge): exercise handlers against real infrastructure — real Postgres/Redis via Testcontainers, real auth middleware — asserting behavior: status codes, error bodies, side effects, idempotency of retried POSTs. Enforce a **negative-case floor**: commonly ~40-50% of integration cases should be non-happy-path — malformed bodies, missing/expired auth, wrong-tenant access, oversized payloads, unknown fields — because production traffic is adversarial and happy-path-only suites certify nothing. Every error response must itself be asserted against your error schema (RFC 9457 `application/problem+json`); untested error paths are where stack traces leak. **Smoke layer** (post-deploy, per environment): 5-15 read-mostly requests hitting real dependencies through the deployed artifact, finishing in under ~60s, gating the rollout — smoke answers "is it wired up," never "is it correct." Rule: **Every endpoint ships with at least one contract check, one auth-failure case, and one malformed-input case before it ships with a second happy-path test.**

BAD: "Assert `response.json()['name'] == 'Alice'` on 30 endpoints and call the API tested" (checks one field on the happy path; a nullable flip or leaked internal field sails through). GOOD: "Validate every response — 2xx and 4xx/5xx — against the OpenAPI schema in CI, then add behavioral integration cases with a 40% negative-case floor."

```
API TEST PLAN
═════════════
CONTRACT: spec=[openapi 3.1 path] · validator=[schemathesis/…] · runs=[every PR]
INTEGRATION: deps=[testcontainers: pg, redis] · cases=[n] · negative≥40%
  MATRIX: auth[missing/expired/wrong-tenant] · input[malformed/oversized/unknown-field]
SMOKE: [5-15 checks] · ≤60s · gates=[staging→prod rollout]
ERROR SHAPE: [problem+json] asserted on all 4xx/5xx
```

Skip when: the API is an internal prototype with one consumer sitting next to you, or the surface is a single webhook endpoint — a handful of integration tests suffices.

Gotchas: mocking your own database in "integration" tests silently converts them into slow unit tests that pass while queries are broken; testing against a hand-written response fixture instead of the spec means the fixture and the API drift together; skipping auth cases because "middleware handles it" misses per-route misconfiguration — the most common real-world API vuln (BOLA) is exactly a per-route tenant check that one route forgot; smoke tests that write data pollute environments and page you for their own residue.
