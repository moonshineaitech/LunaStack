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
