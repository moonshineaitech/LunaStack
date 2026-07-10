---
name: perf-budget
description: Use when starting a user-facing feature or reviewing a PR that adds JS/CSS/images/fonts or new API endpoints. Set numeric performance budgets BEFORE building and enforce them in CI, so weight and latency constrain decisions instead of being discovered after ship.
---

# /perf-budget — Performance Budget

**Role: Performance Lead.** Set budgets BEFORE building, enforce during.

```
PERFORMANCE BUDGET
══════════════════
Page load (mobile 4G):
  First Contentful Paint: < 1.5s
  Largest Contentful Paint: < 2.5s
  Cumulative Layout Shift: < 0.1
  Interaction to Next Paint: < 200ms
  Total page weight: < 500KB (compressed)
  
JavaScript budget: < 200KB (compressed, all bundles)
CSS budget: < 50KB (compressed)
Image budget: < 200KB per page (compressed, responsive)
Font budget: < 100KB (2 families max)
  
API response time:
  p50: < 100ms
  p95: < 500ms
  p99: < 1000ms

ENFORCEMENT
  □ Budget checked in CI (fail build if exceeded)
  □ Bundle analyzer runs on every PR
  □ Lighthouse scores tracked over time
  □ Real User Monitoring (RUM) for production data
```

Enforcement rule: block the PR if ANY single budget line is exceeded -- no averaging across pages, no "close enough." A 205KB JS bundle fails the 200KB budget, period. Even when a metric is still under budget, flag it if it regressed more than 10% from the last green build -- creep compounds. Cap "we'll fix it later" exceptions at zero: budget failures are merge blockers, not warnings.

Every number here must come from a real measurement -- Lighthouse or WebPageTest for load metrics, the bundle analyzer for weight, RUM or a load test for API percentiles. If a value wasn't measured, write "not measured" -- never estimate, back-solve from a target, or invent it.

BAD: "Ship it, we'll optimize later -- Lighthouse scored 92 on my laptop." (lab number on fast hardware, no budget, no enforcement)
GOOD: "PR blocked: JS bundle measured 240KB > 200KB budget. Code-split the dashboard charting lib (55KB) behind a dynamic import, re-measure before merge."

Skip when: internal tools, admin dashboards, or throwaway prototypes with no external users and no mobile traffic -- budgets add friction with no bounce-rate payoff there.

Gotchas: Don't set budgets after building -- set them before, so they constrain decisions during development. Don't measure only lab performance (Lighthouse) -- Real User Monitoring shows what actual users experience on real devices. Don't let JavaScript budget creep past 200KB compressed -- every KB beyond that measurably increases bounce rate on mobile.
