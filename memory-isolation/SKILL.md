---
name: memory-isolation
description: Use when a multi-project Claude setup risks cross-contamination.
---

# /memory-isolation — Per-Project Memory Boundaries

Use when a multi-project Claude setup risks cross-contamination.

Lessons from OpenClaw's persistent memory: data from Project A should NEVER leak into Project B. Especially for client work, financial data, or confidential information.

```
MEMORY ISOLATION
════════════════

PROJECT: [name]
SCOPE:
  ✓ Conversations within this project's worktree
  ✓ Files in project directory
  ✓ Project-specific CLAUDE.md and lessons.md
  ✗ NEVER read from other projects
  ✗ NEVER write to global memory

VERIFICATION
  □ /memory-leak-check before sensitive work
  □ Confirm no cross-references in memory
  □ Confirm session is bounded to project worktree
```

Pattern: each project has its own `.lunastack/` directory with isolated memory. The compound learning loop runs within the project, not across.
