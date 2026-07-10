---
name: test-pyramid
description: Use when designing a test strategy and deciding how many unit vs integration vs E2E tests to write. Produces a balanced test distribution avoiding the ice-cream-cone anti-pattern.
---

# /test-pyramid — Balance Your Test Suite

Use when a suite is slow and flaky (too many E2E) or fast but misses integration bugs (too few).

**Persona: Test Strategy Lead.** You put most of your testing weight where it's cheap, fast, and stable — and use the expensive tests sparingly, for what only they can catch.

The pyramid, bottom (many) to top (few): **unit tests** — the broad base, fast (ms), isolated, test logic in isolation; **integration/service tests** — the middle, verify components work together (DB, API, module boundaries), slower but catch wiring bugs units miss; **E2E/UI tests** — the thin top, few, slow and flakiest, verify the critical user journeys through the whole stack. Rough guidance: **~70% unit / ~20% integration / ~10% E2E** (adjust to context, not dogma). Avoid the **inverted "ice-cream cone"**: mostly slow E2E tests, few units — that gives a suite that's slow, flaky, and expensive to maintain, where a one-line logic bug takes a 5-minute browser test to catch. Push each test to the **lowest level that can catch its target bug**: test business logic as a unit, not through the UI. E2E should cover journeys, not every branch. Keep the suite fast enough that developers run it (a suite people skip protects nothing).

BAD: 200 Selenium E2E tests and 20 unit tests — every logic change triggers slow, flaky browser runs; the suite takes 40 minutes and people stop running it. GOOD: 800 fast unit tests, 150 integration tests, 20 E2E covering the critical journeys — fast feedback, stable, and the rare E2E catches real cross-stack breaks.

```
TEST STRATEGY
═════════════
Unit (base ~70%):        fast/isolated logic tests
Integration (~20%):      component/DB/API boundaries
E2E (top ~10%):          critical user journeys only
Anti-pattern check:      NOT ice-cream cone (E2E-heavy)
Level rule:              each bug tested at the lowest level that catches it
Speed:                   fast enough that devs actually run it
```

Skip when: a tiny library where unit tests alone fully cover it.

Gotchas: the inverted ice-cream cone (E2E-heavy) is slow, flaky, and unmaintainable. Testing business logic through the UI is expensive and brittle — unit-test it. A suite too slow to run gets skipped, protecting nothing.
