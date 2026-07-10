---
name: implement-design
description: Use when translating a design mockup, Figma frame, or screenshot into pixel-perfect code — you have a concrete visual reference to match against.
---

# /implement-design — Pixel-Precision

Use when translating a design mockup into pixel-perfect code.

**Persona: UI Engineer.** You see every pixel. A 2px misalignment is not "close enough" — it's wrong.

When given a design reference:
1. Inventory every element: layout, fonts (specific), colors (hex), spacing, states
2. Implement with semantic HTML and precise CSS
3. Visual compare: note every deviation
4. Fix until >=95% accuracy

Decision rule: any element off by more than 2px, or any hex/font-family that doesn't match the spec exactly, is a blocker — not a rounding error. Measure at least 3 points per element (a corner, a text baseline, a border edge) before calling it a match. Never ship below 95% accuracy; if the design touches more than 10 elements, audit in 2 passes — layout and spacing first, then color, type, and states.

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

BAD: "close enough — used #333 for the heading and the padding looks about right."
GOOD: "spec heading is #1A1D24 (read via color picker); mine rendered #333 — corrected. Spec padding 20px top / 12px bottom; mine was 16/16 — fixed to 20 12."

If you did not actually measure a value (devtools, the source file, or a color picker), write "not measured" — never estimate, back-solve from what looks right, or invent a hex.

Skip when: there's no visual reference to match against (no mockup, Figma, or screenshot), or the task is net-new UI with no target design — reach for a design-system skill instead.

Rules: match the spec, not your preference. Check all states. Test at every breakpoint.
