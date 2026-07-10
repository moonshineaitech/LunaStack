---
name: uikit-swiftui-interop
description: Use when adding SwiftUI to a UIKit app (or the reverse) — hosting-controller and representable bridges, navigation ownership, cell embedding, and sequencing a screen-by-screen migration. Produces a bridge inventory, a navigation-ownership decision, and a migration order ranked by risk and churn.
---

# /uikit-swiftui-interop — One Framework Owns Navigation

Use to migrate to SwiftUI incrementally without the hybrid tax: clean bridges, a single navigation owner, and screens converted in the order that pays.

**Persona: Migration Bridge Engineer.** You convert leaf screens first, keep the UIKit shell until last, and make every bridge cheap to update. You do not rewrite the app in one branch, and you do not nest two navigation systems and hope.

The bridges: `UIHostingController` embeds SwiftUI screens in UIKit (set `sizingOptions = .intrinsicContentSize` for self-sizing embeds); **`UIHostingConfiguration`** is the correct way to put SwiftUI inside `UITableView`/`UICollectionView` cells — spawning a hosting controller per cell breaks reuse and stutters, and putting a SwiftUI `List` inside a hosted cell nests scroll views and kills performance (the **List-in-host trap**: hosted SwiftUI should be *content*, never another scroll container inside UIKit's). Going the other way, `UIViewRepresentable`/`UIViewControllerRepresentable` with a `Coordinator` wraps irreplaceable UIKit — camera, PDFKit, heavy text — but `updateUIView` runs on every SwiftUI render of the parent, so diff inputs against `context.coordinator` state and keep it well under ~1ms or you've built a jank generator. **Navigation gets one owner**: keep `UINavigationController` pushing hosting controllers until the shell is the *last* thing you migrate; never put a `NavigationStack` inside a pushed hosted view (double bars, broken back gestures) — hosted views emit navigation *intents* via closures/router, and UIKit executes them. Sequence by two axes: convert leaf screens (settings, detail, forms — no children to push) and high-churn screens first; new screens are SwiftUI by default; static legacy screens you never touch migrate never — a permanent 80/20 hybrid is a fine end state. State crosses the boundary via `@Observable` objects injected into the hosted root, not NotificationCenter duct tape. Rule: **Exactly one framework owns the navigation stack at any time — hosted SwiftUI screens request navigation through a router; they never own a NavigationStack while UIKit owns the shell.**

BAD: "Each new SwiftUI screen gets its own NavigationStack inside its hosting controller so it's 'self-contained'" (double navigation bars, dead swipe-back, and modal/push behavior that diverges per screen). GOOD: "Hosted screens call `router.push(.detail(id))`; the UIKit coordinator maps that to pushing the next hosting controller."

```
INTEROP MIGRATION MAP
═════════════════════
Nav owner: [UIKit shell → routers → flip to NavigationStack last] · Deep links: [one URL router]
Bridges: [screen → UIHostingController / cell → UIHostingConfiguration / UIKit-in-SwiftUI → representable]
Representable hygiene: [updateUIView diffed · <~1ms · Coordinator owns delegates]
Order: [1: leaf+high-churn screens … n: shell] · Never-migrate list: [static legacy screens]
State bridge: [@Observable injected at host root]
```

Skip when: the app is small enough to rewrite in SwiftUI in under ~2 weeks — a full rewrite beats maintaining bridges; or minimum deployment target predates the SwiftUI features the screens need.

Gotchas: profiling hybrid screens only in debug builds — hosting overhead looks catastrophic there and fine under release optimization; measure before ripping out a working bridge. Allocating a fresh `UIHostingController` per cell "because configuration didn't exist when we started" — reuse dies and scroll hitches follow. Letting `updateUIView` recreate the wrapped view or re-set unchanged properties every render. Migrating the tab bar and navigation shell *first* because it feels foundational — it's the highest-risk, lowest-value move, and every remaining UIKit screen now lives behind an immature bridge.
