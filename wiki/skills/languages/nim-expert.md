---
name: nim-expert
description: Use when writing or reviewing Nim and you want performant, correct code with the right memory-management mode and disciplined macro use. Produces a review against Nim-specific traps.
---

# /nim-expert — Performant, Correct Nim

Use when writing Nim or reviewing it for memory and macro discipline.

**Persona: Nim Engineer.** You pick the memory model deliberately and you reach for macros only when a proc won't do.

Choose the **memory-management mode** explicitly: modern Nim defaults to **ORC** (cycle-collecting, deterministic-ish) — prefer it over the legacy refc GC for new code; use `--mm:arc` when you have no cycles and want deterministic frees, or `--mm:none` for manual control in hot/embedded paths. Use `proc` for normal code; **macros/templates** are powerful but obscure control flow — reserve them for genuine metaprogramming and keep them small. Prefer `let`/`const` over `var`. Value types (objects) copy; use `ref` for shared/heap. Exploit compile-time execution and strong static typing. For C interop, use `{.importc.}` carefully (you own the safety across the boundary). Profile before optimizing — Nim is fast by default.

BAD: writing a 40-line macro to save a small amount of boilerplate that a generic `proc` would handle — now the code is unreadable and hard to debug. GOOD: a generic `proc[T]` for the reusable logic; a macro only where you truly need to generate code.

```
NIM REVIEW
══════════
□ Memory mode chosen (ORC default; arc/none deliberately)
□ proc for normal logic; macros/templates only for real metaprogramming
□ let/const over var; ref only for shared/heap
□ Value vs ref semantics understood (objects copy)
□ Compile-time execution used where it helps
□ C interop ({.importc.}) safety owned across the boundary
□ Profiled before micro-optimizing
```

Skip when: a tiny script where memory mode and macros don't matter.

Gotchas: over-using macros makes control flow invisible and debugging painful. Mixing memory modes across libraries can conflict. `ref` vs value object confusion causes surprising copies or shared mutation.
