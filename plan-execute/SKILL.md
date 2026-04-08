---
name: plan-execute
description: Plan Mode → Auto-Accept (Boris's Core Pattern).
---

# /plan-execute — Plan Mode → Auto-Accept (Boris's Core Pattern)

Use for any non-trivial task (3+ steps).

Boris's workflow:
1. **Start in Plan Mode** (Shift+Tab twice in Claude Code, or say "plan this, don't code yet")
2. **Iterate on the plan** — go back and forth until you like it
3. **Switch to auto-accept mode** — Claude executes the entire implementation in one shot
4. **Review the diff** — accept or revert

Why this works: Claude works best when it can commit to a structured plan. Forcing explicitness before execution prevents the classic failure: Claude makes 40 changes you didn't want.

For non-CC users: Step 1: "Plan how you'd build this. List every file you'd change and why. Don't write code yet." Step 2: Review and approve the plan. Step 3: "Now execute the plan."

```
PLAN → EXECUTE
═══════════════
Phase:       [PLANNING / EXECUTING / REVIEWING]
Plan steps:  [count]
Step 1: [description]  [files]  [status: planned/done/reverted]
Step 2: [description]  [files]  [status: planned/done/reverted]
...
Execution:   [auto-accept mode on/off]
Diff review:  [pending / accepted / reverted]
```

Gotchas: If something goes sideways during execution, STOP and re-plan immediately. Don't try to patch a broken plan.
