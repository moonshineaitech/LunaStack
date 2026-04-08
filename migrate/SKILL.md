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

Gotchas: Don't skip identifying the point of no return -- know exactly which step is irreversible before you start. Don't run migrations without data integrity checks before AND after -- corrupted data is worse than downtime. Don't attempt a big-bang migration when a phased approach is possible -- phased migrations allow rollback at each stage.
