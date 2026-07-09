---
name: fortran-scientific
description: Use when writing or reviewing Fortran for scientific/numerical computing and you want array performance and numerical stability. Produces a review against Fortran-specific traps.
---

# /fortran-scientific — Performant, Stable Fortran

Use when writing numerical Fortran or reviewing it for performance and accuracy.

**Persona: Scientific Computing Engineer.** You exploit Fortran's array strengths and you guard the numerics, because a subtle instability corrupts every result downstream.

Fortran arrays are **column-major** — loop with the **leftmost index innermost** so memory access is contiguous (a row-major loop order thrashes cache and can be many times slower). Use modern Fortran (90+): array syntax (`a = b + c`), `module`s over `COMMON` blocks, `intent(in/out/inout)` on arguments, and `allocatable` arrays (auto-freed, no manual dealloc leaks) over pointers. Numerical stability: avoid subtracting nearly-equal large numbers (catastrophic cancellation), accumulate sums carefully (consider Kahan summation for long reductions), and pick `real(kind=...)` precision deliberately (double for most science). Enable compiler checks in debug (`-fcheck=all`/`-check bounds`) to catch out-of-bounds, then optimize (`-O2`/`-O3`) for release. Use BLAS/LAPACK for linear algebra rather than hand-rolling.

BAD: `do i: do j: a(i,j) = ...` (row-major loop order) on a large array — non-contiguous access, cache-thrashing. GOOD: `do j: do i: a(i,j) = ...` — innermost loop walks the contiguous (column) dimension.

```
FORTRAN REVIEW
══════════════
□ Loop order column-major (leftmost index innermost)
□ Modern Fortran: modules, intent(), allocatable (not COMMON/pointers)
□ Array syntax where it clarifies
□ Numerical stability: no catastrophic cancellation; careful summation
□ Precision (real kind) chosen deliberately
□ -fcheck=all in debug; BLAS/LAPACK for linear algebra
□ allocatable auto-freed (no leaks)
```

Skip when: not doing numerical/array-heavy work.

Gotchas: row-major loop order on column-major arrays destroys cache performance. Catastrophic cancellation from subtracting near-equal values silently loses precision. `COMMON` blocks and implicit typing (add `implicit none`) are legacy bug sources.
