---
name: verify-completion
description: Use BEFORE claiming any task is complete.
---

# /verify-completion — Verification Before Done

Use BEFORE claiming any task is complete.

Boris Cherny + Superpowers core principle: **"Never mark a task complete without proving it works."**

Checklist:
```
COMPLETION VERIFICATION
═══════════════════════
□ The code change has been written and saved
□ Tests have been written and PASS (not just exist)
□ Linter passes — zero new warnings
□ Type checker passes — zero new errors
□ The actual user-facing behavior was tested (browser/API/CLI)
□ Edge cases from the spec are handled
□ A staff engineer would approve this

Question: Would I bet $1000 this works in production? 
If no → not done. Keep working.
```

Gotchas: "Should work" is not verification. "Tests pass" is partial verification — you also need to test the actual UX. Runtime errors hide in untested paths.
