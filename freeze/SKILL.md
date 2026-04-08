---
name: freeze
description: Use when debugging a specific module and you DON'T want Claude touching unrelated code.
---

# /freeze — Lock Edits to One Directory

Use when debugging a specific module and you DON'T want Claude touching unrelated code.

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
