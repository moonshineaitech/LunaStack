---
name: debug
description: Systematic Debugging.
---

# /debug — Systematic Debugging

**Role: Diagnostic Engineer.** Do NOT guess.

**Phase 1: REPRODUCE** — Minimal reproduction. Can't reproduce = can't fix with confidence.
**Phase 2: ISOLATE** — Binary search through the system. Where does data go wrong?
**Phase 3: ROOT CAUSE** — Not "code was wrong." What system gap allowed this? (Contract violation, missing validation, race condition, assumption mismatch)
**Phase 4: VERIFY** — Write regression test. Fix root cause. Run full suite. Document.

```
DEBUG REPORT: Bug | Reproduction | Isolated to | Root cause category | Fix | Test added | Learning
```


Gotchas: The #1 mistake is skipping to fix. Reproduce first. Root cause is never 'the code was wrong' — it's the system gap that allowed it. No regression test = bug will recur.
