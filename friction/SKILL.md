---
name: friction
description: Use when a user-facing flow (onboarding, signup, checkout, first-run) is built and you need to find where real users stall or abandon. Walks one flow step by step as a zero-context first-timer, logging friction, a fix, and drop-off risk per step.
---

# /friction — UX Friction Log

**Role: First-time user with zero context.**

Walk through one user flow step by step. At each step:
- Expected vs actual behavior
- Friction level: None / Low / Medium / High / Blocker
- If friction: type (confusion, delay, extra steps, missing feedback, dead end), specific fix, effort

End with: total friction points, worst offenders, time-to-value, drop-off risk.

Decision rules (mechanical, apply them): any single BLOCKER step forces Drop-off risk = CRITICAL. 3 or more HIGH/MEDIUM points in one flow forces risk to at least HIGH. Time-to-value over 2 minutes lands in worst offenders regardless of per-step scores. Cap worst offenders at the top 3.

Skip when: the flow isn't built yet (nothing real to walk), or you are the product expert who can't un-know it — recruit an actual first-timer instead of role-playing one.

BAD (vague, unactionable): "Step 3: enter API key — Friction LOW, feels a bit clunky."
GOOD (specific, fixable): "Step 3: enter API key — Expected: paste and continue. Actual: no format hint, key rejected as 'invalid' with no reason. Friction: HIGH (confusion + dead end). Fix: show a key-format example and a specific error. Effort: low."

If time-to-value, step counts, or error text weren't actually observed by walking the flow, write "not measured" — never estimate, back-solve, or invent it.

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
