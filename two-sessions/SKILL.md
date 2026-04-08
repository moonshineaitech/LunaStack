---
name: two-sessions
description: Spec Session + Execution Session.
---

# /two-sessions — Spec Session + Execution Session

Use for any feature that takes more than 30 minutes.

**Session 1: Planning.** Claude interviews you → writes spec → you approve. Save spec to file.
**Session 2: Execution.** Fresh context. Claude reads the spec file. Implements with clean focus.

Why: Session 1 accumulates discovery context (dead ends, alternatives considered, questions asked). Session 2 doesn't need any of that — it just needs the final spec. Clean context = better code.

Advanced: **Session 3: Review.** A third Claude reviews the PR from completely fresh context. It has no knowledge of the implementation shortcuts and will challenge every one of them.
