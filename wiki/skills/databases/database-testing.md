---
name: database-testing
description: Use when setting up or fixing the database layer of a test suite — flaky data tests, mocked repositories hiding real bugs, migrations that only fail in production. Produces a database test architecture: ephemeral real-engine containers, migration tests in CI, factory-based seed data, and a per-test isolation strategy with speed budgets.
---

# /database-testing — Test Against the Database You Deploy

Use to build a test suite that runs against a real database engine fast enough that nobody is tempted to mock it.

**Persona: Test Infrastructure Engineer.** Provisions the production engine and major version in tests via containers, makes per-test isolation cheap, and does NOT accept mocked repositories or SQLite-standing-in-for-Postgres as evidence that database code works — nor let the suite crawl so slowly that developers stop running it.

The **mock-database lie**: a mocked repository verifies you called the mock, not that your SQL is valid, your constraints fire, your transaction boundaries hold, or your ORM generates the query you think it does — the exact bug classes that page you. Swapping in SQLite is the same lie with better ergonomics: it differs from Postgres on types, constraint timing, upsert semantics, and concurrency, so green tests prove nothing. Instead run the real engine, same **major version as production**, via **Testcontainers** (Java/Go/Python/Node/.NET all have first-class modules) or a compose-managed container in CI. Make it fast with a two-layer scheme: start one container per suite, run **migrations from an empty schema** once (this IS your migration test — plus, for mature apps, apply new migrations against a scrubbed production-schema snapshot to catch lock-taking `ALTER`s and slow backfills), then isolate per-test with **transaction rollback** (open a transaction, run the test inside, roll back — sub-millisecond) and fall back to Postgres **template-database cloning** (`CREATE DATABASE test_n TEMPLATE golden`, ~100–200ms) only for tests that themselves commit, use multiple connections, or test transaction logic. Seed data comes from **factories** (factory_bot, Fishery, polyfactory, or a hand-rolled builder) that create only what the test names and randomize the rest — shared fixture dumps rot into a swamp where no one knows which test depends on which row. Budget: if per-test DB overhead exceeds ~50ms or the suite's DB portion exceeds ~2 minutes, fix the isolation layer before anyone reaches for mocks. Rule: **Every test that exercises SQL, constraints, or transactions runs against the production engine and major version — a test that passes on a mock or a different engine is not a database test.**

BAD: "Mock the repository layer in unit tests and trust the ORM — integration tests are slow" (the ON DELETE CASCADE you forgot, the unique constraint race, and the N+1 all ship untested). GOOD: "Testcontainers Postgres 17 matching prod, migrations-from-zero on suite start, transaction-rollback per test at ~1ms each — the mock argument dies when real is this fast."

```
DB TEST ARCHITECTURE
════════════════════
ENGINE: [postgres 17.x / mysql 8.x] · matches prod: [y/n] · via: [testcontainers/compose]
SCHEMA: migrations from zero on start [y/n] · new-migration check vs prod snapshot [y/n]
ISOLATION: default [tx-rollback] · commit-needing tests: [template clone / truncate]
SEED: factories [lib] · shared fixtures: [none/justified list]
SPEED: per-test overhead [ms, budget ~50] · suite DB time [s]
CI: [container cached? parallel workers × own DB?]
```

Skip when: the code under test genuinely never touches persistence (pure functions, protocol parsing), or you're testing against an unmockable managed service (DynamoDB, Spanner) — use the vendor's local emulator and pin its version instead.

Gotchas: transaction-rollback isolation silently breaks code that opens its own transactions or asserts on `NOTIFY`/commit hooks — those tests need real commits, so keep an escape hatch; `TRUNCATE ... RESTART IDENTITY CASCADE` between tests looks clean but is 10–50× slower than rollback and still misses sequences you forgot; parallel test workers sharing one database deadlock intermittently — give each worker its own database (cheap with templates); and testing migrations only in the up direction means your first production rollback is also your first rollback test.
