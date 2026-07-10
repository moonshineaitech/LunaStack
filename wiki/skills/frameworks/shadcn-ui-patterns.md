---
name: shadcn-ui-patterns
description: Use when adding, theming, customizing, or upgrading shadcn/ui components — code you copy and own, not a dependency. Produces an ownership and theming plan that keeps primitives diffable against the registry while app logic stays out of them.
---

# /shadcn-ui-patterns — Own Your Components, Don't Import Them

Use to structure a shadcn/ui codebase: what lives in `components/ui`, how theming flows through CSS variables, and how to take upstream updates.

**Persona: Design-System Owner.** You treat `components/ui` as vendored source you maintain, wire theming through semantic tokens, and keep app behavior in wrapper components. You do NOT treat shadcn as an npm package or fork primitives for feature logic.

shadcn/ui inverts the component-library contract: `npx shadcn@latest add button` copies source into `components/ui/` and from that moment it's your code — there is no upgrade path by version bump, only `npx shadcn@latest diff` against the registry. That makes the load-bearing discipline **two-layer ownership**: keep `components/ui/` as near-pristine primitives (styling tweaks, token changes fine) and put every app-specific behavior — data fetching, business variants, composed forms — in wrappers under `components/` that import the primitives. Once a primitive diverges more than ~20% from upstream, stop diffing and declare it fully yours; before that threshold, periodic diffs are cheap insurance for a11y and bug fixes flowing from Radix. Theming is exclusively **semantic CSS variables** (`--background`, `--primary`, `--destructive`) defined in `globals.css` — in the Tailwind v4 era as **oklch** values under `@theme` — with dark mode as a `.dark` class override; never hardcode a palette color inside a component, or dark mode and future rebrands both break. Underneath sit **Radix primitives** doing the hard parts (focus traps, `aria-*`, keyboard nav, portals) — when you restyle a Dialog or Select, preserve the Radix part structure and `asChild` composition or you silently strip accessibility. The 2026 registry ecosystem supports namespaced custom registries, so a team can publish its own blessed variants and `add` them like upstream components. Rule: **App logic never enters `components/ui/` — wrap primitives, and once a primitive drifts past ~20% from the registry, own it outright and stop diffing.**

BAD: "Add the loading spinner, analytics call, and API mutation directly into `components/ui/button.tsx`" (every future registry diff is now a merge conflict, and the 'primitive' secretly performs side effects). GOOD: "Create `components/submit-button.tsx` wrapping the untouched `ui/button` with loading state and tracking — the primitive stays diffable."

```
SHADCN OWNERSHIP PLAN
═════════════════════
Primitives: [components/ui — styling/token edits only]
Wrappers: [components/* — app variants, data, behavior]
Theme: [semantic tokens in globals.css · oklch · .dark override · no hardcoded colors]
Radix: [part structure + asChild preserved in customizations]
Upgrades: [shadcn diff cadence: per-release] · Divergence: [<~20% keep diffing / else own]
Registry: [upstream / custom namespace: name]
```

Skip when: you need a fully-supported versioned library with contractual upgrades (MUI, Ant) or a non-React/Tailwind stack.

Gotchas: mentally modeling shadcn as a dependency and waiting for "the update" that never installs itself — upgrades are manual diffs you schedule. Hardcoding `bg-zinc-900` inside primitives, then discovering dark mode and theming are wired to variables you bypassed. Ripping out Radix data attributes or `asChild` while restyling and shipping a Dialog that keyboard users can't escape. Copying 40 components on day one "to have them" — each is code you now maintain; add on demand.
