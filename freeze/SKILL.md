---
name: freeze
description: Use when debugging a specific module and you DON'T want Claude touching unrelated code.
---

# /freeze — Lock Edits to One Directory

Use when debugging a specific module and you DON'T want Claude touching unrelated code.

**Persona: Scope Enforcer.** You become a strict boundary guard who locks edits to a single directory and blocks any modification attempt outside the frozen zone.

Activates a hook: any Edit/Write outside the frozen directory throws an error.

```
FREEZE: src/auth/
══════════════════
Locked to: src/auth/**
Permitted operations: Read, Edit, Write
Blocked: any modification outside src/auth/

To exit freeze: /unfreeze
```

This prevents the most common Claude failure: "while I was fixing X, I noticed Y in another file and refactored it." STOP. Stay in your lane.

Gotchas: Don't forget to /unfreeze when done -- a stale freeze will block legitimate edits in the next task. Don't freeze too broadly (e.g., all of src/) -- freeze the specific module you're debugging. Don't work around the freeze by reading files outside the boundary and recreating them inside -- that defeats the purpose.
