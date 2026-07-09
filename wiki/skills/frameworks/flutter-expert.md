---
name: flutter-expert
description: Use when building or reviewing Flutter UIs and you want smooth 60fps widgets, correct state management, and no rebuild or dispose leaks. Produces a review against Flutter-specific traps.
---

# /flutter-expert — Smooth, Correct Flutter

Use when building Flutter widgets or reviewing them for performance.

**Persona: Flutter Engineer.** You keep `build()` cheap and `const`, and you never leave a controller undisposed.

Use **`const` constructors** everywhere possible — a `const` widget is not rebuilt when its parent rebuilds, which is the single biggest Flutter perf lever. Keep `build()` **pure and cheap**: no I/O, no allocation of expensive objects, no side effects (it runs on every frame that rebuilds). Rebuild the smallest subtree — extract widgets and use `const`/keys so `setState` doesn't rebuild the whole screen. Pick a state solution deliberately (Provider/Riverpod/Bloc) and dispose controllers/streams/animation controllers in `dispose()` (a leak otherwise). Use `ListView.builder` (not a `Column` of all children) for long lists — it lazily builds visible items. Offload heavy CPU to an **isolate** (`compute`). Avoid `Opacity`/`ClipRRect` on large subtrees in animations (expensive). Use keys correctly for stateful items in reorderable lists.

BAD: a big `build()` that constructs a `List` of 500 widgets in a `Column` and does a sync JSON parse — janks and rebuilds everything on any `setState`. GOOD: `ListView.builder` for the list, `const` on static children, parse via `compute`.

```
FLUTTER REVIEW
══════════════
□ const constructors wherever possible (skip rebuilds)
□ build() pure/cheap — no I/O, no side effects
□ Smallest-subtree rebuilds (extract widgets, const, keys)
□ Controllers/streams/animations disposed in dispose()
□ ListView.builder for long lists (lazy)
□ Heavy CPU via compute/isolate (UI stays 60fps)
□ Deliberate state management (Provider/Riverpod/Bloc)
```

Skip when: a trivial single static screen.

Gotchas: missing `const` causes needless rebuilds — the top Flutter perf issue. Undisposed controllers/streams leak. A `Column` of hundreds of children builds them all; use `ListView.builder`.
