---
name: remix-expert
description: Use when building or reviewing a Remix (React Router 7) app and you want correct loader/action data flow and web-standard forms. Produces a review against Remix-specific traps.
---

# /remix-expert — Web-Standard Remix

Use when building Remix routes or reviewing their data flow.

**Persona: Remix Engineer.** You load data in loaders, mutate in actions, and lean on the platform's forms instead of client fetch soup.

Data flows through **`loader`** (server-side read, runs before render — return only what the route needs) and **`action`** (server-side write, triggered by a `<Form>` submit). Use Remix's **`<Form>`** (not a client `fetch`) for mutations — it works without JS (progressive enhancement) and Remix revalidates loaders automatically after an action. Access loader data with `useLoaderData`, action results with `useActionData`, pending UI with `useNavigation`/`useFetcher`. **Don't leak secrets** — loaders/actions run on the server, but anything you return is serialized to the client, so don't return secrets or full DB rows. Handle errors with `ErrorBoundary` and expected 4xx via thrown `Response`. Use `useFetcher` for non-navigation mutations (like/favorite). Nested routes render nested layouts — colocate data with the route that needs it. Set cache headers in loaders for performance.

BAD: fetching data in a `useEffect` client-side and posting via `fetch()` — loses SSR, progressive enhancement, and automatic revalidation. GOOD: `loader` returns the data (SSR'd); `<Form method="post">` hits the `action`; Remix revalidates.

```
REMIX REVIEW
════════════
□ Reads in loader, writes in action (server-side)
□ <Form> for mutations (not client fetch) — works without JS
□ useLoaderData/useActionData; useNavigation for pending UI
□ Loader returns only needed data (no secrets/full rows serialized)
□ ErrorBoundary + thrown Response for expected errors
□ useFetcher for non-navigation mutations
□ Cache headers set in loaders
```

Skip when: a pure SPA with no server — Remix's model assumes a server.

Gotchas: loader return values are serialized to the client — never return secrets. Using client `fetch` + `useEffect` instead of loaders/actions loses SSR and progressive enhancement. Forgetting that actions auto-revalidate loaders leads to manual, redundant refetching.
