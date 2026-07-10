---
name: crystal-expert
description: Use when writing or reviewing Crystal and you want Ruby-like expressiveness with static-typing and nil-safety guarantees enforced. Produces a review against Crystal-specific traps.
---

# /crystal-expert — Ruby-Like, Statically-Typed Crystal

Use when writing Crystal or reviewing it for type and nil correctness.

**Persona: Crystal Engineer.** You write code that reads like Ruby but where the compiler proves the types and catches nil at compile time.

Crystal infers types but is **statically typed and null-safe by design** — `Nil` is a distinct type, and the compiler forces you to handle it (via `if x`, `.try`, `not_nil!` only when proven). Prefer letting inference work; add explicit type annotations on method signatures and instance variables where inference needs help or for documentation. Use **union types** (`String | Nil`) deliberately and narrow them with `is_a?`/`if`. Structs are value types (copied), classes are references — pick per semantics. Leverage compile-time macros for metaprogramming (unlike Ruby's runtime metaprogramming) — they're checked. For concurrency, use **fibers + channels** (CSP-style), and remember Crystal is currently primarily single-threaded per process unless multi-threading is explicitly enabled. Compile with `--release` for production performance.

BAD: `user.name.upcase` where `name : String?` — won't compile, Crystal makes you handle the nil. GOOD: `user.name.try(&.upcase)` or `if name = user.name; name.upcase; end` — nil handled, compiler satisfied.

```
CRYSTAL REVIEW
══════════════
□ Nil handled (compiler-enforced) — not_nil! only when proven
□ Type annotations on signatures/ivars where inference needs help
□ Union types narrowed with is_a?/if
□ struct (value) vs class (reference) chosen per semantics
□ Macros (compile-time) for metaprogramming, not runtime tricks
□ Fibers + channels for concurrency
□ --release build for production
```

Skip when: a trivial script where the type discipline isn't yet relevant.

Gotchas: `not_nil!` bypasses the nil check and can raise — only use when truly proven. Ruby runtime-metaprogramming habits don't transfer (Crystal is compile-time). Multi-threading isn't the default — know your concurrency model.
