---
name: api-mocking-strategy
description: Use when tests stub HTTP clients ad hoc, mocks have drifted from real API behavior, or a team debates mocking vs hitting real services. Establishes network-boundary mocking (MSW, WireMock, Prism class) with mocks generated or verified from the API contract, drift-prevention checks in CI, and explicit rules for when to hit real dependencies. Produces a layered mocking policy and contract-synced mock definitions.
---

# /api-mocking-strategy — Mock the Network, Sync to the Contract

Use to design an API mocking layer that intercepts at the network boundary and provably stays in sync with the real service.

**Persona: Test Infrastructure Architect.** Draws the line where fakes live, wires mocks to the contract that generates them, and schedules the runs that catch drift. Does NOT mock the app's own modules to dodge integration bugs, and does not let hand-written response JSON become a second, unversioned API spec.

Mock at the **network boundary**, never the client module: intercept with **MSW** (Service Worker in browser, `msw/node` interceptors in Node — one handler set serves unit tests, Storybook, and local dev) or **WireMock**/**Prism**/**Mockoon** as an out-of-process stub for polyglot or mobile stacks. Stubbing `fetch`, axios, or your `apiClient` wrapper skips serialization, headers, error shapes, and interceptor logic — exactly where integration bugs live. The killer failure mode is **drift**: mocks encode last quarter's API. Prevent it structurally, not by vigilance — generate handlers and fixtures from the **OpenAPI spec** (msw's OpenAPI integration, openapi-msw, Prism's spec-driven mode) or validate every mock request/response against the schema at test time so a spec change fails the suite; for service-to-service seams, add **consumer-driven contracts** (Pact) verified by the provider's CI. Type mock payloads from generated client types so a field rename is a compile error. Layer by scope: unit/component tests run fully mocked; a thin integration suite of roughly 5-15 smoke flows hits a real (staging/ephemeral) instance on merge or nightly to catch what contracts can't — auth handshakes, pagination quirks, rate-limit headers, latency. Simulate failure honestly: mock 429s with `Retry-After`, 5xx, timeouts, and malformed bodies, because "mocks only return 200" is why retry logic ships untested. Rule: **Every mock must be generated from or validated against the API contract in CI — a mock nobody can mechanically prove current is a lie waiting to pass.**

BAD: "jest.mock('../apiClient') with inline JSON copied from a curl response last year" (bypasses the real HTTP path and drifts silently — tests pass while production 400s). GOOD: "MSW handlers typed and schema-validated from the OpenAPI spec, plus a nightly 10-flow smoke suite against staging that alerts on contract drift."

```
API MOCKING POLICY
══════════════════════════════════════════
BOUNDARY: [MSW/WireMock/Prism] · SCOPE: [unit+component mocked · integration real]
CONTRACT SYNC: [spec source] → [generated handlers/schema validation/Pact] · CI check: [job name]
FAILURE MODES MOCKED: [429+Retry-After · 5xx · timeout · malformed body]
REAL-SERVICE SUITE: [n flows] · [trigger: merge/nightly] · [env: staging/ephemeral]
DRIFT ALARM: [what fails when the API changes]
```

Skip when: you own both sides in a monorepo with cheap ephemeral environments — spinning up the real service per test run beats maintaining mocks; or the dependency is a stable local library, not a network service.

Gotchas: MSW's `onUnhandledRequest` left at 'warn' lets tests silently hit real endpoints — set it to 'error'; sharing one giant global handler file breeds mystery coupling, so keep default happy-path handlers global and override per test with `server.use()`; recording real traffic (VCR-style cassettes) without a re-record schedule is drift with extra steps; and mocking third-party APIs you don't control still needs a scheduled live contract check, because their spec changes without your PR.
