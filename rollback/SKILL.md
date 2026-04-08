---
name: rollback
description: Emergency Revert.
---

# /rollback — Emergency Revert

**Decide in 5 minutes:**
ROLLBACK if: error rate climbing, root cause unclear, fix >15 min, data integrity risk
FIX-FORWARD only if: cause known, fix <5 lines, <10 min to deploy, rate stable

Steps: communicate → revert → verify → communicate → investigate via /debug.
