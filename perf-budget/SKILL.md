---
name: perf-budget
description: Performance Budget.
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

Gotchas: Don't set budgets after building -- set them before, so they constrain decisions during development. Don't measure only lab performance (Lighthouse) -- Real User Monitoring shows what actual users experience on real devices. Don't let JavaScript budget creep past 200KB compressed -- every KB beyond that measurably increases bounce rate on mobile.
