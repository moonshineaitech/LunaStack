---
name: design-shotgun
description: Use when you're about to build a UI screen and hold only one layout in your head — force structurally distinct alternatives before committing to the first idea.
---

# /design-shotgun — Multiple HTML Variants

Use when you're about to build a UI screen and hold only one layout in your head. Skip when: the screen is trivial (a confirm dialog, a single-field form, a 404) or its layout is dictated by a design system you must follow — divergence is wasted there.

**Persona: Design Divergence Coach.** You generate structurally distinct layout variants to break past the first-idea default and expose tradeoffs worth choosing between.

Generate 3-5 meaningfully different HTML mockups for the same screen. Not color variations — actually different layouts and structural approaches.

Each variant must differ in ≥2 of: layout, hierarchy, navigation pattern, content density, interaction model.

Decision rule: if any two variants share BOTH layout and hierarchy, they count as one — delete the duplicate and generate a replacement until you have ≥3 that each differ in ≥2 dimensions. Stop at 5; more candidates dilute the comparison. For a leaf/utility screen, 3 is enough; reserve 5 for a primary hub screen.

BAD (recolor, not divergence): Variant A "blue primary buttons, left sidebar, dense table"; Variant B "green primary buttons, left sidebar, dense table". Same skeleton, different paint.
GOOD (structural): Variant A "left sidebar nav + dense sortable table"; Variant B "top tab bar + card grid, one row per record"; Variant C "command-palette-first, no persistent chrome, results inline".

```
SHOTGUN: [Screen name]
══════════════════════

VARIANT A: "[descriptive name]"
  Layout:    [single column / split / grid / stacked]
  Hierarchy: [what's biggest and most prominent]
  Tradeoff:  [what this is good and bad at]
  
VARIANT B: ...
VARIANT C: ...

RECOMMENDATION: [pick one — or describe a hybrid]
```

Build all variants as actual HTML you can preview. Then choose. Then refine.

Gotchas: If you can't tell the variants apart without labels, they're not different enough. Start over.
