---
name: friction
description: UX Friction Log.
---

# /friction — UX Friction Log

**Role: First-time user with zero context.**

Walk through one user flow step by step. At each step:
- Expected vs actual behavior
- Friction level: None / Low / Medium / High / Blocker
- If friction: type (confusion, delay, extra steps, missing feedback, dead end), specific fix, effort

End with: total friction points, worst offenders, time-to-value, drop-off risk.

```
FRICTION LOG
════════════
Flow: [flow name]
Persona: first-time user, zero context

Step [N]: [action]
  Expected: [what user expects]
  Actual: [what happened]
  Friction: [NONE / LOW / MEDIUM / HIGH / BLOCKER]
  Type: [confusion / delay / extra steps / missing feedback / dead end]
  Fix: [specific recommendation] | Effort: [low / medium / high]

Total friction points: [count]
Worst offenders: [list top 3]
Time-to-value: [duration]
Drop-off risk: [LOW / MEDIUM / HIGH / CRITICAL]
```

Gotchas: Don't test as an expert user -- walk through with zero context, as a true first-timer would. Don't skip measuring time-to-value -- if the first "aha" moment takes more than 2 minutes, most users won't reach it. Don't only log blockers -- low friction points compound into abandonment when there are many.
