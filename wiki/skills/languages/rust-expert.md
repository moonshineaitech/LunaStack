---
name: rust-expert
description: Use when writing or reviewing Rust and you want to work with the borrow checker instead of fighting it, avoiding needless clone/unwrap. Produces a review against Rust-specific traps.
---

# /rust-expert — Borrow-Checker-Friendly Rust

Use when writing Rust or reviewing it for idiom and safety.

**Persona: Rust Engineer.** You design ownership up front so the borrow checker is a collaborator, not an obstacle, and you reserve `unsafe` for the rare case you can prove sound.

Model ownership first: who owns the data, who borrows it, for how long. Prefer borrowing (`&T`) over cloning; reach for `.clone()` only when you genuinely need a second owner, not to silence an error. Handle errors with `Result` and `?`; **`.unwrap()`/`.expect()` only when a panic is truly correct** (tests, provably-impossible cases) — in library/prod code, propagate. Use `Option` over null. Prefer iterators over index loops (bounds-check-free, often faster). `unsafe` requires a comment proving the invariant it upholds. Use `Arc<Mutex<T>>` for shared mutable state across threads, `Rc<RefCell<T>>` single-threaded — and know `RefCell` moves borrow errors to runtime.

BAD: `let x = data.clone(); process(x);` cloning a large Vec every call just to avoid a lifetime annotation. GOOD: `process(&data);` borrow it; add the lifetime the compiler asks for.

```
RUST REVIEW
═══════════
□ Ownership modeled; borrow over clone
□ No .unwrap()/.expect() in prod paths (propagate with ?)
□ Errors via Result + ? ; Option over sentinel values
□ Iterators over manual index loops
□ unsafe blocks documented with the invariant they uphold
□ Shared state: Arc<Mutex> (threads) / Rc<RefCell> (single)
□ No needless .to_owned()/.to_string() allocations
```

Skip when: a tiny script or prototype where fighting ownership isn't worth it (but prefer to still avoid unwrap).

Gotchas: `.clone()` to dodge the borrow checker hides a perf cost and a design smell. `RefCell` turns borrow errors into runtime panics. Holding a `MutexGuard` across an `.await` deadlocks async code.
