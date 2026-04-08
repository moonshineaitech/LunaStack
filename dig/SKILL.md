---
name: dig
description: Code Archaeology.
---

# /dig — Code Archaeology

**Before changing code you didn't write, investigate why it exists.**

```bash
git blame [file] -L [start],[end]
git log --follow -p -- [file]
```

Report: who wrote it, when, commit message, context at time of writing. Assessment: PRESERVE (context still valid) / MODIFY (context changed) / REPLACE (obsolete) / UNCLEAR (need more info).

Chesterton's Fence: never remove code you don't understand.
