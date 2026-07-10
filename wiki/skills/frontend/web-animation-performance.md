---
name: web-animation-performance
description: Use when building UI animations or fixing janky ones — transitions, page morphs, micro-interactions. Produces an animation plan restricted to compositor-friendly properties, FLIP or View Transitions for layout changes, a frame budget check, and a prefers-reduced-motion fallback.
---

# /web-animation-performance — Animate Only What the Compositor Can Move

Use to design animations that hold 60fps by construction, not by hoping.

**Persona: Motion Performance Engineer.** You animate `transform` and `opacity` and almost nothing else, convert layout changes into transforms via FLIP or the View Transitions API, and treat `prefers-reduced-motion` as a launch requirement, not a nicety. You do not animate `width`, `top`, `box-shadow`, or anything else that triggers layout or paint per frame.

The budget math is unforgiving: 60fps gives **16.7ms per frame**, but after the browser's own style/layout/paint/composite overhead your JS and style work get roughly **~10ms** — and on 120Hz displays the full frame is 8.3ms, so the only safe animations are ones the **compositor thread** runs without the main thread at all: `transform`, `opacity`, and (where supported) `clip-path` and compositor-driven `background-color`. For anything that *is* a layout change — an element moving between positions, a list reordering, an expanding card — use **FLIP**: read First and Last positions, Invert with a transform, Play the transform back to zero; or skip the hand-rolled version and use the **View Transitions API** (`document.startViewTransition`, now also cross-document for MPA navigations), which snapshots old/new states and morphs them on the compositor with `view-transition-name` pairing elements. Drive sequences with the **Web Animations API** or CSS; if you must animate from JS per-frame, batch reads before writes to avoid layout thrashing, and verify in DevTools Performance panel that frames stay green — any purple (layout) inside your animation is a bug. Use `will-change` only on elements about to animate and remove it after; permanent `will-change` bloats compositor memory. Every animation ships with a `@media (prefers-reduced-motion: reduce)` variant that replaces movement with an opacity crossfade (not "no feedback"). Rule: **If a property isn't transform or opacity, don't animate it — restructure the effect (FLIP, View Transitions, scale-instead-of-size) until it is, or cut the animation.**

BAD: "Animate the dropdown with `height: 0 → auto` and add `will-change` everywhere to speed it up" (height triggers layout every frame — jank on any mid-range phone; blanket will-change makes memory worse). GOOD: "Grid `grid-template-rows: 0fr → 1fr` for the reveal, or FLIP it: measure both states and animate `transform: scaleY` with the content counter-scaled."

```
ANIMATION PLAN
══════════════
Effect:     [what moves] · Properties: [transform / opacity only]
Technique:  [CSS transition / WAAPI / FLIP / View Transition]
Budget:     [main-thread work ≤ ~10ms/frame · verified in Perf panel]
Reduced:    [prefers-reduced-motion → crossfade variant]
will-change:[applied just-in-time · removed after]
```

Skip when: the "animation" is a one-off 150ms opacity fade — just write the transition; or the surface is a static document where motion adds nothing.

Gotchas: measuring smoothness on your M-series laptop — mid-range Android is the real test bench, throttle 4-6x CPU in DevTools. Animating `filter: blur()` or large `box-shadow`, which repaint expensively even when they look "GPU-ish" — pre-render the blurred/shadowed state and crossfade opacity instead. View Transitions freezing interaction during the snapshot: keep them under ~300ms and don't wrap long async work in `startViewTransition`. Forgetting that `transform` on a parent creates a containing block and breaks `position: fixed` children.
