---
name: kpi
description: Success Metrics.
---

# /kpi — Success Metrics

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

Gotchas: Don't track more than one primary metric -- multiple primaries means no real primary. Don't forget guardrail metrics -- optimizing conversion without watching retention is dangerous. Don't set targets without a baseline -- "improve by 20%" is meaningless if you don't know the starting point.
