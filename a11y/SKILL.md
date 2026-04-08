---
name: a11y
description: Accessibility Flow Test.
---

# /a11y — Accessibility Flow Test

Walk through with keyboard only. At each tab stop:
- Visible focus indicator? (clear / faint / invisible)
- What would a screen reader announce? (role + name + state)
- Expected behavior on Enter/Space/Arrow?
- Barrier level: None / Minor / Major / Blocker

For every dynamic change (modal, toast, content load): announced? Focus moved correctly?

Verdict: Usable / Usable with friction / Partially blocked / Unusable.

Gotchas: Don't only test with a mouse -- keyboard-only and screen reader testing catch different issues. Don't assume ARIA fixes structural HTML problems -- use semantic elements first. Don't skip testing dynamic content (modals, toasts) -- they're the most common accessibility failures.
