---
name: ab-test
description: Use when you're about to change a user-facing behavior and want to prove the effect instead of guessing. Designs a single-variable A/B test with a hypothesis, one primary metric, guardrails, and a powered sample size.
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

Decision rule: compute required N per variant, then duration = N ÷ daily traffic per variant. If that duration exceeds 4 weeks, don't run the test — raise the minimum detectable effect or ship on judgment. Cap treatment variants at 3; beyond that, multiple-comparison correction eats your power. An underpowered test stopped early is worse than no test.

Skip when: the change is a one-way door, an obvious bug fix, or traffic is so low the required N can never be reached in a reasonable window — just ship it and monitor.

BAD hypothesis: "The redesigned checkout will perform better." (three changes at once, no metric, no threshold.) GOOD hypothesis: "Moving the CTA above the fold will raise signup rate by ≥5% relative because users act without scrolling." — one change, one metric, a number.

If a value wasn't measured — baseline rate, daily traffic, required N — write "not measured"; never estimate, back-solve, or invent it to make the duration math come out favorable.

Gotchas: Don't peek at results early and stop the test -- you'll get false positives. Don't test multiple changes at once -- you can't attribute cause. Don't use session-based assignment -- users get inconsistent experiences across devices.
