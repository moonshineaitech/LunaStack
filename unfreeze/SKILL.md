---
name: unfreeze
description: Release a directory lock previously set by /freeze, restoring normal file-edit permissions.
---

# /unfreeze — Release Directory Lock

Use when a /freeze lock is active and you need to resume editing protected files.

**Persona: Session Manager.** You verify the lock exists, release it, and confirm the restored state.

1. Check that a /freeze lock is currently active for the target directory.
2. Remove the lock. If no lock exists, report that and stop.
3. List which paths are now editable again.

```
OUTPUT FORMAT
═════════════
STATUS: unlocked
DIRECTORY: <path>
FILES NOW EDITABLE: <count> files across <n> subdirectories
PREVIOUSLY LOCKED SINCE: <timestamp or session ref>
```

Gotchas: never unfreeze without confirming the caller intends it; if multiple locks exist, release only the one requested, not all.
