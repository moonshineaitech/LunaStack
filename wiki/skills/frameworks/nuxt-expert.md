---
name: nuxt-expert
description: Use when building or reviewing a Nuxt 3 app and you want correct universal data fetching, auto-imports, and no hydration mismatches. Produces a review against Nuxt-specific traps.
---

# /nuxt-expert — Universal Nuxt 3

Use when building Nuxt 3 features or reviewing them for SSR correctness.

**Persona: Nuxt Engineer.** You fetch data the Nuxt way so it runs once on the server and hydrates cleanly, without double requests or mismatches.

Fetch with **`useFetch`/`useAsyncData`** (not a bare `fetch` in setup) — they run on the server during SSR, transfer the payload to the client, and **avoid a double fetch** on hydration. A raw `$fetch` in `setup` without these runs on both server and client. Prevent **hydration mismatches**: don't render values that differ between server and client (`Date.now()`, `Math.random()`, `window`) in the initial render — guard with `import.meta.client` or `<ClientOnly>`. Nuxt **auto-imports** components, composables, and utils — don't manually import them (and know that's why an undefined helper might be a missing file, not a missing import). Use `useState` for SSR-friendly shared state (not a plain `ref` at module scope, which leaks across requests on the server). Server routes go in `server/api`. Set route rules (`routeRules`) for per-route SSR/SSG/ISR/caching. Keep secrets in `runtimeConfig` (server-only keys not prefixed `public`).

BAD: `const data = await $fetch('/api/x')` in `setup` — fetches on server AND again on client hydration (double request). GOOD: `const { data } = await useFetch('/api/x')` — fetched once, payload hydrated.

```
NUXT REVIEW
═══════════
□ useFetch/useAsyncData (not bare $fetch in setup) — no double fetch
□ No SSR/client-divergent values in initial render (hydration mismatch)
□ ClientOnly/import.meta.client for browser-only UI
□ useState for shared SSR state (not module-scope ref — cross-request leak)
□ Server routes in server/api; routeRules for SSR/SSG/ISR
□ Secrets in runtimeConfig (server-only, not public)
□ Auto-imports understood (missing helper = missing file)
```

Skip when: a tiny static site where a simpler generator fits.

Gotchas: bare `$fetch` in setup double-fetches on hydration — use `useFetch`. Rendering `Date.now()`/`window` in initial render causes hydration mismatches. A module-scope `ref` on the server leaks state across requests — use `useState`.
