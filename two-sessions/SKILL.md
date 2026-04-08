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

```
TWO-SESSION WORKFLOW
═════════════════════
Session 1 — Planning:
  Questions asked: [count]
  Spec saved to:   [file path]
  Status:          [drafting / approved]
Session 2 — Execution:
  Spec loaded:     [file path]
  Implementation:  [in progress / complete]
  Context:         [clean — no planning history]
Session 3 — Review (optional):
  PR reviewed:     [yes/no]
  Issues found:    [count]
```

Gotchas: Don't let the execution session re-discuss decisions already made in the planning session -- it should execute the spec, not re-evaluate it. Don't skip saving the spec to a file between sessions -- verbal handoff loses detail during context transition. Don't use two-sessions for tasks under 30 minutes -- the session overhead exceeds the quality benefit.
