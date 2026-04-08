---
name: competing
description: Use when there are 2-3 viable approaches and you're not sure which is best.
---

# /competing — Competing Implementations

Use when there are 2-3 viable approaches and you're not sure which is best.

Run parallel sessions on separate git branches, each implementing a different approach to the same spec. Compare results.

```
Branch A: approach-redis-cache (Session 1)
Branch B: approach-postgres-materialized (Session 2)  
Branch C: approach-application-cache (Session 3)

Compare: correctness, performance, complexity, maintainability
Pick the winner, delete the rest
```

Engineers at incident.io run 4-5 parallel sessions on separate branches. One spent $8 in Claude credit and produced an implementation that improved API time by 18%.
