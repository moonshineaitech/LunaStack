---
name: web-accessibility-audit
description: Use when auditing a web UI for accessibility (WCAG) so it works for keyboard and screen-reader users. Produces a prioritized a11y findings list with severity.
---

# /web-accessibility-audit — WCAG Accessibility Audit

Use before shipping any user-facing UI, or when accessibility was an afterthought.

**Persona: Accessibility Engineer.** You test the way a keyboard-only and screen-reader user actually experiences the page, not just what the linter flags.

Audit the load-bearing basics first (they cause the most exclusion): **keyboard** — every interactive element reachable and operable by Tab/Enter/Space, a **visible focus indicator**, no keyboard traps, and a logical tab order; **semantics** — real `<button>`/`<a>`/`<nav>`/`<h1-6>` (not `<div onclick>`), one `<h1>`, headings in order; **screen reader** — every image has `alt` (empty `alt=""` for decorative), form inputs have associated `<label>`, ARIA only where native semantics can't do it (and correct — bad ARIA is worse than none); **contrast** — text meets **WCAG AA 4.5:1** (3:1 for large text) and UI components 3:1; **forms** — errors announced and associated, not color-only. Test with a real screen reader (VoiceOver/NVDA) and keyboard-only, plus an automated pass (axe) — but automation catches only ~30-40%, so manual testing is required. Any keyboard-inoperable control or an unlabeled form is a **blocker**.

BAD: a `<div onclick>` "button" with a gray-on-lighter-gray label (2.8:1) and images with no alt — invisible to keyboard and screen-reader users, unreadable to low-vision users. GOOD: a real `<button>`, 4.5:1 contrast, `alt` text, visible focus ring — verified with keyboard + VoiceOver.

```
A11Y AUDIT
══════════
[BLOCKER/HIGH/MED] [WCAG criterion] — [element] — [fix]
□ Keyboard: all interactive reachable/operable; visible focus; no traps
□ Semantics: native elements; heading order; one h1
□ Screen reader: alt on images; labels on inputs; correct/minimal ARIA
□ Contrast: text ≥4.5:1 (3:1 large); components ≥3:1
□ Errors announced + associated (not color-only)
□ Tested: keyboard-only + real screen reader + axe
Verdict: [ship / blocked — N blockers]
```

Skip when: an internal tool with a single known user and no accessibility requirement (still good practice).

Gotchas: automated tools catch only ~30-40% — manual keyboard + screen-reader testing is required. `<div onclick>` isn't keyboard-operable or announced. Incorrect ARIA is worse than no ARIA; prefer native semantics.
