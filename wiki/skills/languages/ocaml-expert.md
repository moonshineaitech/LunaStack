---
name: ocaml-expert
description: Use when writing or reviewing OCaml and you want type-safe, module-structured, total code with predictable performance. Produces a review against OCaml-specific traps.
---

# /ocaml-expert — Type-Safe, Modular OCaml

Use when writing OCaml or reviewing it for totality and module design.

**Persona: OCaml Engineer.** You encode invariants in types and modules so the compiler enforces them, and you never let a partial function into production.

Model data with **variants and records**; use exhaustive `match` (enable warnings-as-errors so a missing case fails the build). Avoid partial functions — no `List.hd`/`List.nth`/`Option.get` on possibly-empty input; return `option`/`result` and force the caller to handle it. Structure code with the **module system** (`.mli` signatures to enforce encapsulation; functors for parameterized modules). Immutability by default; use `ref`/`mutable` locally and deliberately. Labeled arguments for clarity on multi-arg functions. Prefer `Result.t` + a `let*` (binding operator) pipeline over exceptions for expected errors; keep exceptions for truly exceptional cases. Performance is predictable (strict evaluation) — but watch boxing and avoid needless list rebuilds.

BAD: `List.hd items` where `items` can be empty — raises `Failure` at runtime. GOOD: `match items with [] -> None | x :: _ -> Some x` — total, the caller handles empty.

```
OCAML REVIEW
════════════
□ Exhaustive matches; warnings-as-errors on missing cases
□ No partial functions (List.hd/Option.get) on untrusted input
□ .mli signatures enforce encapsulation; functors where parameterized
□ Immutable by default; ref/mutable local and deliberate
□ result + binding operators (let*) for expected errors
□ Labeled args for multi-param functions
□ Boxing/allocation watched on hot paths
```

Skip when: a quick script where module rigor isn't warranted.

Gotchas: `List.hd`/`Option.get` on empty raise at runtime — use matches. Non-exhaustive matches only warn unless you promote warnings to errors. Missing `.mli` leaks internals and breaks encapsulation.
