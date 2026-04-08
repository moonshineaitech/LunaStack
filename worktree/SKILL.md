---
name: worktree
description: Use when you have 2+ independent tasks that can run simultaneously.
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
