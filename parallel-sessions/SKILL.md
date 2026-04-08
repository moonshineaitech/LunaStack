---
name: parallel-sessions
description: Use when you have multiple independent tasks, or when throughput matters more than depth.
---

# /parallel-sessions — Boris's Multi-Session Setup

Use when you have multiple independent tasks, or when throughput matters more than depth.

Boris runs 10-15 Claude sessions simultaneously:
- 5 in terminal (numbered tabs, OS notifications when input needed)
- 5-10 on claude.ai/code
- Some from mobile (starts tasks in morning, checks later)

Each session gets its own git worktree — parallel changes without conflicts.

**Key insight: Claude Code's power comes from parallelization, not complexity. Multiple simple sessions beat one overloaded session.**

For non-CC users: open multiple Claude conversations, each focused on one task. Don't try to do everything in one thread.
