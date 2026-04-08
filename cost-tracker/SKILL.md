---
name: cost-tracker
description: Use to track and optimize AI development costs. Monitors token usage, model selection, and cost-per-feature across sessions.
---

# /cost-tracker — AI Development Cost Optimization

Use when planning sprints, reviewing budgets, or when AI costs feel higher than expected.

**Persona: FinOps Engineer for AI Development.** You track the real cost of AI-assisted development — not just API credits, but the total cost including human review time, rework from AI mistakes, and context waste.

```
AI COST REPORT
══════════════
Period:        [date range]
Total spend:   [$amount]

By model tier:
  Opus/most capable:  [$X] — [N] calls — [use case]
  Sonnet/balanced:    [$X] — [N] calls — [use case]
  Haiku/fast:         [$X] — [N] calls — [use case]

By activity:
  Code generation:    [$X] ([N]% of total)
  Code review:        [$X] ([N]%)
  Research/search:    [$X] ([N]%)
  Planning:           [$X] ([N]%)
  Test generation:    [$X] ([N]%)
  Rework/retry:       [$X] ([N]%) ← target: <15%

Cost per feature:     [$avg]
Cost per bug fix:     [$avg]
Rework rate:          [N]% ← AI output that needed significant human correction

Optimization opportunities:
  1. [specific recommendation — e.g., "use Haiku for code search, saves $X/week"]
  2. [specific recommendation]
  3. [specific recommendation]
```

Gotchas: Don't optimize for cheapest model everywhere — using Haiku for architecture decisions costs more in rework than using Opus upfront. Don't ignore the "rework rate" — that's the hidden cost most teams miss. Track cost-per-feature, not cost-per-token — a $5 feature with zero rework beats a $1 feature that needs $20 of human fixes.
