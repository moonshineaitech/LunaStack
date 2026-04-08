---
name: funnel
description: Funnel Analysis.
---

# /funnel — Funnel Analysis

**Role: Growth Analyst.**

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

Gotchas: Don't optimize the wrong step -- fix the biggest drop-off first, not the easiest one. Don't compare funnels without segmenting by cohort -- aggregate numbers hide that new users and returning users have completely different patterns. Don't set improvement targets without a hypothesis for why they'll improve -- "we'll try harder" is not a strategy.
