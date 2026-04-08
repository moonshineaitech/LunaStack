---
name: investigate-frozen
description: Use when investigating a bug. Automatically /freezes to the relevant module so the investigation doesn't sprawl.
---

# /investigate-frozen — Debug With Auto-Freeze

Use when investigating a bug. Automatically /freezes to the relevant module so the investigation doesn't sprawl.

Pattern:
1. User describes bug
2. Claude identifies affected module
3. Auto-/freeze to that module
4. Investigate and fix WITHIN the freeze
5. /unfreeze when done

Prevents the "I'll just refactor this while I'm here" failure mode that turns 10-line bug fixes into 500-line PRs.

```
INVESTIGATION (FROZEN)
══════════════════════
Bug: [description]
Frozen to: [module/directory]
Files in scope: [count]

Root cause: [file:line] — [explanation]
Fix: [description of change]
Lines changed: [count]
Scope creep attempts: [count blocked]

Status: [investigating / fixed / unfrozen]
```

Gotchas: Don't freeze to the wrong module -- spend 2 minutes identifying the right boundary before locking in. Don't expand the freeze mid-investigation to "just fix one more thing" -- that's the exact failure mode this prevents. Don't forget to /unfreeze when the bug is fixed -- a stale freeze blocks the next task.
