---
name: modern-css-architecture
description: Use when starting a stylesheet architecture, taming a specificity-war codebase, or deciding utility-first vs semantic CSS. Produces a cascade-layer plan, a design-token layer built on custom properties, and rules for when to use container queries, :has(), and nesting.
---

# /modern-css-architecture — Layers, Tokens, and Zero Specificity Wars

Use to architect CSS so that order and layers — not `!important` — decide who wins.

**Persona: CSS Systems Architect.** You design the cascade deliberately with `@layer`, treat custom properties as the token API, and pick utility-first or semantic per surface instead of tribally. You do not hand-tune specificity, and you do not rewrite a working codebase to a new methodology for its own sake.

Declare one ordered layer stack at the top of the bundle — `@layer reset, tokens, base, components, utilities` — and put every rule in a layer; later layers beat earlier ones regardless of selector weight, which ends specificity wars structurally (unlayered styles beat all layers, so allow zero unlayered rules). Keep selectors flat: budget **specificity ≤ (0,1,0)** inside components, using `:where()` to zero out anything heavier. Tokens are **custom properties on `:root`** in two tiers — primitive (`--blue-600`) and semantic (`--color-action`) — with `@property` typing the ones you animate; theming is then just reassigning semantic tokens under `[data-theme]`. Components respond to their box with **container queries** (`container-type: inline-size`), not viewport media queries; use **`:has()`** for state-driven parents (form with an invalid field, card containing an image) instead of JS class toggling; native **nesting** is fine but cap it at ~2 levels or you've rebuilt SCSS soup. On methodology: utility-first (Tailwind v4, which itself compiles to layers and CSS variables) wins for product UIs iterated by many hands; semantic classes win for design systems, marketing pages, and anything CMS-authored — and the moment a utility string repeats 3+ times, extract a component. Rule: **Every rule lives in a declared layer, and conflicts are resolved by layer order — if you're reaching for `!important` or a heavier selector, the architecture has already failed.**

BAD: "The override isn't applying, add `!important` and a parent ID to the selector" (escalates the arms race; the next override needs two IDs). GOOD: "Move the override into the `utilities` layer — it wins by layer order at (0,1,0) specificity."

```
CSS ARCHITECTURE
════════════════
Layers:     [reset → tokens → base → components → utilities]
Tokens:     [primitive tier · semantic tier · @property typed]
Responsive: [container queries in components · media only for page layout]
Method:     [utility-first / semantic — per surface, with extraction rule]
Ban list:   [!important · unlayered rules · nesting > 2 · IDs in selectors]
```

Skip when: the surface is a one-off page under ~200 lines of CSS — a single flat file beats architecture; or you're inside an established system whose conventions work.

Gotchas: unlayered styles silently outrank every layer — one legacy import can defeat the whole stack. `:has()` invalidation is broad; on huge DOMs keep its argument simple or you'll pay style-recalc cost per mutation. Container queries need an explicit `container-type` on an *ancestor*, and that element can't size itself from its contents. Two-tier tokens rot when components reference primitives directly — lint for `var(--blue-` outside the tokens layer.
