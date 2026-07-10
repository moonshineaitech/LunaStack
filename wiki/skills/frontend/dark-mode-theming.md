---
name: dark-mode-theming
description: Use when adding dark mode to a product or when an existing dark theme has contrast failures, glowing images, or flash-of-wrong-theme bugs. Produces a semantic token architecture, a three-state preference system (light/dark/system) with flicker-free persistence, and adaptation rules for images, shadows, and elevation.
---

# /dark-mode-theming — Theme Tokens, Not Colors

Use to build dark mode as a semantic token layer with system-preference detection, user override, and content that adapts — not just an inverted palette.

**Persona: Design Token Engineer.** You theme through a two-tier token system where components consume only semantic names (`--color-surface-raised`, `--color-text-subtle`) that resolve to different primitives per theme, and you verify contrast independently in both modes. You do not sprinkle `dark:` overrides per component, and you do not treat dark mode as "the light design with colors flipped."

Architecture first: primitives (`--gray-900`) map to semantics (`--color-bg-page`) in exactly one place — a `[data-theme]` block or, cleaner in 2026, **`light-dark()`** with `color-scheme: light dark` set on `:root` so form controls, scrollbars, and default UI switch natively. The preference is **three states — light, dark, system** — never a boolean: default to `prefers-color-scheme`, persist explicit choices, and kill the flash-of-wrong-theme with a tiny **inline script in `<head>`** that stamps `data-theme` before first paint (plus a `<meta name="color-scheme">` so the pre-CSS background isn't white). Dark design has its own physics: avoid pure `#000`/pure `#fff` pairings (halation makes white-on-black text shimmer — commonly `#e8e8e8`-class text on `#121212`-class surfaces); **elevation is lightness, not shadow** — shadows vanish on dark backgrounds, so raised surfaces get progressively lighter overlays instead; saturated brand colors need desaturated/lightened dark variants because vibrating saturation on dark backgrounds fails both taste and contrast. Content adapts too: dim photographic images slightly (`filter: brightness(.9)` on `[data-theme=dark]` is a defensible default), serve theme-aware assets via `<picture>` + `media="(prefers-color-scheme: dark)"` or `currentColor` SVGs, and re-run contrast checks — **WCAG 4.5:1 for text, 3:1 for UI** — against *both* resolved palettes, since dark modes fail on disabled text and borders that were fine in light. Rule: **Components reference semantic tokens only — the moment a component names a literal color or a raw primitive, it has opted out of theming and will ship a bug in one of the two modes.**

BAD: "Add `.dark` overrides to each component as QA finds white patches" (an unbounded whack-a-mole; every new component ships light-only until someone notices). GOOD: "Define ~30 semantic tokens resolved via `light-dark()`, lint that components use only semantic vars, and audit both palettes with automated contrast checks in CI."

```
THEME SYSTEM
════════════
Tokens:    [n semantic → primitives · mechanism: light-dark() / data-theme]
Preference:[light · dark · system] · Persist: [localStorage + head inline script]
No-flash:  [meta color-scheme + pre-paint stamp: verified]
Dark rules:[no pure #000/#fff pair · elevation = lighter surface · brand desaturated]
Content:   [images dimmed ~10% · picture/media sources · SVG currentColor]
Contrast:  [both modes: text 4.5:1 · UI 3:1 · disabled states checked]
```

Skip when: brand identity is deliberately single-theme (some marketing sites) — set `color-scheme: only light` explicitly rather than shipping an accidental half-theme; or the surface is embedded in a host that dictates theme (extensions, embeds) — inherit the host signal.

Gotchas: reading the theme in React state and rendering before hydration, guaranteeing the flash the inline script existed to prevent — the DOM attribute is the source of truth, JS reads it. Forgetting `color-scheme`, so native inputs, scrollbars, and autofill stay glaring white inside your dark UI. Keeping light-mode `box-shadow` values in dark mode where they read as dirt smudges — swap shadow tokens for surface-lightness tokens. Testing dark mode only at night on one OLED laptop; contrast bugs live on dim LCDs at 40% brightness.
