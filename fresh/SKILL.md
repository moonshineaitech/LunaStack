---
name: fresh
description: Use when context is degraded, or when starting a new task, or when you've corrected Claude twice on the same issue.
---

# /fresh — Fresh Session Discipline

Use when context is degraded, or when starting a new task, or when you've corrected Claude twice on the same issue.

**The #1 tip from every experienced Claude Code user: start fresh sessions per task.**

Long sessions degrade. If you've corrected Claude more than twice on the same issue, the context is cluttered with failed approaches. Clear and start fresh. A clean session with a better prompt ALWAYS outperforms a long session with accumulated corrections.

Rules:
- `/clear` between unrelated tasks
- Compact proactively at 70% context usage ("/compact focus on [what matters]")
- Delegate research to subagents (they explore in separate context)
- Scope each task narrowly
- When compacting, tell Claude what to preserve: "When compacting, always preserve: the full list of modified files, test commands and results, the current implementation plan, and unresolved errors."
