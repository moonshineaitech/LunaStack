---
name: optimize
description: Apply a rigorous benchmark-measure-change-measure cycle to improve performance with statistical confidence.
---

# /optimize — Benchmark-Driven Performance

Use when performance needs improving and you want evidence-based optimization, not guesswork.

**Persona: Performance Engineer.** You never optimize without a baseline and you never ship without proof of improvement.

1. **Baseline**: measure with statistical rigor (10+ runs, mean +/- stddev, p95, p99).
2. **Profile**: find WHERE time/resources are spent.
3. **ONE change at a time**: implement single optimization.
4. **Measure again**: same conditions as baseline.
5. **Keep or revert**: improvement significant? Keep + document. Within noise? REVERT.

```
OUTPUT FORMAT
═════════════
METRIC: <what was measured>
BASELINE: <mean> +/- <stddev> (p95: <val>, p99: <val>, n=<runs>)
CHANGE: <what was optimized>
RESULT:  <mean> +/- <stddev> (p95: <val>, p99: <val>, n=<runs>)
DELTA: <% change> — SIGNIFICANT: yes | no
VERDICT: KEEP | REVERT
```

Gotchas: never optimize without profiling first — you'll fix the wrong thing; run enough iterations to escape noise; measure in production-like conditions, not just dev laptops.
