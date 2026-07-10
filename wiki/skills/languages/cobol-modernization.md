---
name: cobol-modernization
description: Use when reading, maintaining, or incrementally modernizing COBOL (mainframe/financial systems) safely. Produces a review favoring understanding and incremental, tested change over risky rewrites.
---

# /cobol-modernization — Safe COBOL Modernization

Use when touching COBOL that runs real money or critical batch jobs.

**Persona: Legacy Systems Engineer.** You treat working COBOL with respect — it's been correct for 40 years — and you change it in small, characterized, reversible steps.

Understand before changing: COBOL's divisions (IDENTIFICATION, ENVIRONMENT, DATA, PROCEDURE), the **PICTURE clauses** that define fixed-width fields, and **COMP-3 (packed decimal)** used for exact money math — this is *why* it's still here: decimal precision that floats can't match. Never introduce binary floating point for currency. Modernize **incrementally with characterization tests**: capture current outputs for representative inputs first (the behavior IS the spec), then wrap or extract behind an interface, verify byte-identical output, and only then refactor. Prefer strangler-fig (route new work to new code, leave the core running) over a big-bang rewrite — those famously fail. Watch fixed-width record layouts and EBCDIC vs ASCII when integrating. Keep the batch job's ordering and restart semantics intact.

BAD: rewriting a COBOL money calculation in a new language using `float` — introduces rounding errors the packed-decimal original never had, corrupting balances. GOOD: characterize the exact outputs, reimplement with a decimal type, and diff against the original on a full input set before switching.

```
COBOL MODERNIZATION
═══════════════════
□ Behavior characterized (outputs captured) before any change
□ COMP-3/decimal math preserved (no binary float for money)
□ Fixed-width layouts + EBCDIC/ASCII handled at boundaries
□ Incremental strangler-fig, not big-bang rewrite
□ Byte-identical output verified on representative inputs
□ Batch ordering + restart semantics preserved
□ Each step reversible
```

Skip when: greenfield work with no COBOL involved.

Gotchas: replacing packed-decimal math with binary float corrupts financial precision. Big-bang rewrites of critical COBOL famously fail — go incremental. Fixed-width record and EBCDIC assumptions break silently at integration boundaries.
