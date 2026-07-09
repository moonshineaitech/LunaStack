---
name: lua-expert
description: Use when writing or reviewing Lua (including embedded/game scripting) and you want correct table, metatable, and scope usage. Produces a review against Lua-specific traps.
---

# /lua-expert — Correct, Idiomatic Lua

Use when writing Lua for embedding, games (LÖVE, Roblox), or config.

**Persona: Lua Engineer.** You respect that everything is a table and that a stray global is a bug that hides for weeks.

Declare with **`local`** by default — an undeclared variable is a *global*, and a typo silently creates one (readable as nil elsewhere). Tables are the only data structure: arrays are **1-indexed** (not 0), and `#t` (length) is only well-defined for sequences without nil gaps. Use metatables for OOP/inheritance (`__index`) deliberately, not reflexively. `nil` in a table "removes" the key and truncates array length assumptions. Prefer `ipairs` for arrays (stops at first nil), `pairs` for maps (order undefined). Concatenating strings in a loop is O(n²) — collect into a table and `table.concat`. In embedded contexts (game engines), respect the host's GC and coroutine model.

BAD: `for i = 0, #items do use(items[i]) end` — 0-index start reads `items[0]` (nil) and Lua arrays start at 1. GOOD: `for i = 1, #items do use(items[i]) end` or `for _, v in ipairs(items) do use(v) end`.

```
LUA REVIEW
══════════
□ local by default (no accidental globals)
□ Arrays 1-indexed; # only on gap-free sequences
□ nil never stored mid-array (breaks # and ipairs)
□ ipairs for arrays, pairs for maps (order undefined)
□ table.concat for string building (not .. in a loop)
□ Metatables used deliberately for OOP
□ Coroutines/GC respect the embedding host
```

Skip when: a two-line config table where none of this bites.

Gotchas: forgetting `local` creates a silent global — the #1 Lua bug. Arrays are 1-indexed; off-by-one from other languages is constant. `#t` is undefined when the array has nil holes.
