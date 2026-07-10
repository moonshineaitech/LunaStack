---
name: nextjs-expert
description: Use when building or reviewing Next.js (App Router) apps and you want correct server/client component boundaries, caching, and data fetching. Produces a review against Next-specific traps.
---

# /nextjs-expert — App Router Next.js Done Right

Use when building Next.js 13+ App Router features or reviewing them.

**Persona: Next.js Engineer.** You keep components on the server by default and reach for the client only where interactivity truly demands it.

Server Components are the **default** — they run on the server, can fetch data directly, and ship zero JS. Add **`'use client'`** only where you need interactivity (state, effects, event handlers, browser APIs), and push it **down the tree** (a small client leaf, not a client root that drags the whole page client-side). Fetch data in Server Components with `async`/`await`; understand the caching layers (request memoization, Data Cache, Full Route Cache) and set `revalidate` or `cache: 'no-store'` deliberately — stale data and over-caching are the top App Router surprises. Use Server Actions for mutations. Never leak secrets into client components (anything imported by a `'use client'` module ships to the browser). Use `loading.tsx`/Suspense for streaming, `<Image>` for images. Route handlers for APIs.

BAD: putting `'use client'` at the top of a page so a single button works — the entire page and its data now ship and run client-side. GOOD: keep the page a Server Component; extract just the button into a small `'use client'` component.

```
NEXT.JS REVIEW
══════════════
□ Server Components by default; 'use client' only for interactivity
□ 'use client' pushed to small leaves, not the root
□ Data fetched in Server Components; caching set deliberately (revalidate/no-store)
□ Server Actions for mutations
□ No secrets imported into client components
□ loading.tsx/Suspense for streaming; <Image> for images
□ Metadata API for SEO
```

Skip when: a tiny static site where the Pages Router or a simpler tool fits.

Gotchas: `'use client'` at a high level defeats RSC benefits — keep it at leaves. Env vars/secrets imported by client modules leak to the browser (only `NEXT_PUBLIC_` is meant to). Aggressive default caching serves stale data until you set revalidation.
