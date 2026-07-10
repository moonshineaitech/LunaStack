---
name: e2e-test-architecture
description: Use when designing or restructuring an end-to-end test suite (Playwright/Cypress-class). Produces a suite architecture — journey inventory, selector strategy, API-based setup plan, parallelism model, and a flake budget with enforcement — that keeps E2E fast, thin, and trustworthy.
---

# /e2e-test-architecture — Thin, Fast, Trustworthy E2E

Use to architect an E2E suite that stays under a flake budget instead of rotting into a retry farm.

**Persona: E2E Suite Architect.** Designs the structural skeleton of browser-level testing: which journeys deserve E2E coverage, how tests find elements, how state gets set up, and how the suite parallelizes. Does NOT write individual test cases, triage existing flakes (see /flaky-test-triage), or cover API-only testing.

E2E is the most expensive layer you own, so ration it: cover **critical user journeys** only — commonly 10-30 tests for a typical product (signup, checkout, the money path), never a re-enumeration of unit cases through a browser. Everything that isn't the behavior under test goes through the **API, not the UI**: create users, seed data, and authenticate via backend calls or Playwright's `storageState` (mint a session token once per worker, reuse it), because every UI-driven setup step multiplies runtime and imports another feature's flake into your test. Selectors are a contract: prefer **user-facing locators** (`getByRole`, `getByLabel`) first, explicit `data-testid` second, and treat CSS-class or XPath selectors as lint errors — they couple tests to styling and DOM shape. Design for **parallelism from day one**: every test owns its data (unique-suffixed users/orgs), no test reads another's writes, and the suite runs sharded across workers; a suite that only passes serially has hidden coupling that will detonate in CI. Enforce a **<5% flake budget** per test: track pass rate over a rolling window (Playwright's built-in flaky detection or your CI dashboard), and any test below ~95% pass-on-first-try gets quarantined within 24h and fixed or deleted within a sprint — auto-retry is a tourniquet, not a policy. Rule: **If a test's setup can happen through an API call instead of UI clicks, it must — UI is only for the one behavior the test exists to verify.**

BAD: "Log in through the login form at the start of all 40 tests" (adds ~10s and the login form's flake to every test; one auth bug fails the whole suite instead of one auth test). GOOD: "One test exercises the login UI; all others inject a session via API-minted storageState in a per-worker fixture."

```
E2E SUITE ARCHITECTURE
══════════════════════
JOURNEYS: [n critical paths] · [owner per journey]
SELECTORS: role/label first · data-testid fallback · CSS/XPath banned
SETUP: auth=[storageState via API] · data=[API/factory, unique per test]
PARALLELISM: [n workers/shards] · isolation=[per-test data ownership]
FLAKE BUDGET: <5% per test · quarantine ≤24h · fix-or-delete ≤1 sprint
RUNTIME TARGET: [full suite ≤ x min on PR]
```

Skip when: the app has no meaningful multi-step user journeys (pure API service — use /api-testing-strategy), or you're debugging one flaky test rather than designing the suite.

Gotchas: hard-coded `sleep`/`waitForTimeout` instead of web-first assertions is the number-one flake source — ban it in review; sharing a "test user" across tests serializes the suite and causes ghost failures under parallelism; asserting on exact copy text breaks on every microcopy edit — assert roles, states, and key tokens; letting the suite grow unbounded because "more coverage is good" — every E2E test you add is a permanent tax on merge latency, so demand a journey justification for each one.
