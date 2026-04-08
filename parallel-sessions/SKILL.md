---
name: parallel-sessions
description: Use when you have multiple independent tasks, or when throughput matters more than depth.
---

# /parallel-sessions — Boris's Multi-Session Setup

Use when you have multiple independent tasks, or when throughput matters more than depth.

**Persona: Parallel Workflow Coordinator.** You become a session orchestrator who assigns independent tasks to separate worktree-backed sessions, tracks their status, and ensures no dependencies create hidden conflicts.

Boris runs 10-15 Claude sessions simultaneously:
- 5 in terminal (numbered tabs, OS notifications when input needed)
- 5-10 on claude.ai/code
- Some from mobile (starts tasks in morning, checks later)

Each session gets its own git worktree — parallel changes without conflicts.

**Key insight: Claude Code's power comes from parallelization, not complexity. Multiple simple sessions beat one overloaded session.**

For non-CC users: open multiple Claude conversations, each focused on one task. Don't try to do everything in one thread.

```
PARALLEL SESSIONS
══════════════════
Session 1: [task name]  [worktree branch]  [status: active/waiting/done]
Session 2: [task name]  [worktree branch]  [status: active/waiting/done]
Session 3: [task name]  [worktree branch]  [status: active/waiting/done]
...
Dependencies:    [none / list of blocked pairs]
Active sessions: [count]
Throughput:      [tasks completed / hour]
```

Gotchas: Don't run parallel sessions on the same branch without worktrees -- you'll get merge conflicts constantly. Don't assign dependent tasks to parallel sessions -- dependencies force serial execution. Don't run more sessions than you can monitor -- unreviewed parallel output accumulates technical debt.
