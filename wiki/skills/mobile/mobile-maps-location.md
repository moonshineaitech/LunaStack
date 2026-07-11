---
name: mobile-maps-location
description: Use when building location features — permission request UX, precise vs approximate handling, battery-tiered tracking strategy, geofencing within OS limits, or choosing MapKit vs Google Maps. Produces a permission-flow spec, a tracking-tier plan with battery costs, a geofence budget, and a maps-SDK verdict.
---

# /mobile-maps-location — Ask in Context, Track in Tiers

Use to design location features that earn permission at the moment of need, spend battery in deliberate tiers, and respect hard geofence limits.

**Persona: Location Privacy-and-Power Engineer.** You request the weakest permission that serves the feature at the moment the user invokes it, and you match tracking accuracy to the job's actual freshness need. You do not prompt on first launch, and you do not run continuous GPS for a feature that needs a city name.

Permission is conversion work: prompting at launch converts terribly; prompting when the user taps "Find stores near me" — after a one-line pre-prompt explaining the benefit — converts commonly 2x+ better, and a denial there is recoverable (deep-link to Settings) instead of permanent. Design for **approximate location** as a first-class path: a meaningful share of users flip Precise off, giving you ~1–20km accuracy — weather, news, and store-finder features should work with it, and only navigation-grade features should call `requestTemporaryFullAccuracyAuthorization` (once, in context). Request *Always* almost never: When-In-Use plus region-monitoring wakes covers most background stories, and Always triggers recurring OS audits of your usage. Track in tiers, cheapest that works: **significant-change** (cell-tower moves, ~500m granularity, nearly free) → **visit monitoring** → **region/geofence wakes** → deferred/reduced-accuracy updates → continuous GPS via the modern `CLLocationUpdate.liveUpdates` async sequence and `CLMonitor` for conditions (the 2026 APIs; delegate-era code is legacy) — continuous best-accuracy GPS is the battery villain, reserved for active navigation and workouts, and stopped the moment the session ends. Hard limits: iOS caps monitored regions at **20 per app** (Android: 100 geofences), so geofencing at scale means dynamic re-registration — monitor the ~15 nearest, keep a slot to detect leaving the cluster, re-register on significant-change wakes. SDK choice: **MapKit** (free, unlimited, SwiftUI-native `Map`, Look Around) is the default for iOS-first apps; pay for **Google Maps Platform** when you need cross-platform rendering parity, its Places data, or coverage in regions where Apple's POI data is thin — and cap it with a usage budget, because per-load pricing scales with your success. Rule: **Request the weakest permission at the moment the feature is invoked — never at launch, never Always when When-In-Use plus a geofence wake serves the story.**

BAD: "Ask for Always + Precise on first launch so every future feature is covered" (majority denial, an unrecoverable prompt spent before value was shown, and an App Review question you'll answer in rejection notes). GOOD: "When-In-Use asked on first 'near me' tap after a benefit pre-prompt; the delivery-tracking feature later escalates via a geofence-wake design, not Always."

```
LOCATION FEATURE SPEC
═════════════════════
Permission: [feature → trigger moment → pre-prompt line → tier: WhenInUse/Always·Precise/Approx]
Approx path: [works at ~1–20km? y/n → degraded UX defined] · Denial: [fallback + Settings deep-link]
Tracking tiers: [job → sig-change / visits / geofence / liveUpdates GPS → stop condition]
Geofences: [count vs cap 20 (iOS)/100 (Android) → dynamic re-registration plan]
Maps SDK: [MapKit / Google → reason: platform · POI data · cost budget]
```

Skip when: location is a one-shot convenience (autofilling a city field) — an IP-geolocation lookup or manual entry avoids the permission system entirely.

Gotchas: reading `authorizationStatus` at launch and prompting immediately because the code path was convenient — the prompt's timing is the product decision, not plumbing. Assuming geofence triggers are prompt and guaranteed — entry/exit events can lag minutes or arrive only on next wake; anything safety-critical needs a server-side check. Forgetting to stop `liveUpdates` when navigation ends, discovering it in one-star "battery drain" reviews. Building precise-only UX so approximate users see a broken map pin instead of a gracefully zoomed-out region.
