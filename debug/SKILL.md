---
name: debug
description: Use when a bug resists the first fix attempt, or before touching code whose failure you don't yet understand. Reproduce, isolate by binary search, fix the root cause, prove it with a regression test.
---

# /debug — Systematic Debugging

**Role: Diagnostic Engineer.** Do NOT guess.

**Phase 1: REPRODUCE** — Minimal reproduction. Can't reproduce = can't fix with confidence. Timebox: if 15 minutes of honest effort can't reproduce it, report what you tried and what extra information would unlock it — don't fix blind.

**Phase 2: ISOLATE** — Binary search the data path: pick the midpoint between last-known-good state and observed-bad output, instrument it (log/assert/inspect), check whether the data is already wrong there, then halve again toward the fault. 3-4 probes locate most bugs; if you've probed 6+ points without narrowing, your model of the data path is wrong — redraw it before probing more.

**Phase 3: ROOT CAUSE** — Not "code was wrong." Name the system gap that allowed it:
- Contract violation — caller and callee disagree on the interface ("caller passes ms, callee expects seconds")
- Missing validation — bad input reached deep logic ("empty array hit the reducer")
- Race condition — ordering assumption without enforcement ("cache read before write completed")
- Assumption mismatch — environment differs from expectation ("works locally: local tz, prod is UTC")

**Phase 4: VERIFY** — Write the regression test FIRST, watch it fail on the broken code, then fix. Run the full suite, not just the new test.

**Stop rule: 2 failed fix attempts = your diagnosis is wrong.** Return to Phase 1 and re-reproduce — do not try a third variation of the same fix.

BAD: "The date parsing looks off, let me add a `.trim()` and see if it passes." (guess-and-check, no reproduction)
GOOD: "Reproduced with input `'2026-07-02 '` (trailing space). Probed the parser boundary: input is already padded at ingestion, so the gap is missing normalization at the API layer — fixing there, regression test uses the padded input."

```
DEBUG REPORT
════════════
Bug:            [one line]
Reproduction:   [exact input/steps]
Isolated to:    [file:line or boundary, + probe count]
Root cause:     [category from Phase 3 + one line]
Fix:            [what changed and why there]
Test added:     [test name — failed before fix, passes after]
Learning:       [feed to /self-improve if this class of bug could recur]
```

Skip when: the failure is a brand-new feature that never worked (that's missing spec, not a bug), or the fix is a one-character typo with an obvious failing test already pointing at it.

Gotchas: The #1 mistake is skipping to fix. Reproduce first. Root cause is never 'the code was wrong' — it's the system gap that allowed it. No regression test = bug will recur.
