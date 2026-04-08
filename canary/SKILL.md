---
name: canary
description: Staged Rollout.
---

# /canary — Staged Rollout

```
Phase 1: Internal (team only) — [N] hours — health criteria: [list]
Phase 2: Canary (5%) — [N] hours — health criteria + support ticket watch
Phase 3: Expanded (25%) — [N] hours — core metrics not degraded
Phase 4: GA (100%) — monitoring window

Rollback trigger: any criterion degrades >10% from baseline
Rollback procedure: [revert flag/image], verify, notify
```
