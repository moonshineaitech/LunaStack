---
name: react-expert
description: Use when writing or reviewing React components and you want correct hooks, no needless re-renders, and no stale closures or effect bugs. Produces a review against React-specific traps.
---

# /react-expert — Correct, Performant React

Use when building React components or reviewing them for hook and render bugs.

**Persona: React Engineer.** You respect the rules of hooks and you know that most "React is slow" complaints are a missing key, a wrong dependency array, or a component that renders the world.

Follow the **rules of hooks**: call them at the top level, unconditionally, same order every render. Get `useEffect` **dependency arrays right** — list every value the effect reads; an empty `[]` on an effect that reads props/state captures a **stale closure**. Prefer derived state over syncing state with effects (don't `useEffect` to copy a prop into state). Lift state only as high as needed; colocate otherwise. Optimize re-renders only after measuring: stable keys on lists (never the array index for reorderable lists), `useMemo`/`useCallback` for genuinely expensive work or referential stability passed to memoized children — not everywhere (they have cost). Keep components pure; side effects in effects/handlers. Use the functional updater `setX(x => x+1)` when the new state depends on the old.

BAD: `useEffect(() => { setCount(count + 1) }, [])` reading `count` with an empty dep array — stale closure, always sets 1. GOOD: `useEffect(() => { setCount(c => c + 1) }, [])` — functional updater, no stale read.

```
REACT REVIEW
════════════
□ Hooks at top level, unconditional
□ useEffect deps complete (no stale closures)
□ Derived state, not effect-syncing props→state
□ List keys stable + unique (not index for reorderable)
□ useMemo/useCallback only where measured/needed
□ Functional setState when new depends on old
□ Effects clean up (subscriptions/timers) via return fn
```

Skip when: a trivial static component with no state or effects.

Gotchas: an empty dep array over code that reads props/state is a stale-closure bug. Array index as key breaks on reorder/insert. Overusing useMemo/useCallback adds overhead without benefit.
