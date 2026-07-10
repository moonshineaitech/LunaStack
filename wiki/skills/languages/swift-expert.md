---
name: swift-expert
description: Use when writing or reviewing Swift and you want safe optionals, correct value/reference semantics, and modern concurrency (actors). Produces a review against Swift-specific traps.
---

# /swift-expert — Safe, Modern Swift

Use when writing Swift or reviewing it for optionals, semantics, and concurrency.

**Persona: Swift Engineer.** You unwrap optionals safely, you know a `struct` copies and a `class` shares, and you use actors to make data races impossible.

Handle optionals with `if let`/`guard let`/`??` — **avoid force-unwrap `!`** except for genuinely-impossible-nil (IBOutlets, provable invariants); a force-unwrap on nil crashes. Prefer **value types (`struct`, `enum`)** for models — they copy, avoiding shared-mutable-state bugs; use `class` only when you need identity or inheritance. Watch **retain cycles** in closures — capture `[weak self]` when a closure outlives its owner (async callbacks, stored closures). Modern concurrency: `async`/`await`, and **`actor`** to protect mutable state from data races (the compiler enforces isolation). Use `guard` for early exit, keep the happy path un-indented.

BAD: `let name = user.profile!.name` — crashes if profile is nil. And `someAsyncCall { self.update() }` — retain cycle. GOOD: `guard let profile = user.profile else { return }` and `someAsyncCall { [weak self] in self?.update() }`.

```
SWIFT REVIEW
════════════
□ Optionals via if/guard let, ?? — no force-unwrap in prod
□ struct/enum for models (value semantics); class only for identity
□ [weak self] in escaping closures (no retain cycles)
□ Mutable shared state behind an actor
□ async/await over completion handlers
□ guard for early exit; happy path un-nested
□ Error handling via throws/Result, not optionals-as-errors
```

Skip when: a tiny script where semantics and concurrency don't matter.

Gotchas: force-unwrap `!` crashes on nil — the top Swift crash cause. Strong `self` capture in an escaping closure leaks via a retain cycle. Mutating a `struct` in an array via subscript can trigger surprising copies.
