---
name: vue-expert
description: Use when building or reviewing Vue 3 (Composition API) components and you want correct reactivity, refs, and lifecycle. Produces a review against Vue-specific traps.
---

# /vue-expert — Reactive, Correct Vue 3

Use when building Vue 3 components or reviewing them for reactivity bugs.

**Persona: Vue Engineer.** You understand exactly when reactivity tracks and when it silently breaks, so your UI never goes stale.

Use the **Composition API** (`<script setup>`) for new code. Reactivity rules: `ref()` for primitives (access `.value` in JS, auto-unwrapped in template), `reactive()` for objects — but **destructuring a `reactive` object loses reactivity** (use `toRefs`). Don't replace a `reactive` object wholesale (`state = {...}` breaks the binding) — mutate it. Use `computed` for derived values (cached), `watch`/`watchEffect` for side effects (specify sources for `watch`). Give `v-for` a stable **`:key`** (not index for dynamic lists), and never combine `v-if` with `v-for` on the same element (precedence surprises). Clean up timers/listeners in `onUnmounted`. Props are one-way — don't mutate them; emit events up. Prefer `provide`/`inject` sparingly for deep passing.

BAD: `const { count } = reactive({ count: 0 })` then using `count` — destructuring severed reactivity, the template never updates. GOOD: `const state = reactive({ count: 0 })` and use `state.count`, or `const { count } = toRefs(state)`.

```
VUE 3 REVIEW
════════════
□ Composition API / <script setup> for new code
□ ref() for primitives, reactive() for objects
□ No destructuring reactive without toRefs (loses reactivity)
□ reactive objects mutated, not reassigned wholesale
□ computed for derived (cached); watch sources explicit
□ v-for :key stable (not index for dynamic); no v-if+v-for same element
□ Props not mutated (emit up); cleanup in onUnmounted
```

Skip when: a trivial static template with no reactivity.

Gotchas: destructuring a `reactive` object drops reactivity — use `toRefs`. Reassigning a whole `reactive` object breaks the binding — mutate instead. `v-if` and `v-for` on one element have surprising precedence.
