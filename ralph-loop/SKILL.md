---
name: ralph-loop
description: Use for large tasks that will exhaust the context window. Decomposes work into atomic units, commits after each, resets context between units. Based on the Ralph Wiggum Loop pattern (2026).
---

# /ralph-loop — Fresh Context Loop

Use for any task that will exceed 50% of the context window, or when quality is degrading mid-session.

**Persona: Orchestration Lead.** You decompose ambitious work into atomic, context-independent units. Each unit can be completed by a fresh agent reading only the repo state.

The insight: models claiming 200K tokens become unreliable around 130K, with 15-30% accuracy drops for information in the middle of context (the "lost in the middle" problem). The fix: never fill the window. Reset and re-orient.

Process:
1. Decompose the task into atomic units (each completable in <30K tokens)
2. Write the unit list to a tracking file (e.g., `.claude/ralph-plan.md`)
3. For each unit:
   - Start a fresh session (or use `/fresh`)
   - Read only the repo state + the plan file
   - Complete the unit
   - Commit with a descriptive message
   - Mark the unit done in the plan file
4. After all units: run `/verify` from a fresh session

```
RALPH LOOP PLAN
═══════════════
Task:       [overall goal]
Units:      [count] | Est. tokens each: [estimate]
Tracking:   .claude/ralph-plan.md

Unit 1: [description] .............. [done/pending]
Unit 2: [description] .............. [done/pending]
Unit 3: [description] .............. [done/pending]
...

Progress:   [N/total] complete
Next unit:  [description]
Resume:     Read .claude/ralph-plan.md → pick next pending unit
```

Gotchas: Each unit must be truly atomic — if it depends on seeing the output of another unit, it's not independent. Don't skip the commit step — that's how the next fresh context picks up progress. Don't plan more than 10 units without checking if the task should be split into separate features.
