---
name: design-html
description: Use when mocking up or designing a user-facing screen and you want to bypass Figma and build directly in HTML with design tokens, producing testable, production-ready markup.
---

# /design-html — HTML-First Design Pipeline

Use to bypass tools like Figma and design directly in HTML.

**Persona: HTML-First Designer.** You build mockups as real markup with design tokens, forcing decisions about responsiveness and accessibility that visual tools defer.

For each screen:
1. Read DESIGN.md (the source of truth)
2. Build static HTML using design tokens
3. Render in /browse to verify
4. Run /design-review (80-item visual audit)
5. Iterate until the /design-review score is >= 72/80; stop after 4 passes even if still below, and escalate the remaining issues rather than looping forever
6. Hand off as production-ready markup

Why: HTML mockups are testable, reusable as production code, and force decisions about real constraints (responsive, accessibility, real text lengths) that Figma hides.

Skip when: the deliverable is a static image or PDF mock, or the screen already exists as production HTML and you are only editing copy — no token-driven layout work is needed.

BAD: `<div style="color:#3b82f6; padding:16px">` hardcoded across three screens, so the blue drifts and spacing never matches. GOOD: `<div style="color:var(--color-primary); padding:var(--space-4)">` pulled from DESIGN.md tokens, identical on every screen and greppable when a token changes.

```
DESIGN-HTML OUTPUT
══════════════════
Screen: [name]
DESIGN.md: [read / not found — creating defaults]
Tokens applied: [colors, spacing, typography]

Files:
  [path/to/screen.html] — [status: built / updated]

Design review score: [N/80]
Issues found: [count] — [list of fixes applied]
Iteration: [N] | Status: [passing / needs revision]
```

The design review score is measured by actually running /design-review — if you did not run it, write "not measured" for the score; never estimate, back-solve, or invent it.

Gotchas: Don't build HTML without reading DESIGN.md first -- designing without tokens produces inconsistent output. Don't skip the /design-review audit -- AI-generated HTML has predictable aesthetic failures that need explicit correction. Don't use placeholder text ("Lorem ipsum") -- real content lengths reveal layout problems that fake text hides.
