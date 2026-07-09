---
name: funnel
description: Use when conversion is leaking between steps of a signup, onboarding, checkout, or activation flow and you need to find and fix the worst drop-off. Maps each step, quantifies drop, and targets the single biggest leak with a hypothesis and one experiment.
---

# /funnel — Funnel Analysis

**Role: Growth Analyst.**

Decision rule: cap the funnel at the 3–6 steps that matter; past 6 steps you are measuring noise, so collapse or drop the rest. Flag a step as a leak only if it loses >30% of the users who reached it; below 15% drop, leave it alone and look upstream. Fix exactly ONE step per pass — never run two step-experiments at once, or you cannot attribute the win.

BAD: "Improve conversion by 20% across the funnel." — no step, no reason, no test, nothing to ship.
GOOD: "Step 3→4 (register → first action) loses 62%, the biggest drop. Hypothesis: the empty state gives no obvious first action. Experiment: add a 3-item starter checklist. Target 38% → 55%."

```
FUNNEL: [name — e.g., signup-to-first-value]
═══════════════════════════════════════════

Step 1: [Landing page visit]     — [N] users (100%)
Step 2: [Click signup]           — [N] users ([X]% conversion)
Step 3: [Complete registration]  — [N] users ([X]% conversion)
Step 4: [First action]           — [N] users ([X]% conversion)
Step 5: [Return visit]           — [N] users ([X]% conversion)

BIGGEST DROP: Step [N] → Step [N+1] ([X]% lost here)
HYPOTHESIS: Why they leave: [specific reason]
EXPERIMENT: [what to test to improve this step]
TARGET: Improve step [N] conversion from [X]% to [Y]%
```

Every N and % comes from real analytics: if a step's count wasn't measured, write "not measured" — never estimate, back-solve a percentage, or invent a number to make the funnel look complete.

Skip when: fewer than ~100 users have reached the funnel (step rates are noise at that sample size), or when a single step is outright broken (500 error, dead button, failed redirect) — that's a bug for /debug, not a funnel to analyze.

Gotchas: Don't optimize the wrong step -- fix the biggest drop-off first, not the easiest one. Don't compare funnels without segmenting by cohort -- aggregate numbers hide that new users and returning users have completely different patterns. Don't set improvement targets without a hypothesis for why they'll improve -- "we'll try harder" is not a strategy.
