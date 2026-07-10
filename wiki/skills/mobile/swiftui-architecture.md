---
name: swiftui-architecture
description: Use when starting or restructuring a SwiftUI app — choosing observation patterns, navigation design, dependency injection, or deciding where UIKit still earns its keep. Produces an architecture decision sheet mapping state ownership, navigation model, DI strategy, and explicit UIKit escape hatches.
---

# /swiftui-architecture — State Down, Actions Up, UIKit Only on Purpose

Use to structure a SwiftUI app around the Observation framework and typed navigation, and to name the exact places UIKit is still the right call.

**Persona: SwiftUI Systems Architect.** You design state ownership, navigation, and dependency wiring for iOS 17+ codebases under Swift 6 strict concurrency. You do not reach for UIKit out of habit, and you do not wrap every screen in a ceremony-heavy ViewModel when a plain `@State` value would do.

Modern baseline: `@Observable` (the Observation framework) replaces `ObservableObject`/`@Published` — it tracks per-property access, so views re-render only when a property they *read* changes, killing the whole-object invalidation storms that made `ObservableObject` apps jank. Commonly support current-minus-one iOS major (iOS 17 floor gives you `@Observable` and full `NavigationStack`); if the business forces iOS 16, budget for the old observation model everywhere — don't mix. Navigation is a **typed `NavigationPath`** (or a `[Route]` array of a Hashable enum) owned by a router object injected via `@Environment` — deep links become "append routes to the array," testable without UI. Dependency injection: prefer **`@Environment` with custom `EnvironmentKey`s** or a lightweight container (swift-dependencies, Factory) over singletons; every dependency a view touches should be overridable in previews, or your previews die and with them your iteration speed. Reach for TCA only when you need exhaustive testability of complex effect-heavy flows — it's a tax elsewhere. Keep view `body` under ~50 lines; past that, extract child views (which also narrows observation scope). UIKit still wins, via `UIViewRepresentable`: rich text editing (`UITextView` with custom attributes), camera/AVFoundation previews, `UIPageViewController`-grade paging, and collection layouts SwiftUI's `List`/`LazyVGrid` can't express — wrap them thin and keep state in Swift types. Rule: **State lives at the lowest ancestor that needs it, injected down and mutated via closures up — if two unrelated views need the same state, that's your model layer, not a shared view.**

BAD: "Make every screen an `ObservableObject` ViewModel singleton and navigate with chained `NavigationLink(isActive:)`" (whole-object invalidation redraws everything; boolean-chain navigation can't deep link and breaks on iOS 16+). GOOD: "`@Observable` models, one `Router` owning a typed path in `@Environment`, `navigationDestination(for:)` per route enum."

```
SWIFTUI ARCHITECTURE SHEET
══════════════════════════
Floor: [iOS version] · Observation: [@Observable / legacy] · Concurrency: [Swift 6 strict?]
State map: [datum → owner view/model → scope: @State / @Environment / model layer]
Navigation: [route enum cases] · Path owner: [router] · Deep links: [URL → routes]
DI: [@Environment keys / container] · Preview overrides: [verified y/n]
UIKit escape hatches: [component → why SwiftUI can't → wrapper]
```

Skip when: building a widget, watch complication, or single-screen utility — architecture ceremony exceeds the app; or the codebase is UIKit-first and you're embedding SwiftUI leaf views, where UIKit's patterns govern.

Gotchas: migrating to `@Observable` but keeping `@StateObject`/`@ObservedObject` wrappers — they silently don't observe the new macro's properties; use `@State` and `@Bindable`. Putting a `NavigationStack` inside every child view instead of one per tab, so pushes nest and back buttons multiply. Doing async work in `body` or observing objects created inline (`Model()` in an initializer) — recreated every render, state lost. Testing only in previews on Apple Silicon and shipping scroll jank that only shows on an A14-class device in release build.
