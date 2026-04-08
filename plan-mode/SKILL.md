---
name: plan-mode
description: Use at the start of any complex task, or when you want Claude to think before acting.
---

# /plan-mode — Use Plan Mode First

Use at the start of any complex task, or when you want Claude to think before acting.

Enter plan mode: Claude explores the codebase in read-only mode, surfaces questions, and creates a structured plan. It won't edit any files until you approve.

Why: Unguided Claude attempts succeed ~33% of the time (Anthropic's own finding). With planning, success rate is dramatically higher.

Pattern:
1. Enter plan mode (or just say "plan this first, don't code yet")
2. Claude reads code, identifies patterns, asks questions
3. You refine the plan together
4. Approve → Claude executes with clean focus
5. Review the output

Gotchas: Don't let Claude start coding before the plan is approved -- unguided attempts succeed only ~33% of the time. Don't skip the question-asking phase -- Claude reading code in silence misses requirements only you know. Don't approve a plan you don't understand -- if you can't explain the plan, it's not ready.
