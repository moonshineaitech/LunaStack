---
name: estimate
description: Three-Point Estimation.
---

# /estimate — Three-Point Estimation

For each task:
- Optimistic (O): everything goes right
- Most likely (M): normal friction
- Pessimistic (P): unfamiliar territory, integration issues

Expected = (O + 4M + P) / 6

Risk factors: unfamiliar tech (+50-100%), external dependencies (+30-50%), unclear requirements (+50-200%).

Produce: total range, confidence level, biggest risk, recommendation (timebox? spike first? ship in phases?).

```
ESTIMATE
════════
Task: [description]

               Optimistic   Most Likely   Pessimistic
  [subtask]    [O]          [M]           [P]
  [subtask]    [O]          [M]           [P]
  ─────────────────────────────────────────────
  Total        [sum O]      [sum M]       [sum P]

Expected: [weighted avg] | Range: [O] – [P]
Risk multipliers: [factor] ([reason])
Confidence: [HIGH / MEDIUM / LOW]
Biggest risk: [description]
Recommendation: [timebox / spike first / ship in phases]
```

Gotchas: Don't give a single number -- always give a range with confidence level. Don't estimate without adding risk multipliers for unfamiliar tech (1.5-2x) and unclear requirements (1.5-3x). Don't skip the "spike first" option for high-uncertainty tasks -- 2 hours of investigation saves days of wrong-direction building.

---
