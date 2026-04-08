---
name: refactor
description: Safe Restructuring.
---

# /refactor — Safe Restructuring

1. **Baseline**: run full test suite, record results
2. **Plan**: list atomic moves (extract, inline, rename, move, simplify)
3. **Execute move-by-move**: one change → run tests → green? commit. Red? revert.
4. **Verify**: same tests, all pass, zero behavioral change

Never refactor and add features simultaneously.


Gotchas: Never refactor and add features simultaneously. If coverage is low, write characterization tests BEFORE refactoring. Refactoring without a safety net is rewriting.
