---
name: premortem
description: Use before committing to a plan or project. Assume it already failed, explain why — with category quotas so product and execution failures get equal airtime with technical ones.
---

# /premortem — Prospective Failure Analysis

**Role: Professional Pessimist.**

"It's 6 months from now. This project has failed completely. Explain why."

Category quotas — minimum scenarios per category (forces breadth; technical-only premortems are the #1 failure of this exercise):
- **Technical** — what breaks (min 2)
- **Product** — why nobody uses it (min 2)
- **Execution** — why you couldn't deliver (min 1)
- **Market** — how the world changed (min 1)

Each: likelihood, impact, early warning sign, prevention action.

Scoring rubric: likelihood and impact each rated H/M/L. Only H×H and H×M scenarios are eligible for the TOP 3 — if fewer than 3 qualify, say so rather than promoting M×M filler.

End with: **TOP 3 RISKS** (ranked) and **KILL CRITERIA** — 2-3 MEASURABLE abort conditions. A kill criterion needs a number and a date, or it will never trigger.

BAD kill criterion: "Stop if users don't like it." (unmeasurable, will be rationalized away)
GOOD kill criterion: "Stop if D7 retention < 10% after 500 signups, or if <15% of any segment converts after 2 months."

```
PREMORTEM ANALYSIS
═══════════════════
Technical failures:  [scenario] — likelihood [H/M/L] impact [H/M/L]
Product failures:    [scenario] — likelihood [H/M/L] impact [H/M/L]
Execution failures:  [scenario] — likelihood [H/M/L] impact [H/M/L]
Market failures:     [scenario] — likelihood [H/M/L] impact [H/M/L]
TOP 3 RISKS:
  1. [risk] — early warning: [signal] — prevention: [action]
  2. [risk] — early warning: [signal] — prevention: [action]
  3. [risk] — early warning: [signal] — prevention: [action]
KILL CRITERIA: [measurable conditions with numbers and dates]
```

Skip when: the work is small and reversible (a feature behind a flag, an internal tool) — premortem the launches, not the experiments.

Gotchas: Surface PRODUCT failures, not just technical. 'Nobody wants it' kills more projects than 'the server crashed.' If the premortem doesn't change the plan, it wasn't done honestly.
