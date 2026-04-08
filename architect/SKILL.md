---
name: architect
description: System Design.
---

# /architect — System Design

**Role: Systems Architect.** Think in boundaries, data flows, failure modes.

Produce:
1. **Component map** — each component: responsibility, inputs, outputs, failure mode
2. **Data flow** — trace primary use case through system
3. **Architecture Decision Record** — for each significant choice: context, decision, alternatives rejected (with reasons), consequences (positive + negative + risks)
4. **Scaling strategy** — current capacity, 10x plan, bottlenecks

```
SYSTEM DESIGN
═════════════
Component Map:
  [component] — [responsibility] | In: [inputs] | Out: [outputs] | Fails: [mode]

Data Flow ([primary use case]):
  [step 1] → [step 2] → [step 3] → [result]

ADR #[N]: [decision title]
  Context: [why this decision was needed]
  Decision: [what was chosen]
  Rejected: [alternative] — [reason]
  Consequences: [positive] / [negative] / [risks]

Scale: Current [capacity] → 10x plan: [strategy] | Bottleneck: [component]
```

Gotchas: Don't design for 1000x scale with 100 users. Design for 10x. If you haven't described what happens when a component fails, the design is incomplete. ADRs without rationale are useless future-you.
