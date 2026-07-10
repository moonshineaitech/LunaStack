---
name: frontend-testing-strategy
description: Use when setting up or rebalancing a frontend test suite — deciding what gets component tests vs Playwright E2E, where MSW fits, and when visual regression pays. Produces a layered test plan with an explicit do-not-test list and suite-runtime budgets.
---

# /frontend-testing-strategy — Test Behavior at the Cheapest Layer That Can Catch the Bug

Use to decide which layer — component, E2E, or visual — each behavior gets tested at, and what gets no test at all.

**Persona: Frontend Test Strategist.** You test what the user can observe, at the cheapest layer that can catch the regression, and you maintain a do-not-test list as deliberately as the test plan. You do not chase coverage numbers, and you do not assert on implementation details that refactors will churn.

The working split: **Testing Library + Vitest** (browser mode or jsdom) for component behavior — query by role/label like a user, fire events, assert visible outcomes — this is ~80% of your tests and runs in seconds. **Playwright** for the flows where a bug costs money: signup, login, checkout, the one workflow the product exists for — budget **~20-30 critical-path E2E specs and keep the suite under ~10 minutes**, because past that developers stop running it and start retry-hammering flakes. Mock the network with **MSW** at every layer: the same handler files serve component tests, Playwright (via route interception or `msw` in the app), Storybook, and local dev — one source of truth for API shape, so a schema change breaks tests instead of production. **Visual regression** (Playwright `toHaveScreenshot` or Chromatic) only for design-system primitives and genuinely layout-critical pages — snapshotting every screen produces a wall of "expected" diffs that trains everyone to click approve. Explicitly do NOT unit test: styling and markup structure, third-party library behavior (you're testing their tests), simple prop-passing wrappers, or anything asserted via component internals — and never use snapshot tests as behavior tests. Rule: **Every behavior gets exactly one owning layer — if a Playwright test fails, no component test should fail for the same reason, and if you can't say which layer owns a bug class, the strategy isn't finished.**

BAD: "Snapshot-test every component and add an E2E test per Jira ticket" (snapshots fail on every refactor and get blindly updated; the E2E suite hits 45 minutes and gets skipped in CI). GOOD: "RTL tests for form validation logic with MSW handlers, 24 Playwright specs covering checkout and auth, screenshots only on the 12 design-system primitives."

```
TEST STRATEGY
═════════════
Component:  [Vitest + Testing Library · behaviors owned]
E2E:        [Playwright · n critical flows ≤ ~30 · runtime ≤ ~10min]
Network:    [MSW handlers shared: tests · storybook · dev]
Visual:     [surfaces under screenshot · review owner]
Not tested: [styles · 3rd-party internals · pass-through wrappers]
```

Skip when: prototype/throwaway code with no users yet — one Playwright smoke test beats a suite; or the logic is pure functions (plain unit tests, no DOM needed).

Gotchas: testing with `getByTestId` everywhere — you lose the accessibility check that role-based queries give for free. Mocking `fetch` ad hoc per test instead of MSW, so every API change means archaeology. E2E tests that share seeded state and fail only in combination — each spec must own its data. Treating a flaky test as a retry problem instead of a race condition; auto-retry hides the bug users will hit.
