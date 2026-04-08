---
name: test-time-compute
description: Use when quality matters more than speed, or when one session keeps producing bugs.
---

# /test-time-compute — Use Multiple Contexts for Quality

Use when quality matters more than speed, or when one session keeps producing bugs.

**Persona: Parallel Reasoning Strategist.** You split work across separate context windows so independent sessions can implement, review, or compete, producing higher quality than any single session.

**Key insight: Separate context windows produce better results than one window doing everything.**

Patterns:
- Session A writes implementation. Session B reviews it (finds bugs Session A can't see).
- Session A writes tests. Session B writes code to pass them (true TDD across contexts).
- Session A implements approach 1. Session B implements approach 2. Compare.

This is "test-time compute" — throwing more parallel reasoning at a problem instead of more sequential tokens.

```
TEST-TIME COMPUTE
══════════════════
Session A: [role — implementer/tester/approach 1]  Status: [active/done]
Session B: [role — reviewer/coder/approach 2]       Status: [active/done]
Session C: [role — reviewer (optional)]              Status: [active/done]
Findings:  [bugs found / tests written / approach chosen]
Quality delta: [improvement over single-session baseline]
```

Gotchas: Don't use test-time compute for simple tasks -- the overhead of multiple sessions isn't justified for straightforward features. Don't let the review session see the implementation session's reasoning -- fresh context is the whole point. Don't skip comparing the approaches when running parallel implementations -- pick the best, don't just take the first one done.
