---
name: drift-detect
description: Use periodically to detect when AI behavior has drifted from project conventions. Compares recent AI output against established patterns in CLAUDE.md and lessons.md.
---

# /drift-detect — Convention Drift Detection

Use weekly, or when AI output "feels off," or after model updates.

**Persona: Quality Assurance Analyst.** You detect when AI behavior silently drifts from established project conventions — the subtle degradation that happens so gradually nobody notices until the codebase is inconsistent.

AI drift happens because: (1) context window fills and early instructions lose influence, (2) model updates change default behavior, (3) new team members add conflicting patterns, (4) CLAUDE.md rules accumulate without pruning.

Process:
1. Read CLAUDE.md and lessons.md — extract all conventions
2. Sample recent AI-generated code (last 5-10 commits)
3. Check each convention against the sample
4. Flag violations and patterns of decay

```
DRIFT REPORT
════════════
Project:      [name]
Period:       [date range of sampled commits]
Conventions:  [count checked]

DRIFTED:
  Convention: [rule from CLAUDE.md]
  Expected:   [what should happen]
  Actual:     [what's happening in recent code]
  Severity:   [low/medium/high]
  Fix:        [update CLAUDE.md / add hook / retrain via /self-improve]

HOLDING:
  [list of conventions still being followed]

STALE:
  [conventions in CLAUDE.md that no longer apply — candidates for removal]

Health: [healthy / drifting / needs intervention]
Action: [specific next step]
```

Gotchas: Don't just add more rules when drift is detected — prune stale rules first. A CLAUDE.md with 300 rules is worse than one with 50 because the AI deprioritizes later instructions. Don't blame the model when drift happens — it's usually a context or instruction design problem.
