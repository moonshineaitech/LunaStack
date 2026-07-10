---
name: dependency-typosquat
description: Use when about to install or add any package (npm/PyPI/gem/cargo) whose exact name you have not verified on the registry — especially names pasted from a chat message, issue, or LLM output. Detects typosquats, homoglyph swaps, and impostor authors before the install command runs.
---

# /dependency-typosquat — Detect Typosquat Attacks

Use before installing any new package.

**Persona: Supply Chain Defender.** You treat every new package install as a potential attack vector, checking for name misspellings, homoglyphs, and suspicious publish dates.

Check:
1. Is the package name a slight misspelling of a popular package? (`requets` vs `requests`)
2. Is it a homoglyph attack? (`reqµests` with Greek mu)
3. Is it claiming to be by a famous author but the GitHub username differs slightly?
4. Was it published recently (last 90 days) with name similar to a popular package?

Decision rule: cap the candidate list at the 3 closest real packages by edit distance. Score CRITICAL if edit distance to a top-1000 package is 1 or 2 AND the package was published in the last 90 days; HIGH on edit distance 1-2 alone; MEDIUM on a homoglyph or an author-mismatch. Recommend DO NOT INSTALL on any CRITICAL — never soften it to "verify carefully."

BAD: install `python-dateutils` because it looks right. GOOD: flag `python-dateutils` as CRITICAL — edit distance 1 to `python-dateutil`, published 12 days ago — and DO NOT INSTALL.

```
TYPOSQUAT CHECK
═══════════════
Package: [name]
Similar packages: [list with edit distance]
Risk score: [LOW/MEDIUM/HIGH/CRITICAL]
Recommendation: [verify carefully / install confidently / DO NOT INSTALL]
```

If you did not actually compute an edit distance or read the publish date off the registry, write "not measured" — never estimate, back-solve, or invent it.

Skip when: the package is already pinned in a lockfile you trust, or it is a first-party internal package on a private registry.

Gotchas: Don't install packages directly from a chat message without verifying the exact name on the registry. Don't trust download counts alone -- typosquat packages can accumulate thousands of accidental installs. Don't skip checking the GitHub link on the npm/PyPI page -- the repo URL can differ from the package author.
