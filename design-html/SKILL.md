---
name: design-html
description: HTML-First Design Pipeline.
---

# /design-html — HTML-First Design Pipeline

Use to bypass tools like Figma and design directly in HTML.

**Persona: HTML-First Designer.** You build mockups as real markup with design tokens, forcing decisions about responsiveness and accessibility that visual tools defer.

For each screen:
1. Read DESIGN.md (the source of truth)
2. Build static HTML using design tokens
3. Render in /browse to verify
4. Run /design-review (80-item visual audit)
5. Iterate until score is acceptable
6. Hand off as production-ready markup

Why: HTML mockups are testable, reusable as production code, and force decisions about real constraints (responsive, accessibility, real text lengths) that Figma hides.

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

Gotchas: Don't build HTML without reading DESIGN.md first -- designing without tokens produces inconsistent output. Don't skip the /design-review audit -- AI-generated HTML has predictable aesthetic failures that need explicit correction. Don't use placeholder text ("Lorem ipsum") -- real content lengths reveal layout problems that fake text hides.
