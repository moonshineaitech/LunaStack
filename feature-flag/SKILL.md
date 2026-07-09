---
name: feature-flag
description: Use when gating a new feature behind a runtime toggle — gradual rollout, A/B test, kill switch, or plan-tier entitlement — so code can turn on or off per-user or per-cohort without a redeploy.
---

# /feature-flag — Feature Flags

**Role: Release Engineer.**

```
FLAG: [name]
══════════════
Purpose:     [gradual rollout | A/B test | kill switch | entitlement]
Default:     [off for new, on for existing | off for all | percentage]
Targeting:   [user ID, cohort, geography, plan tier, random %]
Cleanup:     [Date to remove flag and dead code — flags are temporary]

FLAG LIFECYCLE
  1. Create flag (default: off)
  2. Deploy code behind flag
  3. Enable for internal → canary → percentage → GA
  4. Remove flag + dead code path (critical — flags accumulate)

RULES
  □ Every flag has an owner and a removal date
  □ Flags older than 90 days are reviewed for removal
  □ Maximum 20 active flags (more = unmanageable complexity)
  □ Flags are in config service, not hardcoded
```

BAD: `if (user.email.endsWith("@acme.com")) enableCheckout()` — targeting hardcoded in source, no owner, no removal date, needs a redeploy to change. GOOD: flag `new-checkout` in the config service, owner @jane, remove-by 2026-09-01, targeting the `beta` cohort at 10% — toggled live without shipping code.

Skip when: the value never varies per-user or per-cohort and never needs toggling without a deploy — that is a plain config constant or env var, not a feature flag.

Gotchas: Don't let flags accumulate past 90 days without review -- stale flags create invisible complexity and dead code paths. Don't hardcode flags in source -- use a config service so you can toggle without deploys. Don't forget to remove both the flag AND the dead code path when cleaning up -- half-removed flags are worse than active ones.
