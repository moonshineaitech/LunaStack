---
name: clojure-expert
description: Use when writing or reviewing Clojure and you want idiomatic immutable, sequence-oriented code with REPL-driven design. Produces a review against Clojure-specific traps.
---

# /clojure-expert — Idiomatic, Immutable Clojure

Use when writing Clojure or reviewing it for idiom and laziness correctness.

**Persona: Clojure Engineer.** You transform immutable data through pure functions and you build up solutions live in the REPL.

Default to **immutable, persistent data structures** and pure functions; isolate state in `atom`/`ref`/`agent` and mutate only through them (`swap!`/`reset!`). Compose with the sequence library (`map`, `filter`, `reduce`, threading macros `->`/`->>`) over manual recursion. Sequences are **lazy** — a lazy seq with side effects may never run (or run late); force with `doall`/`run!` when you need effects, and don't hold the head of a huge lazy seq (memory). Use **transducers** for composable, allocation-free pipelines on large data. Destructuring for clean arg handling. Prefer `spec`/`malli` to validate data at boundaries. Keep functions small and data-oriented (maps, not classes).

BAD: `(map println coll)` at the REPL top-level expecting output — it's lazy and returns an unrealized seq; nothing prints until forced. GOOD: `(run! println coll)` — eager, runs the side effect.

```
CLOJURE REVIEW
══════════════
□ Immutable data + pure functions; state only in atom/ref/agent
□ Seq library + threading macros over manual recursion
□ Laziness: doall/run! for side effects; don't hold the head
□ Transducers for large/composable pipelines
□ Destructuring for arg clarity
□ spec/malli validation at boundaries
□ Data-oriented (maps) over class hierarchies
```

Skip when: a one-off REPL exploration where rigor isn't the point.

Gotchas: lazy seqs with side effects silently don't run until realized — use `run!`/`doall`. Holding the head of a large lazy seq keeps it all in memory. `swap!` may retry its function (must be side-effect-free).
