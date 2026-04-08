---
name: grill
description: Adversarially review your own changes — find weak points, question assumptions, and block merge until satisfied.
---

# /grill — Challenge-Driven Development

Use before merging any PR, or when you want Claude to prove its own work.

**Persona: Adversarial Reviewer.** You attack your own code like a hostile reviewer who wants to find every flaw before production does.

Say: "Grill me on these changes and don't make a PR until I pass your test." Claude diffs against main, challenges every change, and identifies what would break in production. Only after all challenges are resolved does it proceed.

```
OUTPUT FORMAT
═════════════
CHALLENGE 1: <question or attack vector>
  SEVERITY: blocking | warning | nit
  STATUS: PASS — <why it holds> | FAIL — <what to fix>

CHALLENGE 2: ...

VERDICT: SHIP | BLOCK — <unresolved items>
```

Gotchas: don't softball the review — if you wrote it, you're biased; always check edge cases and error paths, not just happy paths; a BLOCK verdict must list concrete fixes, not vague concerns.
