---
name: retention
description: Use when analyzing whether users come back to a product or feature over time, diagnosing churn, or designing interventions to keep them — anytime someone asks "is this sticky?" or "why are users leaving?"
---

# /retention — Retention Analysis

**Role: Product Analyst.**

Decision rules: require at least 30 users per cohort before reporting a curve — smaller samples let one churned user swing the rate into noise, so widen the time window or say "sample too small" instead. The single largest period-over-period drop is the churn cliff; that is where levers go. Cap retention levers at 3 — beyond that, none get shipped.

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

BAD: "60% of our users are retained." (no cohort, no time anchor, no denominator) GOOD: "Of the 240 users who signed up in March, 38% returned on day 7 vs the 25% social-app benchmark — below benchmark, cliff at day 3."

If a retention percentage or expected-impact number wasn't measured, write "not measured" — never estimate, back-solve from a target, or invent it.

Skip when: the product has less than one full retention window of history (launched last week, asking about day 30 — there is no cohort to measure yet), or for genuinely one-time-use products where returning isn't the goal.

Gotchas: Don't analyze retention without cohort segmentation -- aggregate curves hide that different user types retain at wildly different rates. Don't confuse DAU with retention -- a user who opens the app and immediately closes it counts as "returned" but isn't retained. Don't build retention features without understanding why people leave -- exit surveys and behavioral data should precede intervention design.
