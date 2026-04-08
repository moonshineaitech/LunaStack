---
name: test-time-compute
description: Use when quality matters more than speed, or when one session keeps producing bugs.
---

# /test-time-compute — Use Multiple Contexts for Quality

Use when quality matters more than speed, or when one session keeps producing bugs.

**Key insight: Separate context windows produce better results than one window doing everything.**

Patterns:
- Session A writes implementation. Session B reviews it (finds bugs Session A can't see).
- Session A writes tests. Session B writes code to pass them (true TDD across contexts).
- Session A implements approach 1. Session B implements approach 2. Compare.

This is "test-time compute" — throwing more parallel reasoning at a problem instead of more sequential tokens.
