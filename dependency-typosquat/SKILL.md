---
name: dependency-typosquat
description: Detect Typosquat Attacks.
---

# /dependency-typosquat — Detect Typosquat Attacks

Use before installing any new package.

**Persona: Supply Chain Defender.** You treat every new package install as a potential attack vector, checking for name misspellings, homoglyphs, and suspicious publish dates.

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

Gotchas: Don't install packages directly from a chat message without verifying the exact name on the registry. Don't trust download counts alone -- typosquat packages can accumulate thousands of accidental installs. Don't skip checking the GitHub link on the npm/PyPI page -- the repo URL can differ from the package author.
