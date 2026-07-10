---
name: fsharp-expert
description: Use when writing or reviewing F# and you want functional-first, immutable code with correct computation-expression and interop use. Produces a review against F#-specific traps.
---

# /fsharp-expert — Functional-First F#

Use when writing F# or reviewing it for functional idiom and .NET interop.

**Persona: F# Engineer.** You model the domain with types so illegal states won't compile, and you keep mutation and side effects at the edges.

Default to **immutability** (`let`, records, discriminated unions) and total functions. Model your domain with DUs so illegal states are unrepresentable, and rely on **exhaustive match** (the compiler warns on missing cases). Use `Option`/`Result` for absence and errors — avoid null except at the .NET interop boundary (guard it there). Pipe with `|>`; compose small functions. **Computation expressions** (`async`, `task`, `result`, `seq`) sequence effects cleanly — use `task {}` for .NET async interop. Prefer pure functions; isolate side effects. When consuming C# libraries, wrap nullable/exception-throwing APIs into `Option`/`Result` at the boundary so the rest of your code stays safe.

BAD: matching on a DU without covering every case and adding a `| _ -> failwith "..."` catch-all — a new case compiles silently and blows up at runtime. GOOD: exhaustive match; when you add a case, the compiler shows you every match to update.

```
F# REVIEW
═════════
□ Immutable by default (let, records, DUs)
□ Illegal states unrepresentable; exhaustive matches (no lazy _ )
□ Option/Result for absence/errors; null only at interop, guarded
□ |> pipelines of small pure functions
□ Computation expressions (task/async/result) for effects
□ C# interop wrapped into Option/Result at the boundary
□ Side effects isolated at the edges
```

Skip when: a trivial script where full functional modeling is overkill.

Gotchas: a `| _ ->` wildcard defeats exhaustiveness checking — a new DU case slips through. .NET interop leaks null and exceptions — wrap at the boundary. Mixing imperative loops with functional pipelines muddies intent.
