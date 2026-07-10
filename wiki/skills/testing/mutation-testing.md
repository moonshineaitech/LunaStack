---
name: mutation-testing
description: Use when you want to know if your tests actually catch bugs, not just cover lines. Runs mutation testing (Stryker/mutmut/PIT) and interprets the mutation score. Produces a review of test effectiveness.
---

# /mutation-testing — Are Your Tests Real?

Use when coverage is high but you suspect the tests don't actually assert much.

**Persona: Test Effectiveness Engineer.** You know line coverage lies — it proves code *ran*, not that a bug would be *caught* — so you measure whether tests kill mutants.

Mutation testing deliberately introduces small faults (**mutants**: flip `>` to `>=`, `+` to `-`, remove a statement, negate a condition) and reruns the suite. If a test fails, the mutant is **killed** (good — the test caught the bug). If all tests still pass, the mutant **survived** — meaning that code could be broken and no test would notice. The **mutation score** (killed / total) is a far truer signal than line coverage: 90% line coverage with a 40% mutation score means the tests execute the code but don't assert on its behavior. Use Stryker (JS/TS/C#), mutmut/cosmic-ray (Python), PIT (Java). Target the critical modules (it's slow — don't mutate the whole repo every CI run; run it on changed/critical code). Investigate **surviving mutants** — each is a missing assertion or a redundant line. Aim for a high score on core logic (**>80%** on critical paths); don't chase 100% (equivalent mutants exist).

BAD: celebrating 95% line coverage while every test just calls the function and asserts it "doesn't throw" — mutation score reveals 30%, the tests catch almost nothing. GOOD: run Stryker on the billing module, find 12 surviving mutants, add the missing assertions that kill them.

```
MUTATION TEST REVIEW
════════════════════
Tool:          [Stryker/mutmut/PIT]
Scope:         [critical modules — not whole repo per run]
Mutation score:[killed/total %] vs line coverage [%]
Surviving mutants: [count] → each = missing assertion / dead code
Target:        >80% on critical paths (not 100% — equivalent mutants)
Action:        [assertions to add per surviving mutant]
```

Skip when: the codebase has no meaningful test suite yet — write tests first, then measure their quality.

Gotchas: line coverage proves execution, not assertion — mutation score is the real signal. Mutating the whole repo every CI run is too slow; scope to critical/changed code. Some surviving mutants are "equivalent" (no behavioral change) — don't chase 100%.
