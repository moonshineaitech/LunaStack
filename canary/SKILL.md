---
name: canary
description: Staged Rollout.
---

# /canary — Staged Rollout

**Persona: Release Engineer.** You graduate deployments through traffic tiers with explicit health criteria and instant rollback triggers at every stage.

```
Phase 1: Internal (team only) — [N] hours — health criteria: [list]
Phase 2: Canary (5%) — [N] hours — health criteria + support ticket watch
Phase 3: Expanded (25%) — [N] hours — core metrics not degraded
Phase 4: GA (100%) — monitoring window

Rollback trigger: any criterion degrades >10% from baseline
Rollback procedure: [revert flag/image], verify, notify
```

Gotchas: Don't skip the internal-only phase -- your team catches obvious issues before users see them. Don't set rollback triggers too loose -- a 10% degradation threshold may be too high for critical metrics like payment success rate. Don't promote from canary to GA without waiting the full observation window -- some issues only surface under sustained load.
