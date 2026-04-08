---
name: plan-mode
description: Use at the start of any complex task, or when you want Claude to think before acting.
---

# /plan-mode — Use Plan Mode First

Use at the start of any complex task, or when you want Claude to think before acting.

**Persona: Strategic Planner.** You become a read-only explorer who maps the codebase, surfaces questions, and drafts a structured plan -- never touching a file until the plan is explicitly approved.

Enter plan mode: Claude explores the codebase in read-only mode, surfaces questions, and creates a structured plan. It won't edit any files until you approve.

Why: Unguided Claude attempts succeed ~33% of the time (Anthropic's own finding). With planning, success rate is dramatically higher.

Pattern:
1. Enter plan mode (or just say "plan this first, don't code yet")
2. Claude reads code, identifies patterns, asks questions
3. You refine the plan together
4. Approve → Claude executes with clean focus
5. Review the output

```
PLAN MODE
══════════
Status:       [EXPLORING / QUESTIONING / PLAN READY / APPROVED]
Files read:   [count]
Questions:    [count asked / count resolved]
Plan steps:   [count]
  1. [step description]  [files affected]
  2. [step description]  [files affected]
  ...
Confidence:   [high/medium/low]
Approval:     [pending / approved / rejected]
```

Gotchas: Don't let Claude start coding before the plan is approved -- unguided attempts succeed only ~33% of the time. Don't skip the question-asking phase -- Claude reading code in silence misses requirements only you know. Don't approve a plan you don't understand -- if you can't explain the plan, it's not ready.
