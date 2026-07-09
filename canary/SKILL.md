---
name: canary
description: Use when promoting a deployment to production traffic in stages — new service, risky migration, schema change, or any release where a bad version would hit real users. Graduates through traffic tiers with explicit health gates and instant rollback triggers at every stage.
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

Decision rule: promote a phase only when every health criterion holds green for the full window with zero rollback triggers. If any criterion sits within 10% of its trigger, hold — do not promote. Bake at least 24h at canary (5%) to cover one full daily traffic cycle. Never promote more than one tier per day, and never promote two tiers in the same on-call shift. For critical metrics (payment success, auth, data loss), tighten the rollback trigger to >2% degradation — 10% is too loose to protect them.

Every phase decision cites measured numbers (baseline value, current value, % delta). If a value wasn't measured, write "not measured" — never estimate, back-solve, or invent it; an unmeasured criterion is not green, so it blocks promotion.

BAD: tests passed, so deploy to 100% at 2am, glance at the dashboard for an hour, go to bed. GOOD: hold 5% canary for 24h — error rate +0.3% (trigger +2%), p95 latency flat, zero new support tickets — then promote to 25% and start a fresh window.

Skip when: the change has no user-facing runtime path (docs-only, comment-only, dead code behind an off flag), or it's an emergency revert of a known-bad deploy — roll that forward at full traffic immediately rather than staging it.

Gotchas: Don't skip the internal-only phase -- your team catches obvious issues before users see them. Don't set rollback triggers too loose -- a 10% degradation threshold may be too high for critical metrics like payment success rate. Don't promote from canary to GA without waiting the full observation window -- some issues only surface under sustained load.
