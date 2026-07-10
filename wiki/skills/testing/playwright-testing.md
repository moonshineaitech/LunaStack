---
name: playwright-testing
description: Use when writing or reviewing Playwright end-to-end tests and you want reliable, non-flaky tests with correct waiting and selectors. Produces a review against E2E flakiness traps.
---

# /playwright-testing — Reliable Playwright E2E

Use when writing Playwright tests or fixing flaky ones.

**Persona: E2E Test Engineer.** You never sleep, you assert on user-visible state, and you write selectors a designer's refactor won't break.

Rely on Playwright's **auto-waiting** — locators wait for elements to be actionable — so **never `page.waitForTimeout(ms)`** (a fixed sleep is the #1 source of flakiness and slowness); use web-first assertions (`await expect(locator).toBeVisible()`) which retry until true. Select by **user-facing attributes**: `getByRole`, `getByLabel`, `getByText`, or `data-testid` — never brittle CSS/XPath chains that break on restyle. Isolate tests: each test independent, no shared mutable state, use fixtures for setup and `beforeEach`. Keep tests deterministic — mock external/network flakiness (`page.route`), control time/clock, seed data. Run in parallel (Playwright does by default) so tests must not collide on shared resources. Use trace/video on failure for debugging. Assert on outcomes users see, not implementation details.

BAD: `await page.click('.btn-primary'); await page.waitForTimeout(2000); expect(...)` — brittle CSS + arbitrary sleep that's simultaneously flaky (too short) and slow (too long). GOOD: `await page.getByRole('button', {name:'Submit'}).click(); await expect(page.getByText('Saved')).toBeVisible()` — role selector + auto-retrying assertion.

```
PLAYWRIGHT REVIEW
═════════════════
□ No waitForTimeout — rely on auto-wait + web-first assertions
□ getByRole/Label/Text/testid (no brittle CSS/XPath)
□ Tests isolated (independent, no shared mutable state)
□ Network/time mocked for determinism (page.route, clock)
□ Parallel-safe (no shared-resource collisions)
□ trace/video on failure enabled
□ Assert user-visible outcomes, not internals
```

Skip when: a pure unit test — use the unit framework, not a browser.

Gotchas: `waitForTimeout` is the top flakiness cause — use auto-waiting assertions. CSS/XPath selectors break on restyle; use roles/testids. Tests sharing mutable state collide under parallel execution.
