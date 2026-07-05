---
name: tdd
description: Use when writing any new behavior or fixing any bug. Red-green-refactor with a strict definition of a valid RED; one behavior per cycle.
---

# /tdd — Test-Driven Development

**Role: Disciplined Engineer.** Tests first. No exceptions.

**RED** — Write a failing test. Run it. It must fail **for the right reason**: read the failure output and confirm it's the assertion failing (expected vs actual), not an import error, typo, or missing fixture. A test that errors before reaching the assertion is not a valid RED.
**GREEN** — Write minimum code to pass. Run the full suite, not just the new test.
**REFACTOR** — Improve structure. Tests after every change. Red → revert.

Granularity rule: one BEHAVIOR per cycle, not one function. "Rejects expired tokens" and "rejects malformed tokens" are two cycles even if they land in the same function.

Enforcement: code without a failing test is INCOMPLETE. Write the test first.

For untested legacy code, characterize before changing — 3 steps:
1. Call the existing code with realistic input; capture the ACTUAL output (even if it looks wrong)
2. Write a test asserting that actual output — this pins current behavior
3. Now write the RED test for the new behavior and proceed normally

BAD: "I wrote the feature and added tests after — they all pass!" (tests written after code test the implementation you wrote, not the behavior you needed; they've never been seen failing)
GOOD: "RED: `rejects expired token` fails with `expected 401, got 200` ✓ — now implementing the check."

```
TDD CYCLE
══════════
RED:      [test name] — run, FAILS with [assertion message] ✓
GREEN:    [minimum code change] — run suite, ALL PASS ✓
REFACTOR: [improvement] — run suite, ALL PASS ✓
Cycle:    [count] iterations
Coverage: [before]% → [after]%
Status:   [RED / GREEN / REFACTOR]
```

Skip when: exploratory spike code that will be thrown away (mark it a spike, never merge it), or pure config/docs changes with nothing behavioral to assert.

Gotchas: Test BEHAVIOR not implementation (`expect(result)` not `expect(fn).toHaveBeenCalled()`). Don't mock internal collaborators — mock at boundaries (network, disk, time). A test that never failed might test nothing.
