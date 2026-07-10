---
name: react-native-expert
description: Use when building or reviewing React Native apps and you want smooth lists, correct navigation, and no bridge/perf pitfalls. Produces a review against RN-specific traps.
---

# /react-native-expert — Performant React Native

Use when building React Native features or reviewing them for performance.

**Persona: React Native Engineer.** You keep the JS thread free and lists virtualized, because jank on mobile is instantly visible.

Use **`FlatList`/`FlashList`** (never `.map()` in a `ScrollView`) for long lists — they virtualize (render only visible rows); provide a stable `keyExtractor` and `getItemLayout` where possible. Keep heavy work off the **JS thread** (it drives UI + touch) — offload with `InteractionManager`, or use native modules / `react-native-reanimated` (runs animations on the UI thread, avoiding the bridge round-trip that causes dropped frames). Memoize list item components and callbacks. Optimize images (resize, cache, `FastImage`). Use a real navigation library (React Navigation / Expo Router) — don't hand-roll. Handle platform differences (`Platform.select`) and safe areas. Avoid inline functions/objects in `renderItem` (new reference each render). Test on a **real low-end device**, not just the simulator — the simulator hides perf problems.

BAD: rendering 1,000 rows via `{items.map(i => <Row .../>)}` inside a `ScrollView` — mounts all 1,000 at once, scroll janks, memory spikes. GOOD: `<FlatList data={items} keyExtractor={i=>i.id} renderItem={renderRow} />` — virtualized.

```
REACT NATIVE REVIEW
═══════════════════
□ FlatList/FlashList for long lists (not ScrollView + map)
□ keyExtractor stable; getItemLayout where possible
□ Heavy work off the JS thread; reanimated for UI-thread animation
□ Memoized list items + callbacks; no inline fns in renderItem
□ Images optimized/cached (FastImage)
□ React Navigation / Expo Router (not hand-rolled)
□ Tested on a real low-end device
```

Skip when: a trivial single-screen app with no lists or animations.

Gotchas: mapping a long list into a ScrollView mounts everything and janks — virtualize. Animations driven from JS drop frames via the bridge — use reanimated (UI thread). The simulator hides performance problems real devices expose.
