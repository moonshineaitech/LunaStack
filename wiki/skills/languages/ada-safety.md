---
name: ada-safety
description: Use when writing or reviewing Ada/SPARK for safety-critical systems and you want to exploit its strong typing and contracts. Produces a review against Ada-specific traps and toward provable safety.
---

# /ada-safety — Safety-Critical Ada/SPARK

Use when writing Ada for systems where a bug is a safety hazard.

**Persona: Safety-Critical Engineer.** You let Ada's type system and contracts catch at compile time what other languages discover in the field.

Exploit **strong, specific types**: define constrained subtypes and range types (`subtype Percent is Integer range 0 .. 100;`) so out-of-range values are rejected at compile time or raise `Constraint_Error` at runtime rather than corrupting state. Ada is **strongly typed with no implicit conversions** — that verbosity is the point; don't fight it with `Unchecked_Conversion` except at genuine hardware boundaries. Use **contracts** (`Pre`, `Post`, `Type_Invariant`) to state and check obligations; in **SPARK** these become *provable* — run the prover to verify absence of runtime errors. Avoid dynamic allocation in hard-real-time/certified code (or use controlled types + storage pools). Handle exceptions explicitly. Use `pragma` and coding standards (MISRA-Ada/Ravenscar for tasking) per the domain's certification requirements.

BAD: using a plain `Integer` for an angle and letting it wrap past 360 silently, feeding a bad value to a control surface. GOOD: `subtype Degrees is Integer range 0 .. 359;` — an out-of-range assignment raises `Constraint_Error` immediately, at the source of the fault.

```
ADA/SPARK REVIEW
════════════════
□ Constrained subtypes/ranges encode valid values (compile/runtime checked)
□ No implicit conversions; Unchecked_Conversion only at hardware boundaries
□ Contracts (Pre/Post/Type_Invariant) state obligations
□ SPARK prover run for provable absence of runtime errors (where used)
□ Dynamic allocation avoided/controlled in certified code
□ Exceptions handled explicitly
□ Ravenscar/coding standard per certification domain
```

Skip when: non-critical general-purpose code where Ada's rigor isn't required.

Gotchas: reaching for `Unchecked_Conversion` to bypass the type system throws away Ada's main benefit. Unconstrained numeric types allow the very out-of-range bugs subtypes prevent. Dynamic allocation undermines certification and real-time guarantees.
