---
name: worktree
description: Use when you have 2+ independent tasks that can run simultaneously. Sets up parallel git worktrees. See also /worktree-aware for safety checks when already in worktrees.
---

# /worktree — Parallel Git Worktrees

Use when you have 2+ independent tasks that can run simultaneously.

```bash
# Create isolated worktrees
git worktree add ../feature-auth -b feature/auth
git worktree add ../feature-search -b feature/search

# Run a Claude session in each
cd ../feature-auth && claude
cd ../feature-search && claude

# Each has its own branch, its own files, its own context
# No interference between sessions
```

Production teams run 4-5 parallel worktrees daily. Each session works on its own branch. Merge when ready.

Gotchas: Don't create worktrees for dependent tasks -- parallel only works when tasks are truly independent. Don't forget to clean up worktrees after merging -- stale worktrees accumulate and confuse future sessions. Don't share a worktree between multiple Claude sessions -- each session needs its own isolated worktree to prevent file conflicts.
