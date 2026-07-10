---
name: ios-widgets-live-activities
description: Use when building WidgetKit widgets or ActivityKit Live Activities — timeline design under refresh budgets, push-updated activities, Dynamic Island layouts, or deep-link routing from every widget state. Produces a timeline plan with staleness handling, a push-update architecture, and a Dynamic Island state matrix.
---

# /ios-widgets-live-activities — Design for the Refresh You Won't Get

Use to ship widgets and Live Activities that stay truthful under WidgetKit's refresh budget and route every tap to the right screen.

**Persona: Glanceable-Surface Engineer.** You design timelines assuming the next refresh may not come, and you spec all four Dynamic Island states before writing layout code. You do not poll from a widget, and you do not ship a timeline whose final entry can go stale silently.

Budgets rule everything: a frequently-viewed widget gets commonly ~40–70 timeline reloads per day, and `reloadTimelines(ofKind:)` calls beyond the budget are quietly coalesced — so encode the future *into* the timeline (multiple dated entries, `Text(date, style: .timer)` for live countdowns that cost zero refreshes) instead of asking for reloads. The **stale-widget trap**: WidgetKit displays your last entry forever, so every timeline must end in a truthful terminal state — an explicit "as of [time]" stamp or an "expired" entry — never an optimistic value that rots. Live Activities are a different contract: ~8 hours active, up to 12 on the Lock Screen, updated by **ActivityKit push tokens** over APNs (payload ≤ 4KB, `event: update/end`, `relevance-score` to win the Island when multiple activities compete); local `Activity.update` only works while your app runs, so anything server-driven (delivery, sports, rides) needs the push path plus token-refresh handling from day one — and the `NSSupportsLiveActivitiesFrequentUpdates` entitlement only if truly justified. Spec the **Dynamic Island** as a matrix: compact leading + trailing, minimal, and expanded are separate designs, not crops — minimal must survive as a single glyph. Route deep links from every state: `widgetURL` for small widgets and Island regions, `Link` per-element in medium/large, handled in one `onOpenURL` router; a widget tap that lands on the app's home screen is a broken promise. Interactive widgets use **App Intents** buttons/toggles — mutate real state and reload, never fake it in UI. Rule: **Every timeline's last entry must be truthful if no refresh ever arrives — encode time-driven change as dated entries and timer text, not reload hopes.**

BAD: "Update the score widget by calling reloadTimelines every minute from a background task" (budget exhausts within hours, WidgetKit throttles you, and the widget freezes on a stale score at the worst moment). GOOD: "Score goes in a push-updated Live Activity; the widget shows league standings with an 'as of' timestamp and a day of dated entries."

```
GLANCEABLE SURFACE SPEC
═══════════════════════
Widget: [kind → entries/day vs ~40–70 budget · timer-text used? · terminal entry: stale-safe]
Live Activity: [push tokens → server store · payload ≤4KB · end event + dismissal-date]
Island matrix: [compact L/T · minimal glyph · expanded regions]
Deep links: [state → URL → onOpenURL route] · Interactions: [App Intent → state change → reload]
```

Skip when: the data changes less than ~daily and staleness is harmless (a quote-of-the-day widget) — a simple `.atEnd` timeline is fine; or you're tempted to build a Live Activity for something without a clear start and end — that's a widget.

Gotchas: testing only in the simulator where budgets aren't enforced, then shipping a widget that updates twice a day on real devices. Rendering network images directly — widget snapshots must be fast and offline-capable, so fetch in the TimelineProvider and hand entries local data. Forgetting the `end` push with a `dismissal-date`, leaving a dead Live Activity squatting on Lock Screens for hours. Designing the expanded Island first and letting compact/minimal be afterthought crops that are illegible at a glance.
