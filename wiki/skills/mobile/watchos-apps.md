---
name: watchos-apps
description: Use when building or scoping a watchOS app — independent vs companion decision, complication design across accessory families, background refresh budgets, HealthKit permission flows, and battery-honest feature choices. Produces an independence verdict, a complication set, a refresh-budget plan, and a HealthKit permission map.
---

# /watchos-apps — The Wrist Gets Seconds, Not Sessions

Use to scope watch apps around 5-second interactions, hourly-at-best background refresh, and battery costs you must disclose to yourself before users discover them.

**Persona: Wrist-Budget Realist.** You design for the glance and the complication first, the app second, and you price every feature in battery before building it. You do not port a phone information architecture to a 45mm screen, and you do not promise real-time data the refresh budget cannot deliver.

Decide **independent vs companion** by one test: does the core loop work with the iPhone in another room? Independent (its own networking, own sign-in via ASAuthorization, own storage) is the default in 2026; use `WatchConnectivity` only as an accelerator for setup and bulk transfer, never as the data lifeline — it's flaky exactly when users are away from the phone. **Complications are widgets now**: build `accessoryCircular`, `accessoryCorner`, `accessoryInline`, and `accessoryRectangular` with WidgetKit, and treat the complication as the app's front door — most sessions start there, so it must deep-link straight to the one relevant screen. Background refresh is brutally rationed: commonly ~4 scheduled refreshes/hour *only* when your complication is on the active watch face, far fewer otherwise — so if the feature needs fresher data than that, redesign around an `HKWorkoutSession` (keeps you running for the whole workout), APNs pushes, or fetch-on-wrist-raise, because polling is not on the menu. HealthKit: request the minimum types, in context, split read from share; authorization status for *reads* is deliberately unknowable (privacy), so code for "query returns nothing" as a normal state, and use `HKLiveWorkoutBuilder` for in-workout metrics rather than your own timers. Battery honesty: continuous GPS + heart rate is the expensive tier (a multi-hour workout can take a serious bite of the battery); always-on display gets the dimmed `TimelineView` state — update it by the minute, not the second. Rule: **If the feature needs data fresher than ~hourly background refresh provides, it must live inside a workout session, a push, or an on-demand fetch — or it must not ship.**

BAD: "Mirror the phone app's five tabs onto the watch so it's full-featured" (nobody navigates tabs on a wrist; sessions are 5 seconds, and the bloat costs battery and review-team goodwill). GOOD: "One complication answering the core question, one screen of detail on tap, one action button — everything else stays on the phone."

```
WATCH APP SCOPE
═══════════════
Independence: [core loop w/o iPhone? → independent / companion] · Sync: [own network + WC as bonus]
Complications: [family → data shown → deep-link target]
Freshness: [need → mechanism: complication push / bg refresh ~4/hr-on-face / workout session]
HealthKit: [types read/share → asked in context → empty-read handled]
Battery ledger: [GPS/HR/AOD features → cost tier → user-visible justification]
```

Skip when: watch presence is purely notification mirroring — the iPhone app's notifications already appear on the wrist for free, and an app adds maintenance without value.

Gotchas: treating an empty HealthKit query as an error state — denied read permission is indistinguishable from no data, by design. Scheduling background refresh and assuming it fires as scheduled — it's a request, and without an active-face complication most requests are skipped. Shipping second-hand timers on the always-on display, burning battery for motion nobody sees. Relying on WatchConnectivity for critical data flow, which silently queues when the phone is unreachable — exactly during the run your fitness app exists for.
