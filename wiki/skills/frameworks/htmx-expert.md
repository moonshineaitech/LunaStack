---
name: htmx-expert
description: Use when building or reviewing an htmx-driven app and you want hypermedia-style interactivity with correct swaps and server-returned HTML. Produces a review against htmx-specific traps.
---

# /htmx-expert — Hypermedia-Driven htmx

Use when adding interactivity with htmx or reviewing it.

**Persona: Hypermedia Engineer.** You return HTML fragments from the server and let htmx swap them, keeping state on the server where it belongs.

htmx's model: an element issues a request (`hx-get`/`hx-post`) and swaps the **HTML the server returns** into the DOM (`hx-target` + `hx-swap`). So the server returns **HTML fragments, not JSON** — design endpoints to render partials. Choose `hx-swap` deliberately: `innerHTML` (default), `outerHTML` (replace the element itself), `beforeend` (append to a list), `none`. Use `hx-trigger` for events (`keyup changed delay:300ms` for search-as-you-type with debounce). Keep state on the **server** — htmx shines when the server is the source of truth; don't try to also manage heavy client state. Use `hx-indicator` for loading UI, `hx-boost` for progressive-enhancement of links/forms. Return proper status codes; `HX-Redirect`/`HX-Trigger` response headers control client behavior. For anything genuinely client-heavy (rich editors), htmx isn't the tool — use a JS component there.

BAD: an `hx-get` endpoint that returns JSON, then trying to render it with client JS — that's fighting htmx; you've reinvented a SPA. GOOD: the endpoint returns the rendered `<ul>` fragment; `hx-target="#list" hx-swap="innerHTML"` swaps it in.

```
HTMX REVIEW
═══════════
□ Server returns HTML fragments (not JSON)
□ hx-target + hx-swap chosen deliberately (inner/outer/beforeend)
□ hx-trigger with debounce (delay:) for search/input
□ State on the server (source of truth)
□ hx-indicator for loading; hx-boost for progressive enhancement
□ Response headers (HX-Redirect/HX-Trigger) for client control
□ Genuinely client-heavy UI → a JS component instead
```

Skip when: the app is a rich client-side SPA — htmx's server-HTML model doesn't fit.

Gotchas: returning JSON defeats htmx — return HTML partials. Wrong `hx-swap` replaces the wrong element (outerHTML vs innerHTML confusion). Trying to manage heavy client state alongside htmx fights its model.
