---
name: browser-extension-development
description: Use when building or migrating a browser extension under Manifest V3, or when store review keeps rejecting it. Covers service-worker lifecycle (no in-memory state), permissions minimalism for review approval, content-script isolation, and cross-browser Chrome/Firefox/Safari packaging. Produces an extension architecture plan with permission budget and lifecycle strategy.
---

# /browser-extension-development — MV3 Without the Footguns

Use to architect browser extensions that survive MV3's ephemeral service worker, pass store review on the first try, and ship to Chrome, Firefox, and Safari from one codebase.

**Persona: Extension Platform Engineer.** You own manifest design, background lifecycle, and the content-script/page boundary. You do NOT design the product's features or write the privacy policy's legal text — you make the extension architecturally sound and review-approvable.

The MV3 mental model that breaks everyone: the **service worker is ephemeral** — Chrome kills it after ~30s idle, so any global variable is a bug waiting for the first quiet minute. All state goes to `chrome.storage.session`/`local`, timers become `chrome.alarms` (minimum ~30s granularity, commonly 1 min), and long-lived work uses **offscreen documents** (Chrome) for audio/DOM/clipboard needs; keeping a port open just to pin the worker alive is a hack review teams increasingly flag. **Permissions are your review risk budget**: request the minimum, prefer `activeTab` + `scripting.executeScript` over broad `host_permissions`, and use `optional_permissions` with runtime requests for everything else — each broad host pattern (`<all_urls>`, `*://*/*`) commonly adds days-to-weeks of manual review and demands written justification, so ship v1 with **zero** all-URL permissions if humanly possible. Content scripts run in an **isolated world**: they share the DOM but not the page's JS objects; to touch page globals inject into the **MAIN world** (`world: "MAIN"` in `chrome.scripting`) and communicate back via `window.postMessage` with strict origin checks — never trust messages from the page. Cross-browser in 2026: build on the **WebExtensions API with the `browser.*` promise namespace** (Firefox-native; polyfill for Chrome), gate divergences behind a small compat layer (Firefox MV3 uses event pages and persistent scripts differently; Safari requires an Xcode-wrapped **Safari Web Extension** and App Store review), and produce per-store builds from one source tree with a bundler like WXT or Plasmo-class tooling. Rule: **Any state that must survive 30 seconds lives in chrome.storage, not in a service-worker variable.**

BAD: "Store the auth token and WebSocket in service-worker globals — it worked in every test" (tests never idle 30s; in production the worker restarts, state vanishes, and users see random logouts). GOOD: "Token in `storage.session`, reconnect-on-wake logic in the worker's top-level scope, periodic sync via `chrome.alarms`."

```
EXTENSION ARCHITECTURE PLAN
═══════════════════════════
Targets: [Chrome|Firefox|Safari] · toolkit: [WXT|Plasmo|custom] · manifest: MV3
Permissions: required [list] · optional/runtime [list] · host patterns: [none|justified]
Lifecycle: state→[storage.session/local] · timers→[alarms] · long-work→[offscreen doc]
Content scripts: isolated-world [files] · MAIN-world [files] · page↔CS bridge: [postMessage+origin check]
Review pack: [permission justifications · privacy policy URL · demo video]
Per-browser deltas: [Firefox event-page notes · Safari Xcode wrapper]
```

Skip when: the feature works as a bookmarklet, PWA, or plain web app — extensions carry permanent review, update-lag, and platform-churn costs. Internal-only tooling can side-load via enterprise policy and skip store constraints.

Gotchas: `chrome.storage.local` writes are async — read-modify-write races between events corrupt state; serialize through one writer or use versioned keys. DOM-injecting content scripts on SPAs miss route changes — observe `navigation`/history events, not just `document_idle`. Remote-hosted code is banned in MV3; even a config-driven `eval`-ish plugin loader gets you delisted. Testing only in Chrome: Firefox's stricter CSP and Safari's aggressive worker suspension surface bugs Chrome never shows — run the matrix before each release, not before each rejection.
