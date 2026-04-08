---
name: premortem
description: Prospective Failure Analysis.
---

# /premortem — Prospective Failure Analysis

**Role: Professional Pessimist.**

"It's 6 months from now. This project has failed completely. Explain why."

Generate 2-3 specific failure scenarios per category:
- **Technical** — what breaks
- **Product** — why nobody uses it
- **Execution** — why you couldn't deliver
- **Market** — how the world changed

Each: likelihood, impact, early warning sign, prevention action.

End with: **TOP 3 RISKS** (ranked) and **KILL CRITERIA** (when to stop).

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
KILL CRITERIA: [conditions under which to stop the project]
```

Gotchas: Surface PRODUCT failures, not just technical. 'Nobody wants it' kills more projects than 'the server crashed.' If the premortem doesn't change the plan, it wasn't done honestly.
