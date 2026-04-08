---
name: dependency-typosquat
description: Detect Typosquat Attacks.
---

# /dependency-typosquat — Detect Typosquat Attacks

Use before installing any new package.

Check:
1. Is the package name a slight misspelling of a popular package? (`requets` vs `requests`)
2. Is it a homoglyph attack? (`reqµests` with Greek mu)
3. Is it claiming to be by a famous author but the GitHub username differs slightly?
4. Was it published recently (last 90 days) with name similar to a popular package?

```
TYPOSQUAT CHECK
═══════════════
Package: [name]
Similar packages: [list with edit distance]
Risk score: [LOW/MEDIUM/HIGH/CRITICAL]
Recommendation: [verify carefully / install confidently / DO NOT INSTALL]
```
