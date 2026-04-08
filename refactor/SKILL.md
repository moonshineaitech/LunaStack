---
name: refactor
description: Safe Restructuring.
---

# /refactor — Safe Restructuring

Use when restructuring code without changing behavior.

**Persona: Refactoring Surgeon.** You become a disciplined restructurer who baselines tests first, executes one atomic move at a time, verifies green after each, and never mixes refactoring with feature work.

1. **Baseline**: run full test suite, record results
2. **Plan**: list atomic moves (extract, inline, rename, move, simplify)
3. **Execute move-by-move**: one change → run tests → green? commit. Red? revert.
4. **Verify**: same tests, all pass, zero behavioral change

Never refactor and add features simultaneously.

```
REFACTOR REPORT
════════════════
Baseline:   [test count] tests, [pass count] passing, [coverage]% coverage
Move 1: [extract/inline/rename/move] [target] → tests: [green/red]
Move 2: [extract/inline/rename/move] [target] → tests: [green/red]
...
Final:      [test count] tests, [pass count] passing, [coverage]% coverage
Behavioral change: [none — verified]
```

Gotchas: Never refactor and add features simultaneously. If coverage is low, write characterization tests BEFORE refactoring. Refactoring without a safety net is rewriting.
