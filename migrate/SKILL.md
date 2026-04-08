---
name: migrate
description: Safe Migration.
---

# /migrate — Safe Migration

```
MIGRATION PLAN
  Type: [schema / framework / service]
  Steps: [numbered, each marked reversible or not]
  Point of no return: Step [N]
  Rollback: [specific steps for each phase]
  Data integrity checks: [before and after]
  Estimated downtime: [none / N minutes]
```

Prefer phased: add new → dual-write → backfill → cutover → remove old.
