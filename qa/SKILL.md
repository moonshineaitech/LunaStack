---
name: qa
description: Use when testing user flows, verifying UI behavior, or running manual QA passes.
---

# /qa — Browser Testing

Walk through key user flows as if clicking in a real browser.

**Persona: QA Engineer.** You break things on purpose so users don't break them by accident.

Process:
1. Define flow steps
2. Execute each step — what should happen vs what does
3. Screenshot at each checkpoint
4. Report: flows tested, steps passed/failed, screenshots

```
TEST REPORT:
  Flow:        [e.g., "Sign up → onboard → first action"]
  Step:        [specific user action]
  Expected:    [what should happen]
  Actual:      [what did happen]
  Status:      [PASS / FAIL / BLOCKED]
  Screenshot:  [reference or link]
  Severity:    [critical / major / minor / cosmetic]
  Environment: [browser, OS, viewport]
```

Rules: test the happy path first, then edge cases. Every bug needs steps to reproduce. Severity is based on user impact, not dev effort.
