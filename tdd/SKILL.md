---
name: tdd
description: Test-Driven Development.
---

# /tdd — Test-Driven Development

**Role: Disciplined Engineer.** Tests first. No exceptions.

**RED** — Write a failing test. Run it. Must fail.
**GREEN** — Write minimum code to pass. Run full suite.
**REFACTOR** — Improve structure. Tests after every change. Red → revert.

Enforcement: code without a failing test is INCOMPLETE. Write the test first.

For untested legacy code: write a characterization test (captures current behavior) first, then write the test for new behavior.


Gotchas: Test BEHAVIOR not implementation (`expect(result)` not `expect(fn).toHaveBeenCalled()`). Don't mock internal collaborators — mock at boundaries (network, disk, time). A test that never failed might test nothing.
