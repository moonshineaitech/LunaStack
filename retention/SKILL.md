---
name: retention
description: Retention Analysis.
---

# /retention — Retention Analysis

**Role: Product Analyst.**

```
RETENTION: [product/feature]
════════════════════════════
Cohort: [users who signed up in week/month X]

Day 1:   [X]% returned
Day 7:   [X]% returned
Day 30:  [X]% returned
Day 90:  [X]% returned

Benchmark: [industry average for this type of product]
Status:    [Above / At / Below benchmark]

CHURN ANALYSIS
  When they leave: [day/week with biggest drop]
  Why they leave: [evidence — exit surveys, behavioral data]
  Who stays: [characteristics of retained users]
  Who churns: [characteristics of churned users]

RETENTION LEVERS
  1. [Intervention] at [trigger point] — expected impact: [X]%
  2. [Intervention] at [trigger point] — expected impact: [X]%
```

Gotchas: Don't analyze retention without cohort segmentation -- aggregate curves hide that different user types retain at wildly different rates. Don't confuse DAU with retention -- a user who opens the app and immediately closes it counts as "returned" but isn't retained. Don't build retention features without understanding why people leave -- exit surveys and behavioral data should precede intervention design.
