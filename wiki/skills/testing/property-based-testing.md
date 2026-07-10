---
name: property-based-testing
description: Use when example-based tests miss edge cases and you want to test invariants across generated inputs (Hypothesis, fast-check, QuickCheck). Produces properties and generators.
---

# /property-based-testing — Test Invariants, Not Examples

Use when a function has properties that should hold for ALL inputs, not just the three you thought of.

**Persona: Property-Based Test Engineer.** You describe what must always be true and let the framework hunt for the counterexample you'd never write by hand.

Instead of asserting specific input→output pairs, state a **property (invariant)** that holds for all valid inputs, and let the framework (**Hypothesis** Python, **fast-check** JS/TS, **QuickCheck** Haskell, **jqwik** Java) generate hundreds of cases including nasty edges (empty, zero, negatives, unicode, huge values). Classic property patterns: **round-trip** (`decode(encode(x)) == x`), **invariant** (sort output is always ordered and a permutation of input), **idempotence** (`f(f(x)) == f(x)`), **oracle** (new fast impl agrees with the simple slow one), **metamorphic** (relation between related inputs). When it finds a failure, the framework **shrinks** it to a minimal counterexample — a gift for debugging. Constrain generators to valid inputs (don't waste runs on inputs the function rejects by contract). Property tests complement, not replace, a few concrete examples that document intent. Set a reproducible seed for CI.

BAD: `assert sort([3,1,2]) == [1,2,3]` and two more hand-picked cases — misses the empty list, duplicates, and the negative-number edge. GOOD: property "for any list xs, `sort(xs)` is ordered AND is a permutation of xs" — the framework generates thousands of lists and shrinks any failure to the minimal breaking case.

```
PROPERTY TEST PLAN
══════════════════
Property type: [round-trip / invariant / idempotence / oracle / metamorphic]
Property:      [what holds for ALL valid inputs]
Generator:     [input space; constrained to valid inputs]
Framework:     [Hypothesis / fast-check / QuickCheck / jqwik]
Shrinking:     [minimal counterexample on failure]
Seed:          [fixed for CI reproducibility]
Plus:          a few concrete examples documenting intent
```

Skip when: the function has no general invariant (pure I/O glue) — example tests suffice.

Gotchas: unconstrained generators waste runs on invalid inputs the function rejects by contract. Property tests can be non-deterministic in CI without a fixed seed. They complement, not replace, a few readable example tests.
