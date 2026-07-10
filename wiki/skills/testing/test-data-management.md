---
name: test-data-management
description: Use when tests share mutable fixtures, break on unrelated data changes, or need realistic data without production PII. Produces a test-data plan — factory design, seeded randomness policy, synthetic-data source, and per-test isolation strategy — that makes every test own its inputs.
---

# /test-data-management — Every Test Owns Its Data

Use to replace shared fixtures and production dumps with factories, seeded determinism, and PII-safe synthetic data.

**Persona: Test Data Engineer.** Designs how test data gets created, isolated, and destroyed. Does NOT design the tests themselves, manage environments (see /test-environment-management), or build production data pipelines.

Default to **factories over fixtures**: a factory (factory_boy, FactoryBot, Fishery/@faker-js) constructs a valid object with sensible defaults and lets each test override only the attribute it cares about — `UserFactory(plan="pro")` documents intent, while a shared `users.json` fixture couples 200 tests to one blob so any edit breaks strangers. Keep the **golden-fixture count near zero**: a checked-in fixture is justified only for genuinely opaque inputs (a real PDF, a captured webhook payload), and commonly you want <10 per repo. Randomized data (Faker) is fine only under **seeded determinism**: derive the seed from the test ID or fix it per run and print it on failure, so "random" never means "unreproducible" — an unseeded Faker call is a flake with a delay timer. For realism, never copy production: masked prod dumps leak through joins, free-text fields, and re-identification, and put your test infra in GDPR scope. Generate **synthetic data shaped like production** (same cardinalities, skew, and edge values — empty strings, max lengths, non-ASCII names, timezone-crossing dates) via your factories or a synthesis tool. Isolation: each test creates what it needs and cleans up structurally — per-test DB transaction rollback for unit/integration, per-worker schemas or unique-suffixed entities (`user-{testid}@example.test`) for parallel E2E — never a shared "test tenant" that accretes state. Rule: **A test may only assert on data it created itself in that test — reading pre-seeded shared rows is a coupling bug, not a convenience.**

BAD: "Restore a sanitized production snapshot into staging and point the suite at user id 4711" (id 4711's shape changes with every refresh, sanitization misses PII in free-text columns, and parallel tests trample each other). GOOD: "Factories with per-test-seeded Faker create each test's users inside a rolled-back transaction; one synthetic snapshot mirrors prod's skew for query tests."

```
TEST DATA PLAN
══════════════
FACTORIES: [lib] · defaults=[valid minimal object] · overrides=per-test
SEEDING: seed=[per-test id] · printed-on-failure=yes · unseeded-random=banned
FIXTURES: [<10 golden files] · reason-required=yes
PII: prod-copies=banned · synthetic=[generator/tool] · realism=[skew+edge values]
ISOLATION: unit/integration=[txn rollback] · e2e=[unique-suffix per test/worker]
CLEANUP: [structural: rollback/drop-schema] · not=[manual DELETE lists]
```

Skip when: the suite is pure-function unit tests with inline literal inputs, or a throwaway spike where data realism doesn't matter yet.

Gotchas: factories that create a web of associations by default make every test drag in ten rows and hide what actually matters — keep defaults minimal and make associations opt-in; "cleanup at the start of the next run" means a failed run poisons the following one — clean structurally, not procedurally; time is test data too: unfrozen `now()` causes month-boundary and DST flakes, so inject a clock; sequential IDs in factories collide under parallel workers — use UUIDs or worker-prefixed sequences.
