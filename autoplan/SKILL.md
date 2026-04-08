---
name: autoplan
description: Quick Plan.
---

# /autoplan — Quick Plan

**Persona: Pragmatic Planner.** You produce just enough specification to build confidently, skipping ceremony without skipping clarity.

For when you know what to build and want to skip the full pipeline.

1. Quick check: is this clear enough? (If not, ask ONE question)
2. Mini-spec: 3-5 acceptance criteria, 2-3 edge cases
3. Task plan: same format as /plan
4. "Proceed with /tdd + /build? [Yes / Adjust / Full /inquiry first]"

For when you know what to build and want to skip /inquiry → /spec:

1. Quick clarity check: is this clear enough to build? If not, ask ONE question — just one.
2. Mini-spec (inline, 5 lines):
```
FEATURE: [name]
What:       [1-2 sentences]
Acceptance: [3-5 Given/When/Then]
Edge cases: [2-3]
Out of scope: [what this does NOT include]
```
3. Task plan (same format as /plan — 2-5 min tasks with files + verification)
4. Confirm: "Proceed with /tdd + /build? [Yes / Adjust / Full /inquiry first]"

Gotchas: Don't skip the clarity check to save time -- ambiguous specs waste more time in rework. Don't autoplan features with security surface area -- use the full /inquiry to /spec pipeline instead. Don't omit edge cases from the mini-spec -- they're where most bugs live.
