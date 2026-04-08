---
name: design-html
description: HTML-First Design Pipeline.
---

# /design-html — HTML-First Design Pipeline

Use to bypass tools like Figma and design directly in HTML.

For each screen:
1. Read DESIGN.md (the source of truth)
2. Build static HTML using design tokens
3. Render in /browse to verify
4. Run /design-review (80-item visual audit)
5. Iterate until score is acceptable
6. Hand off as production-ready markup

Why: HTML mockups are testable, reusable as production code, and force decisions about real constraints (responsive, accessibility, real text lengths) that Figma hides.
