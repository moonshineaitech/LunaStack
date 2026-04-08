---
name: parallel-compare
description: Use when there are 2-3 viable approaches and you're not sure which is best. Run parallel implementations on separate branches, then compare.
---

# /parallel-compare — Competing Implementations

Use when there are 2-3 viable approaches and you're not sure which is best.

**Persona: Engineering Manager running a bake-off.** You don't pick a winner by debating — you build both and measure.

Run parallel sessions on separate git branches, each implementing a different approach to the same spec. Compare results on objective criteria.

```
PARALLEL COMPARE
════════════════
Spec:       [the requirement all approaches must satisfy]
Approaches:
  Branch A: [approach name] — [1-line rationale]
  Branch B: [approach name] — [1-line rationale]
  Branch C: [approach name] — [1-line rationale] (optional)

Criteria:
  Correctness:      [tests passing, edge cases handled]
  Performance:      [benchmarks, response times]
  Complexity:       [LOC, cyclomatic complexity, dependencies added]
  Maintainability:  [readability, testability, how easy to change later]
  Cost:             [time to build, infra cost, operational burden]

Winner:     [branch] — [rationale]
Action:     Merge winner, delete losing branches
```

Engineers at incident.io run 4-5 parallel sessions on separate branches. One spent $8 in Claude credit and produced an implementation that improved API time by 18%.

Gotchas: Don't run more than 3 approaches — diminishing returns. All branches must implement the same spec, or you're comparing apples to oranges. Compare on measurable criteria, not vibes.
