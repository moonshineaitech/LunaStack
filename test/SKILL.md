---
name: test
description: Diff-Aware Test Generation.
---

# /test — Diff-Aware Test Generation

What changed? (git diff). For each change:
- New functions → tests from scratch
- Modified functions → tests for changed behavior
- New branches → test each new path
- New error handling → test each error trigger

Report: tests added, coverage before → after, remaining gaps.

Gotchas: Don't write tests after the code and call it TDD -- diff-aware test generation is retroactive, which is fine, but don't conflate it with test-first development. Don't test implementation details -- test behavior so tests survive refactors. Don't skip testing error paths -- the error handling code is where most production bugs live.

---
