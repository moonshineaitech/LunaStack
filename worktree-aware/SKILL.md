---
name: worktree-aware
description: Use when running parallel sessions across multiple worktrees.
---

# /worktree-aware — Work Safely in Git Worktrees

Use when running parallel sessions across multiple worktrees.

Prevents:
- Editing files in the wrong worktree
- Pushing from a worktree that doesn't track its branch correctly
- Rebasing while another session is mid-edit

```
WORKTREE SAFETY
═══════════════
Current worktree: [path]
Branch:           [branch-name]
Other active worktrees: [list — in case of merge conflicts]

Pre-flight checks:
  □ Confirm I'm in the right worktree
  □ Confirm branch matches expected work
  □ No untracked changes from previous session
  □ No other process editing same files
```
