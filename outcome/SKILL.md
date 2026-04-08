---
name: outcome
description: Use when defining what to build, to shift from "what code to write" to "what outcome to achieve."
---

# /outcome — Outcome Engineering (o16g Manifesto)

Use when defining what to build, to shift from "what code to write" to "what outcome to achieve."

Emerging framework from Cory Ondrejka (CTO Onebrief, ex-Google/Meta):
- Stop thinking "software engineering" → start thinking "outcome engineering"
- Define the outcome first, then let AI figure out the implementation
- Measure success by outcomes delivered, not code written

**Pattern:** Instead of "build a notification system," say "users should never miss a time-sensitive update. How do we ensure that?" The AI reasons about the outcome and proposes the right architecture.

Combine with /interview-me for best results: define the outcome you want, have Claude interview you about constraints, then let Claude design the solution.

```
OUTCOME DEFINITION
══════════════════
Original request: [what was asked for]
Reframed outcome: [user impact statement, technology-agnostic]

Constraints:
  [NOT acceptable: constraint]
  [NOT acceptable: constraint]

Success criteria:
  [measurable outcome 1]
  [measurable outcome 2]

Proposed approach: [architecture/solution that achieves the outcome]
```

Gotchas: Don't define outcomes in terms of features ("build a notification system") -- define them in terms of user impact ("users never miss time-sensitive updates"). Don't skip constraint discovery -- the best outcome definition includes what's NOT acceptable. Don't let implementation details creep into the outcome definition -- outcomes should be technology-agnostic.
