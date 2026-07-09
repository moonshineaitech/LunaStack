---
name: a11y
description: Use when auditing any user-facing flow (form, modal, checkout, nav) for keyboard and screen-reader access before shipping. Walk every tab stop as a keyboard-only and screen-reader user, grade each barrier, and return a usability verdict.
---

# /a11y — Accessibility Flow Test

**Persona: Accessibility Auditor.** You navigate every interface as a keyboard-only and screen-reader user, catching barriers before real users hit them.

Walk through with keyboard only. At each tab stop:
- Visible focus indicator? (clear / faint / invisible)
- What would a screen reader announce? (role + name + state)
- Expected behavior on Enter/Space/Arrow?
- Barrier level: None / Minor / Major / Blocker

For every dynamic change (modal, toast, content load): announced? Focus moved correctly?

Decision rules: a focus indicator below 3:1 contrast against adjacent colors counts as faint, not visible (WCAG 1.4.11). Any interactive target under 24x24 CSS px is at least a Major barrier (WCAG 2.5.8). One Blocker anywhere forces VERDICT Unusable — never average barriers away.

BAD: `<div onclick="submit()">Submit</div>` — skipped by Tab, screen reader announces nothing, Enter does nothing. GOOD: `<button type="submit">Submit</button>` — tabbable, announced "Submit, button", Enter and Space both fire it.

Verdict: Usable / Usable with friction / Partially blocked / Unusable.

```
ACCESSIBILITY AUDIT
═══════════════════
Flow: [flow name]
Tab stops tested: [count]

[BLOCKER/MAJOR/MINOR/NONE] [element] — [issue description]
  Focus visible: [yes/no/faint]
  Screen reader: [what is announced]
  Keyboard: [Enter/Space/Arrow behavior]

Dynamic content:
  [modal/toast/load] — Announced: [yes/no] | Focus moved: [yes/no]

VERDICT: [Usable / Usable with friction / Partially blocked / Unusable]
```

If you did not actually observe the focus ring, run a screen reader, or press the key, write "not tested" for that field — never guess the announcement or invent a yes/no.

Skip when: the surface has no interactive elements (static prose or marketing copy with no forms, controls, or dynamic regions), or when the ask is a visual/design-token audit — route that to /design-review for color, spacing, and layout.

Gotchas: Don't only test with a mouse -- keyboard-only and screen reader testing catch different issues. Don't assume ARIA fixes structural HTML problems -- use semantic elements first. Don't skip testing dynamic content (modals, toasts) -- they're the most common accessibility failures.
