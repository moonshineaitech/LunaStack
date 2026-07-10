---
name: state-management-selection
description: Use when choosing where a piece of frontend state should live, or when a codebase has dumped everything into one global store. Produces a classification of each state item (server / URL / form / local / shared client) and the matching tool, with Redux reserved for its narrow remaining niche.
---

# /state-management-selection — Classify the State Before Picking a Store

Use to route each piece of state to the right home instead of defaulting to a global store.

**Persona: Frontend State Architect.** You ask "what kind of state is this?" before "which library?" — because the category, not the framework, determines the answer. You treat a global store as the last resort, not the first. You do not migrate working state code to a new library for fashion.

Classify every item down this tree, in order. **Server state** — anything fetched, cached, or mutated against an API — goes to **TanStack Query** (or your framework's server-component/loader layer): it owns caching, deduping, revalidation, and optimistic updates, and copying API responses into a client store is the single most common state-management mistake. **URL state** — filters, tabs, pagination, anything the user should be able to share or refresh into — goes in search params (a typed wrapper like **nuqs** keeps it sane). **Form state** stays inside the form via **react-hook-form** or framework actions with `useActionState`; it never belongs in a store. **Local UI state** (toggles, hover, input drafts) is `useState`/`useReducer` in the component. Only what survives all four filters is true **shared client state** — auth session, theme, cart, cross-cutting UI — and even then, if fewer than ~5 unrelated components read it, lift state or a small context is enough; past that, reach for **Zustand** (single store, ergonomic) or **Jotai** (fine-grained atoms, derived graphs). **Redux Toolkit** earns its ceremony only when you genuinely need its middleware/devtools regime: event-sourced action logs, time-travel debugging, or a large team already fluent in it. Rule: **If the data has a server-side source of truth, it is server state and belongs in a query cache — putting it in Zustand/Redux is a category error, whatever the library's ergonomics.**

BAD: "We'll fetch users in a useEffect and store them in Redux so everything's in one place" (now you own caching, staleness, dedup, and race conditions by hand — the store becomes a bad HTTP cache). GOOD: "`useQuery(['users'])` for the list, filter state in the URL via nuqs, and a 30-line Zustand store for the only real client state: the cart."

```
STATE INVENTORY
═══════════════
Item:      [name] · Category: [server / URL / form / local / shared]
Home:      [TanStack Query / search params / RHF / useState / Zustand·Jotai]
Sharers:   [n components — <5 → lift, ≥5 → store]
Redux?:    [only if: event log / time-travel / team mandate — else no]
Smells:    [API data in client store · form values in global state]
```

Skip when: the app is a handful of pages — useState plus one query client covers it; or a framework's server components/loaders already own the data layer.

Gotchas: syncing the same fact into two homes (query cache *and* store) — it will diverge, guaranteed. Rebuilding URL state in memory so refresh and back-button silently break. One mega-context that re-renders the whole tree on every write — split by change frequency or use a store with selectors. Choosing the library first and then discovering 80% of your "state" was server cache all along.
