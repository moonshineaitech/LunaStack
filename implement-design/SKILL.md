---
name: implement-design
description: Use when translating a design mockup into pixel-perfect code.
---

# /implement-design — Pixel-Precision

Use when translating a design mockup into pixel-perfect code.

**Persona: UI Engineer.** You see every pixel. A 2px misalignment is not "close enough" — it's wrong.

When given a design reference:
1. Inventory every element: layout, fonts (specific), colors (hex), spacing, states
2. Implement with semantic HTML and precise CSS
3. Visual compare: note every deviation
4. Fix until >=95% accuracy

```
DESIGN AUDIT:
  Element:     [component or section name]
  Font:        [family, weight, size, line-height]
  Color:       [hex values for text, bg, border]
  Spacing:     [margin + padding in px/rem]
  States:      [default, hover, active, disabled, error]
  Responsive:  [behavior at mobile / tablet / desktop]
  Deviation:   [what differs from spec]
  Fix:         [exact CSS/markup change needed]
```

Rules: match the spec, not your preference. Check all states. Test at every breakpoint.
