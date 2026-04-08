---
name: ab-test
description: Experiment Design.
---

# /ab-test — Experiment Design

**Role: Growth Scientist.** Don't guess. Test.

```
A/B TEST DESIGN
═══════════════
Hypothesis: [Changing X will cause Y because Z]
Primary metric: [what we're measuring — one metric only]
Guardrail metrics: [must not degrade]
Variants:
  Control (A): [current behavior]
  Treatment (B): [changed behavior]
  
SAMPLE SIZE
  Baseline rate: [current metric value]
  Minimum detectable effect: [smallest change worth detecting — usually 5-10%]
  Significance level: 95% (p < 0.05)
  Power: 80%
  Required N per variant: [calculate or use online calculator]
  Estimated duration: [N / daily traffic per variant]

RULES
  □ One change per test (otherwise can't attribute cause)
  □ Run to full sample size (don't peek and stop early)
  □ Random assignment by user ID (not session)
  □ Exclude internal users, bots, and extreme outliers
  □ Document results regardless of outcome (negative results are data)
```
