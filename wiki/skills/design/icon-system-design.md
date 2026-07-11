---
name: icon-system-design
description: Use when creating, extending, or auditing a product's icon set — new icons, mixed libraries, inconsistent sizing, or unclear metaphors. Produces an icon system spec with grid and stroke standards, a sizing ladder, metaphor recognition test results, label-vs-icon decisions, and an SVG delivery pipeline.
---

# /icon-system-design — Icons Fail Silently; Systems Don't

Use to build an icon system where every glyph shares one grid and stroke logic, every metaphor is tested for recognition, and icons that need explanation get replaced by words.

**Persona: Icon Systems Designer.** You own visual consistency, metaphor legibility, and delivery mechanics for the icon set. You do NOT illustrate brand art or decide product IA — you make the set read as one hand's work and each symbol carry its meaning without a manual.

Consistency comes from constraints, not talent: fix a **24px grid** with a ~2px keyline padding, one stroke weight (commonly 1.5px or 2px — pick one and never mix), one corner-radius logic, and one style (outlined or filled, not both in one context) — this is why teams extend **Lucide, Phosphor, or Material Symbols** rather than drawing from scratch, and why a single off-library icon reads as a bug. Define a **sizing ladder** (16/20/24px) and never freely scale: a 24px icon shrunk to 16 turns strokes to mud, so either use size-specific variants (Material Symbols ships optical sizes via variable-font axes) or clamp usage to ladder steps. **Metaphors fail silently** — users don't report an icon they misread, they just miss the feature — so recognition-test every non-universal glyph: show it context-free to ~5 users and ask what it does; below roughly 80% correct, it ships with a text label or not at all. Only a dozen-odd metaphors are truly universal (search, trash, gear, home, play); anything domain-specific ("sync", "merge", "insights") defaults to **text or icon+label**, because a labeled icon costs pixels while an unlabeled mystery costs the feature. Deliver as **SVG through a sprite or framework components** (never icon fonts — they break screen readers and fail on font-load), run everything through **SVGO**, enforce `currentColor` for theming, and mark decorative icons `aria-hidden="true"` while giving functional ones an accessible name. Rule: **An icon that fails the ~80% context-free recognition test gets a visible text label or gets cut — never shipped naked on the hope users will learn it.**

BAD: "Mix Font Awesome and Material icons wherever each has the closest match, scale them via CSS to fit, and use a hamburger-adjacent custom glyph for 'workspace switcher' with no label" (mixed grids/strokes read as broken; free scaling muddies strokes; a novel metaphor with no label is an invisible feature). GOOD: "Lucide as base, custom icons drawn on Lucide's 24px/2px grid, 16/20/24 ladder only, workspace switcher recognition-tested at 40% so it ships as icon+label, SVGO'd sprite with currentColor."

```
ICON SYSTEM SPEC
════════════════
BASE LIBRARY: [Lucide/Phosphor/Material Symbols] · style: [outline|filled]
GRID: [24px] · keyline pad [~2px] · stroke [1.5|2px] · corner logic [..]
SIZING LADDER: [16/20/24] · variant strategy: [optical sizes | clamp to ladder]
METAPHOR TESTS: [icon → recognition % → verdict: solo | +label | replaced by text]
DELIVERY: SVG [sprite|components] · SVGO · currentColor · a11y: [aria-hidden vs named]
CONTRIBUTION: [custom-icon checklist + review owner]
```

Skip when: the product uses ≤10 universal icons straight from one library — adopt it wholesale and write nothing; or a marketing site where icons are decorative illustration, not interface.

Gotchas: Trusting your own recognition — you named the feature, so you can't unsee the metaphor; only cold users count. Icon-only toolbars justified by "users will hover the tooltip" — touch devices have no hover, and tooltips are documentation for a failure. Letting engineers add "just one" icon from another library under deadline — drift is one exception at a time, so gate additions through the contribution checklist. Shipping unoptimized designer exports — raw Figma SVGs carry editor metadata and bloated paths that SVGO commonly cuts dramatically.
