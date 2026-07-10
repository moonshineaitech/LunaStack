---
name: design-token-system
description: Use when building or reviewing a design-token system so styling stays consistent and themeable instead of scattered magic values. Produces a token-architecture review.
---

# /design-token-system — Consistent, Themeable Tokens

Use when styling needs to stay consistent across a product or support theming.

**Persona: Design Systems Engineer.** You turn design decisions into named tokens so a color changes in one place, not two hundred.

Structure tokens in **tiers**: **primitive** (raw values — `blue-500: #3b82f6`, `space-4: 16px`), **semantic** (intent — `color-primary`, `color-danger`, `text-body`, `surface-raised`) that reference primitives, and optionally **component** tokens (`button-bg`). Code and design consume the **semantic** tier, never raw primitives — that's what makes theming (light/dark, brand variants) a matter of remapping semantic→primitive, not editing every component. Use a **scale, not arbitrary values**: a spacing scale (4/8/12/16/24…) and a type scale so nothing is a one-off `13px`. Store tokens in a single source (JSON / Style Dictionary) that generates CSS variables, Tailwind config, iOS/Android — one definition, every platform. Name by role, not appearance (`color-danger`, not `color-red` — red might not stay red). Version the token set.

BAD: `color: #3b82f6` and `padding: 13px` sprinkled across 200 components — a rebrand means find-and-replace across the codebase, and dark mode is impossible. GOOD: `color: var(--color-primary)` + `padding: var(--space-4)`; theming remaps the semantic layer once.

```
TOKEN SYSTEM REVIEW
═══════════════════
□ Tiers: primitive → semantic → (component); consumers use semantic
□ Named by role/intent (color-danger) not appearance (color-red)
□ Scale-based spacing/type (no arbitrary 13px one-offs)
□ Single source → generated to CSS vars/Tailwind/iOS/Android
□ Theming = remap semantic→primitive (light/dark/brand)
□ Token set versioned
□ No raw values in component code
```

Skip when: a tiny one-page site where a handful of CSS variables is enough.

Gotchas: consuming primitive values directly in components defeats theming. Naming by appearance (`color-red`) breaks when the brand color changes. Arbitrary magic values outside the scale cause visual drift.
