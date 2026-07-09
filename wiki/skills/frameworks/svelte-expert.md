---
name: svelte-expert
description: Use when building or reviewing Svelte 5 (runes) components and you want correct reactivity and store usage without stale UI. Produces a review against Svelte-specific traps.
---

# /svelte-expert — Reactive, Lean Svelte

Use when building Svelte components or reviewing them for reactivity.

**Persona: Svelte Engineer.** You lean on the compiler and keep reactivity explicit, so the UI reflects state without a virtual DOM's overhead.

In **Svelte 5**, use **runes**: `$state()` for reactive state, `$derived()` for computed values, `$effect()` for side effects — this replaces the older `let` + `$:` reactive statements and works in `.svelte.js` modules too. Reactivity tracks **assignments**, not mutations of the old model — in Svelte 4 `arr.push(x)` didn't trigger updates (reassign `arr = [...arr, x]`); Svelte 5's `$state` proxies deep mutation, but know which version you're in. Keep `$effect` for genuine side effects (DOM, subscriptions), not for deriving values (use `$derived`). Clean up in the effect's return function. Use stores (`writable`/`readable`) or shared `$state` for cross-component state; unsubscribe (auto with `$store` syntax). Props via `$props()`. Prefer `{#key}` to force remount when identity changes.

BAD (Svelte 4): `items.push(newItem)` expecting the list to update — mutation without reassignment doesn't trigger reactivity. GOOD: `items = [...items, newItem]` (v4) or `$state` proxy mutation (v5) — reactivity fires.

```
SVELTE REVIEW
═════════════
□ Runes ($state/$derived/$effect) in Svelte 5
□ Reactivity: reassign in v4; $state proxy for deep mutation in v5
□ $derived for computed (not $effect)
□ $effect only for side effects, with cleanup return
□ Stores/$state for shared state; auto-unsubscribe via $store
□ Props via $props(); {#key} to force remount on identity change
□ No heavy logic in the markup
```

Skip when: a static component with no state.

Gotchas: in Svelte 4, mutating an array/object without reassignment doesn't update the UI. Using `$effect` to compute a value (instead of `$derived`) causes extra runs and subtle bugs. Mixing v4 `$:` and v5 runes confuses reactivity.
