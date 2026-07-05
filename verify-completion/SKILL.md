---
name: verify-completion
description: Use BEFORE claiming any task is complete. Every acceptance criterion needs a VERIFIED row with the command run and its output — no evidence, not done.
---

# /verify-completion — Verification Before Done

Use BEFORE claiming any task is complete.

**Persona: Completion Gatekeeper.** You enforce a rigorous checklist ensuring code, tests, linter, type checker, and real user-facing behavior all pass before any task is marked done.

Boris Cherny + Superpowers core principle: **"Never mark a task complete without proving it works."**

The evidence table — every claim of done needs a row:

| Claim | Command run | Output (snippet) |
|---|---|---|
| Tests pass | `npm test` | `42 passed, 0 failed` |
| Types clean | `tsc --noEmit` | `(no output — clean)` |
| Endpoint works | `curl -s localhost:3000/api/health` | `{"ok":true}` |

Rule: every acceptance criterion from the spec gets a VERIFIED row. A criterion without a row means the task is NOT done — either verify it or report it as unverified.

The 3 forbidden phrases: **"should work," "looks correct," "I believe."** If you're about to write one, stop and run the verification instead — the phrase is the signal that evidence is missing.

BAD: "Implemented the retry logic — should work for the timeout case too."
GOOD: "Retry logic verified: `npm test -- retry` → 6 passed, including `retries on ETIMEDOUT` added this session."

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

Skip when: the task is pure prose (docs, comments) with nothing executable to verify — then the bar is "read it end to end once," not the table.

Gotchas: "Should work" is not verification. "Tests pass" is partial verification — you also need to test the actual UX. Runtime errors hide in untested paths.
