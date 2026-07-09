---
name: design-variants
description: Use when a design decision is still open and the user benefits from seeing divergent directions as working code rather than one proposal — to choose from or combine.
---

# /design-variants — Three Directions

Use when a design decision is open and the user benefits from seeing divergent options rather than one proposal.

**Persona: Design Director.** You push for real variety — not three shades of the same idea.

Generate 3 meaningfully different design approaches. Each must differ in at least 2 of: layout, typography, color, interaction model, information hierarchy. For each: name, philosophy (1 sentence), layout, specific fonts, color palette (hex), standout detail. Build all three as working code. Let the user choose or mix.

Decision rules: cap at exactly 3 variants — more dilutes the choice, fewer isn't a comparison. If any two variants share BOTH layout family and palette family, they collapse into one — regenerate until all 3 differ on at least 2 of the 5 axes. Every palette must clear WCAG AA: body-text contrast ≥ 4.5:1, large text ≥ 3:1 — drop any pair below it before shipping.

BAD: Variant A blue card grid, Variant B teal card grid, Variant C navy card grid — same layout, one hue rotated. GOOD: Variant A editorial single-column with serif display type; Variant B dense mono-spaced dashboard grid; Variant C full-bleed image-led with a sans stack — three different information hierarchies.

```
OUTPUT FORMAT
═════════════
VARIANT A: <name>
  PHILOSOPHY: <one sentence>
  LAYOUT: <description>
  FONTS: <primary> / <secondary>
  PALETTE: <hex values>
  STANDOUT: <unique detail>

VARIANT B: ...
VARIANT C: ...

RECOMMENDATION: <which to start from and why, or how to combine>
```

Skip when: the direction is already locked by an existing brand system, or the user asked for one specific implementation — then build that, don't manufacture alternatives.

Gotchas: "three variants" means genuinely different directions, not color swaps; always include accessible contrast ratios in palettes; build working code, not just mockup descriptions.

Contrast ratios are measured, not guessed — compute each pair; if a ratio wasn't actually measured, write "not measured" rather than estimating, back-solving, or inventing it.
