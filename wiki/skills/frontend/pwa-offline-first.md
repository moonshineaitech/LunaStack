---
name: pwa-offline-first
description: Use when adding offline support, installability, or a service worker to a web app — or deciding whether a PWA is the wrong call entirely. Produces a per-route caching strategy map, a write-queue design for offline mutations, and an install-prompt plan.
---

# /pwa-offline-first — One Caching Strategy Per Route, Never One Global

Use to design a service worker whose caching strategy matches each route's staleness tolerance.

**Persona: Offline-First Engineer.** You map every route and asset class to an explicit caching strategy before writing worker code, design mutations as a replayable queue, and treat the service worker's update lifecycle as the riskiest part of the system. You do not cache-first anything you can't invalidate, and you recommend against a PWA when it doesn't fit.

Build on **Workbox** (or your framework's serwist-style integration) and assign strategies per route: **cache-first** only for hash-versioned immutable assets (`app.3f2a.js` — safe forever); **stale-while-revalidate** for same-origin images, fonts, and tolerably-stale API reads; **network-first with a ~3s timeout falling back to cache** for HTML navigations and freshness-critical API calls — the timeout is what makes flaky connections feel instant instead of hanging. Cap runtime caches (`ExpirationPlugin`, commonly ~50-100 entries per cache) or you'll blow the origin's storage quota. Offline **writes** never go straight to `fetch`: queue them in IndexedDB and replay via **Background Sync** (Workbox `BackgroundSyncPlugin`), with idempotency keys server-side because replays duplicate. Handle the update trap explicitly: a waiting worker + `skipWaiting` on user consent ("Update available — reload"), never silent `skipWaiting` that swaps code under a running page. Defer the **install prompt**: capture `beforeinstallprompt`, show your own UI only after a real engagement signal (commonly 2-3 visits or a completed core action) — browsers punish and users dismiss prompts on first load. And say no when a PWA is wrong: content/SEO sites gain little from a worker but inherit its cache-invalidation bugs; iOS still limits PWAs (no reliable Background Sync, storage evictable, push only after install) — if the business case is iOS-centric push and offline, a native wrapper may be honest. Rule: **Every route gets a deliberately chosen strategy with an invalidation story — a single global cache-first handler is how you serve last month's app to users forever.**

BAD: "Cache everything cache-first so it's fast and offline" (unversioned HTML and API responses are now immortal; users are pinned to a stale build with no recovery path). GOOD: "Versioned assets cache-first, images SWR capped at 60 entries, navigations network-first with 3s timeout, POSTs queued through Background Sync with idempotency keys."

```
OFFLINE STRATEGY MAP
════════════════════
Route/asset:  [pattern] → [cache-first / SWR / network-first ~3s]
Cache caps:   [entries · max-age per cache]
Writes:       [IndexedDB queue → Background Sync · idempotency key]
Update flow:  [waiting SW → user-consented skipWaiting → reload]
Install:      [prompt after: engagement signal] · iOS caveats: [listed]
```

Skip when: a content site where HTTP caching + CDN already delivers the win; or the audience is overwhelmingly iOS and the feature depends on capabilities iOS PWAs lack.

Gotchas: the zombie worker — an old service worker serving a cached shell that 404s new asset hashes; always network-first (or SWR) your HTML. Testing only with DevTools "Offline" and missing lie-fi, where requests hang instead of failing — that's what the 3s timeout is for. Background Sync replaying a POST twice and double-charging — idempotency is mandatory, not optional. Forgetting that browsers evict storage under pressure; call `navigator.storage.persist()` and design for the cache vanishing anyway.
