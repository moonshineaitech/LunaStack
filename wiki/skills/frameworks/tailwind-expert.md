---
name: tailwind-expert
description: Use when building or reviewing Tailwind CSS and you want maintainable utility usage, a real design system via tokens, and no class soup. Produces a review against Tailwind-specific traps.
---

# /tailwind-expert — Maintainable Tailwind CSS

Use when styling with Tailwind or reviewing a component's classes.

**Persona: Tailwind Engineer.** You use utilities as a design-token system, not as inline-style chaos, and you extract repetition into components.

Drive design consistency from the **theme config** (`tailwind.config`): define your color, spacing, and type scale there and use the tokens (`text-primary`, `p-4`) — **avoid arbitrary values** (`p-[13px]`, `text-[#3a7bd5]`) except rarely; they bypass the system and cause drift. When the same long class string repeats, **extract a component** (React/Vue) rather than copy-pasting 15 classes — don't reach for `@apply` heavily (it recreates the CSS-abstraction problem Tailwind avoids). Use responsive (`md:`) and state (`hover:`, `focus:`, `dark:`) variants rather than custom CSS. Order matters only for conflicting utilities (later wins) — use `tailwind-merge` when composing conditional classes. Purge/content config must cover all template paths or classes get stripped in production. Prefer semantic tokens over raw palette values so theming is centralized.

BAD: `class="p-[13px] text-[#3a7bd5] mt-[7px]"` repeated across 10 components — arbitrary values, no system, impossible to retheme. GOOD: define `primary` + spacing scale in config; `class="p-3 text-primary mt-2"`, extracted into a `<Button>` component.

```
TAILWIND REVIEW
═══════════════
□ Design tokens in config; arbitrary values [..] avoided
□ Repeated class strings extracted into components (not heavy @apply)
□ Responsive/state variants over custom CSS
□ tailwind-merge for conditional class composition
□ content/purge paths cover all templates
□ Semantic color tokens (retheme-able), not raw hex
□ dark: variant for theming
```

Skip when: a one-off page where a tiny bit of plain CSS is simpler.

Gotchas: arbitrary values (`[13px]`) bypass the design system and cause drift. Missing content paths purge needed classes in production builds. Overusing `@apply` recreates the very CSS-maintenance problem Tailwind was meant to avoid.
