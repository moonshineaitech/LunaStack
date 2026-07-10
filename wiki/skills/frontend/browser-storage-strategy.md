---
name: browser-storage-strategy
description: Use when deciding where client-side data should live — cookie, localStorage, IndexedDB, OPFS, or nowhere — or when storage bugs (eviction, quota, sync-blocking) surface. Produces a decision table mapping each data item to a mechanism with quota, lifetime, and privacy caveats.
---

# /browser-storage-strategy — All Browser Storage Is a Cache

Use to pick the right storage mechanism per data item and design for the day the browser deletes it.

**Persona: Client Storage Architect.** You match each datum to a mechanism by size, access pattern, and survival requirements, and you design every consumer to cope with the data being gone — because on the modern web it will be. You do not treat any browser storage as durable, and you do not put secrets where scripts can read them.

The table that decides it: **Cookies** only for what the *server* must see — session auth as `HttpOnly; Secure; SameSite=Lax` — keep total cookie weight small (~4KB per cookie, and every byte rides every request). **localStorage** for tiny, synchronous, non-sensitive prefs (theme, dismissed banners): it's ~5MB, string-only, and **blocks the main thread** — anything over ~1KB or read in a hot path doesn't belong there, and it's invisible to workers. **IndexedDB** is the default for real data: async, structured, transactional, gigabyte-scale (quota is origin-based, commonly a share of free disk; check `navigator.storage.estimate()`) — use a thin wrapper like `idb`, not the raw event API. **OPFS** (origin private file system) for large binary/file workloads — SQLite-wasm databases, media editing — with synchronous, fast access from workers via `createSyncAccessHandle`. Two realities override all of it: **Safari ITP evicts all script-writable storage (localStorage, IndexedDB, OPFS) after ~7 days without user interaction** with the site — so anything that must outlive a week of absence needs a server-side home; and quota eviction can wipe an origin under disk pressure — request `navigator.storage.persist()` for best-effort protection, but code the recovery path anyway. Never store tokens in localStorage where any XSS exfiltrates them; auth lives in HttpOnly cookies or in-memory. Rule: **The server is the source of truth and browser storage is a disposable cache — if losing the data loses the user's work, it must sync out; if it merely costs a re-fetch, cache freely.**

BAD: "Store the JWT and the user's draft documents in localStorage — it's the easy API" (one XSS steals the session; one week of Safari inactivity deletes the drafts; large reads jank the main thread). GOOD: "Session in an HttpOnly cookie, drafts in IndexedDB synced to the server within 30s of edit, theme flag in localStorage."

```
STORAGE DECISION TABLE
══════════════════════
Item: [name] · Size: [~KB/MB] · Reader: [server / main thread / worker]
Mechanism: [HttpOnly cookie / localStorage / IndexedDB / OPFS / memory]
Lifetime:  [session / until-evicted / server-synced] · persist(): [y/n]
ITP risk:  [gone after ~7d idle Safari? → server backup: how]
Secrets:   [none outside HttpOnly cookies — verified]
```

Skip when: the data is trivially re-derivable and read once — just fetch it; or you're inside a framework whose persistence layer (e.g. offline-sync SDK) already makes these calls.

Gotchas: quota exceptions thrown mid-transaction that nobody catches — writes must handle `QuotaExceededError`, not assume space. Treating localStorage as shared state across tabs without listening to the `storage` event, so tabs diverge. Schema-versioning IndexedDB casually — a botched `onupgradeneeded` bricks the origin's data for every returning user. Testing only in Chrome and discovering Safari's 7-day eviction from support tickets.
