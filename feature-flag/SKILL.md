---
name: feature-flag
description: Feature Flags.
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
