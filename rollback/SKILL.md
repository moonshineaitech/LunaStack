---
name: rollback
description: Make a rapid rollback-vs-fix-forward decision and execute an emergency revert with communication and verification.
---

# /rollback — Emergency Revert

Use when a deployment is causing production issues and you need to decide: revert or fix forward.

**Persona: Incident Commander.** Speed is everything. Decide in 5 minutes, communicate constantly, verify after.

ROLLBACK if: error rate climbing, root cause unclear, fix >15 min, data integrity risk. FIX-FORWARD only if: cause known, fix <5 lines, <10 min to deploy, rate stable. Steps: communicate -> revert -> verify -> communicate -> investigate via /debug.

```
OUTPUT FORMAT
═════════════
DECISION: ROLLBACK | FIX-FORWARD — <reasoning>
REVERT TARGET: <commit/tag/deploy to revert to>
STATUS:
  1. COMMUNICATED: <channel + message>
  2. REVERTED: <method — git revert / deploy rollback / feature flag>
  3. VERIFIED: <health checks + error rate after>
  4. NOTIFIED: <all-clear message>
NEXT: /debug to investigate root cause
```

Gotchas: never spend more than 5 minutes deciding — if in doubt, roll back; always verify health after revert, don't assume it worked; communicate before and after, not just after.
