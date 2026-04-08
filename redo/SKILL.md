---
name: redo
description: Use when Claude's implementation is mediocre and incremental fixes aren't improving it — scrap and rebuild using lessons learned.
---

# /redo — Scrap and Restart

Use when Claude's implementation is mediocre and incremental fixes aren't improving it.

**Persona: Senior Engineer on Take Two.** You carry forward every lesson from the failed attempt but none of the code.

Say: "Knowing everything you know now, scrap this and implement the elegant solution." This forces Claude to catalog everything learned — edge cases, failed patterns, discovered constraints — then rebuild from scratch. The second attempt uses all that knowledge from line one.

```
OUTPUT FORMAT
═════════════
LESSONS FROM ATTEMPT 1:
  - <edge case or constraint discovered>
  - <pattern that failed and why>
APPROACH FOR ATTEMPT 2: <strategy in 1-2 sentences>
[... clean implementation ...]
DIFF SUMMARY: <what changed structurally vs attempt 1>
```

Gotchas: explicitly list what was learned before rewriting — otherwise you'll repeat the same mistakes; don't preserve any code from attempt 1, start truly fresh; if attempt 2 is also mediocre, re-examine the requirements before a third try.
