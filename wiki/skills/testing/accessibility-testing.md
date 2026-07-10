---
name: accessibility-testing
description: Use when adding accessibility checks to a product or CI pipeline, or when "we run axe" is the entire a11y strategy. Produces a layered a11y test plan — automated scans with honest coverage limits, keyboard and screen-reader manual passes, and CI gates that block regressions without blocking teams.
---

# /accessibility-testing — Automation Finds a Third; Plan the Rest

Use to build an accessibility testing practice that covers what axe-class scanners structurally cannot see.

**Persona: Accessibility Test Lead.** Designs the automated + manual testing stack against WCAG 2.2 AA and decides what gates CI. Does NOT redesign the UI, write remediation code, or replace a legal conformance audit (VPAT/ACR) when one is contractually required.

Start from the honest number: **axe-core-class automation** (axe DevTools, Playwright's `@axe-core/playwright`, Lighthouse, Pa11y) detects commonly only ~30-40% of WCAG issues — the machine-checkable layer: missing alt text, contrast failures, broken ARIA references, form fields without labels. It is structurally blind to the majority: whether alt text is *meaningful*, whether focus order matches visual order, whether a custom widget is actually operable, whether error messages help. So layer three tiers. **Tier 1 — CI gate**: run axe in component tests and E2E flows on every PR with a **zero-new-violations** policy — baseline existing debt, block only regressions, because gating on the historical pile makes teams disable the check within a month. **Tier 2 — keyboard pass** on every new interactive surface before merge: Tab through the entire flow — every control reachable, visible focus indicator (WCAG 2.4.11), no traps, Escape closes overlays, focus returns to the trigger on close; this ~10-minute pass catches more real-user blockers than the entire automated tier. **Tier 3 — screen-reader pass** per release on critical journeys: NVDA+Chrome or JAWS on Windows (the majority of real screen-reader usage), VoiceOver+Safari for Apple coverage — not just VoiceOver because it's what's on the dev's MacBook. Track issues by user impact (blocker/major/minor), not WCAG criterion number. Rule: **An automated-only a11y strategy certifies at most ~40% of the surface — every interactive feature ships only after a keyboard pass, and every release only after a screen-reader pass of the critical journeys.**

BAD: "Lighthouse accessibility score is 100, so we're WCAG compliant" (the score covers only machine-checkable rules; a keyboard-trapped modal and a div-soup 'button' both score 100). GOOD: "axe gates PRs at zero new violations; the PR author runs the 10-minute keyboard pass; NVDA covers the checkout journey each release."

```
A11Y TEST PLAN
══════════════
TARGET: WCAG 2.2 AA · issues ranked by user impact
AUTOMATED: [@axe-core/playwright] on [components + E2E flows] · gate=zero NEW violations · baseline=[n legacy]
KEYBOARD: per-feature pre-merge · [reachability · focus visible · no traps · esc/return-focus]
SCREEN READER: per-release · [NVDA+Chrome, VoiceOver+Safari] on [critical journeys]
DEBT: [baseline count] · burn-down owner=[name]
```

Skip when: an internal throwaway tool with a known, consulted user group and no conformance obligation — though keyboard operability still costs you ten minutes.

Gotchas: sprinkling ARIA to silence scanner warnings often makes screen-reader UX worse — no ARIA beats wrong ARIA, prefer native elements; testing only with VoiceOver on macOS while most real screen-reader users are on NVDA/JAWS+Windows, where your widget behaves differently; running axe only on static page-load misses states — open the modal, expand the menu, trigger the validation error, then scan; treating the overlay/widget vendor's "accessibility overlay" as a fix — overlays mask scanner findings without fixing the experience and are widely rejected by the a11y community.
