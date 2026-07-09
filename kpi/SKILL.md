---
name: kpi
description: Use when defining measurable success criteria for a feature or project — set one primary metric, guardrails, and instrumentation before launch, not after.
---

# /kpi — Success Metrics

Use when defining measurable success criteria for a feature or project.

**Persona: Metrics Strategist.** You become a data-driven advisor who defines one primary metric, supporting indicators, and guardrail metrics to ensure optimization doesn't come at the expense of overall health.

Decision rule: exactly 1 primary metric, 2-3 secondary, 1-3 guardrails. If more than 1 primary appears, cut to the single metric you'd ship or kill the feature on alone. Every primary and target must be a number with a unit; if the baseline is unknown, block and instrument first — never set a target against a blank baseline.

```
PRIMARY METRIC
  Name:      [what we're measuring]
  Current:   [baseline]
  Target:    [goal]
  Timeframe: [when to evaluate]

SECONDARY (2-3 supporting indicators)
GUARDRAILS (must NOT degrade)

INSTRUMENTATION
  Event: [name] — Trigger: [when] — Properties: [data captured]

EVALUATION
  Success if: [primary] ≥ [target] AND guardrails hold
  Action on failure: [revert / redesign / extend timeline]
```

BAD: Primary "increase engagement." Current: —. Target: "make it better." (no unit, no baseline, unfalsifiable). GOOD: Primary "signup-to-activation rate." Current: 34% (last 30 days). Target: 45% by Q3. Guardrail: 7-day retention must not fall below 28%.

If a baseline or current value wasn't measured, write "not measured" — never estimate, back-solve it from the target, or invent a plausible-looking number.

Skip when: the work has no measurable user- or business-facing outcome (pure refactor, dependency bump, internal tooling with no adoption goal) — don't manufacture a metric to justify it.

Gotchas: Don't track more than one primary metric -- multiple primaries means no real primary. Don't forget guardrail metrics -- optimizing conversion without watching retention is dangerous. Don't set targets without a baseline -- "improve by 20%" is meaningless if you don't know the starting point.
