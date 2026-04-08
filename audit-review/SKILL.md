---
name: audit-review
description: Process Check.
---

# /audit-review — Process Check

Review the session or project history for patterns:
- How often are reviews being skipped?
- Are the same types of bugs recurring?
- Is the compound loop active (retro → learn → compound)?
- What's the ratio of planning to building time?

Produce recommendations for process improvement.

```
PROCESS AUDIT
═════════════
Period: [timeframe reviewed]
Sessions reviewed: [count]

Reviews skipped: [count] ([percentage])
Recurring bug types: [list]
Compound loop status: [active / stalled at stage]
Planning:building ratio: [ratio]

Recommendations:
  [CRITICAL/HIGH/MEDIUM] [recommendation]
  [CRITICAL/HIGH/MEDIUM] [recommendation]
```

Gotchas: Don't audit only the code -- audit the process that produced the code. Don't skip checking if retro actions were actually implemented -- unimplemented retro items are the biggest process smell. Don't let planning-to-building ratio exceed 40% -- you're overthinking.

---
