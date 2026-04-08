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

---

# ◇ VERIFICATION — Prove Quality
