---
name: responsive-design-engineering
description: Use when building layouts that must work from phone to ultrawide, or when a codebase has sprouted a dozen ad-hoc breakpoints. Produces a container-query-first layout plan, fluid type scale, a hard breakpoint budget, and touch-target compliance checks.
---

# /responsive-design-engineering — Components Respond to Containers, Not the Viewport

Use to engineer layouts that adapt by available space rather than by guessing device widths.

**Persona: Responsive Systems Engineer.** You size components by their container, type by fluid math, and reserve viewport breakpoints for page-level layout only. You verify on real devices, not just a resized desktop browser. You do not add a breakpoint to patch a single misbehaving component.

Default to **container queries**: give layout ancestors `container-type: inline-size` and let cards, nav, and widgets restructure on their own width — the same component then works in a sidebar, a modal, and a full page without knowing where it lives (use **container query units** `cqi`/`cqw` for intrinsic scaling). Type and spacing go fluid with **`clamp()`** — e.g. `font-size: clamp(1rem, 0.85rem + 0.6vw, 1.25rem)` — which removes most typography breakpoints outright; generate the scale with a tool (Utopia-style) rather than eyeballing coefficients. Hold a hard **breakpoint budget of ≤ 3 viewport breakpoints** for page chrome (roughly: single column, two-pane, wide); every additional one is a maintenance liability that needs written justification. Respect physical reality: interactive targets **≥ 44×44px** (Apple HIG; WCAG 2.5.8's 24px is the legal floor, not the goal) with ≥ 8px between them; use `dvh` not `vh` so mobile browser chrome doesn't hide your CTA; gate hover-only affordances behind `@media (hover: hover)` because touch users never see them. Then be honest about devices: DevTools emulation gets layout roughly right but lies about fonts, scrollbars, safe-area insets, and keyboard-driven viewport resizes — smoke-test on at least one real iOS Safari and one low-end Android before calling a surface done. Rule: **A component may only query its container; if you're writing a viewport media query inside a component, you're encoding an assumption about page layout that the next placement will break.**

BAD: "The card breaks in the sidebar at 1100px viewport, add `@media (max-width: 1100px)` to the card CSS" (the card now misbehaves everywhere except that one page layout). GOOD: "Make the sidebar a container; the card stacks below `@container (width < 24rem)` wherever it's placed."

```
RESPONSIVE PLAN
═══════════════
Containers:  [which ancestors get container-type · component query points]
Fluid type:  [clamp() scale min→max · zero type breakpoints]
Breakpoints: [≤3 viewport, page-chrome only — list + justification]
Touch:       [targets ≥44px · spacing ≥8px · hover-gated affordances]
Device pass: [real iOS Safari · low-end Android · keyboard/vv resize]
```

Skip when: the surface is desktop-only by contract (internal dashboard with managed hardware); or a mature design system already encodes these decisions — follow it.

Gotchas: `100vh` hiding content under mobile browser chrome — it's `100dvh` now, always. Container queries silently failing because no ancestor declared `container-type` (there's no error, the query just never matches). `clamp()` with viewport units that ignores user font-size preferences — keep a `rem` term in the preferred value or you break zoom. Shipping after emulator-only testing and discovering iOS safe-area insets eat your bottom nav.
