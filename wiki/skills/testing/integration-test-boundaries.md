---
name: integration-test-boundaries
description: Use when deciding what to mock versus run real in integration tests, or when a suite full of mocks keeps passing while production breaks. Produces a boundary map — real via Testcontainers, faked at the edge, or contract-pinned — with a mock-drift prevention plan.
---

# /integration-test-boundaries — Mock at the Edge, Run the Rest Real

Use to draw the real-vs-mock line so integration tests exercise the code that actually breaks.

**Persona: Integration Boundary Cartographer.** Maps every external dependency to a verdict: run real, fake at the network edge, or stub behind a contract-verified interface. Does NOT write consumer-driven contracts (see /contract-testing) or design unit-level test doubles (see /unit-test-design).

The modern default inverts 2015-era habits: **infrastructure you own runs real**. Postgres, Redis, Kafka, MinIO/S3-compatible stores spin up in **Testcontainers** in a few seconds; mocking your own database mocks away the very things integration tests exist to catch — SQL errors, constraint violations, transaction and isolation semantics, serialization bugs. Reserve doubles for **third-party services you can't containerize** (Stripe, external SaaS APIs), and even then fake at the **network edge** — WireMock, MSW, or the vendor's sandbox — never by stubbing your own client wrapper, because in-process stubs skip your serialization, retry, and timeout code, which is where the bugs live. Budget check: if your containerized integration suite exceeds ~10 minutes in CI, shard it or share container instances across the suite (one Postgres, per-test schemas) before you reach for mocks — reuse, don't retreat. The killer failure mode is **mock drift**: the fake still returns yesterday's response shape while the real API moved, so tests pass and production 500s. Every mock therefore needs an expiry mechanism: pin it to a recorded real interaction (VCR-style cassettes with a re-record cadence, commonly ≤90 days), verify it against the provider's published OpenAPI spec in CI, or cover the pairing with a contract test — an unverified hand-written mock is a cached assumption, and caches go stale. Rule: **Mock only what you cannot run in a container, and every mock must be verified against the real interface on a schedule — an unverifiable mock is a future production incident.**

BAD: "Mock the repository layer so integration tests run fast without Docker" (the suite now certifies that your code calls itself; every real query, index, and constraint is untested). GOOD: "Testcontainers Postgres shared across the suite with per-test schemas; Stripe faked at the HTTP edge with WireMock stubs re-recorded from the Stripe sandbox quarterly."

```
BOUNDARY MAP
════════════
RUN REAL: [postgres, redis, kafka…] via Testcontainers · shared instance, per-test schema
EDGE-FAKED: [stripe, sendgrid…] via [WireMock/MSW] · at HTTP layer, not client wrapper
DRIFT GUARD: [cassette re-record ≤90d | spec-verify in CI | contract test]
NEVER MOCKED: own DB · own message bus · serialization/retry/timeout paths
RUNTIME BUDGET: ≤10 min CI · shard before mocking
```

Skip when: testing pure domain logic with no I/O (that's unit territory), or the dependency has a high-fidelity official emulator (Firebase/DynamoDB Local) that beats a container.

Gotchas: stubbing your own HTTP client instead of the wire skips the exact code — timeouts, retries, JSON (de)serialization — that fails in production; hand-writing a mock's error responses from the docs, since docs lie and real APIs return undocumented shapes under failure; per-test containers instead of per-suite reuse turns a 2-minute suite into a 40-minute one and gets Testcontainers unfairly blamed; asserting mock-call counts ("was called twice") instead of outcomes welds tests to implementation and makes refactors bleed.
