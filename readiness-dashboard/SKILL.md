---
name: readiness-dashboard
description: Review Status Dashboard.
---

# /readiness-dashboard — Review Status Dashboard

Use before /ship to see all required reviews at a glance.

```
+================================================================+
|                  REVIEW READINESS DASHBOARD                    |
+================================================================+
| Review        | Runs | Last Run         | Status   | Required |
|---------------|------|------------------|----------|----------|
| Eng Review    |  1   | 2026-04-08 14:30 | CLEAR    | YES      |
| CEO Review    |  1   | 2026-04-08 13:15 | CLEAR    | NO       |
| Design Review |  2   | 2026-04-08 14:50 | B+       | YES (UI) |
| CSO Audit     |  1   | 2026-04-08 14:00 | CLEAR    | YES (sec)|
| Codex Review  |  0   | —                | —        | NO       |
| QA            |  1   | 2026-04-08 15:00 | CLEAR    | YES      |
+----------------------------------------------------------------+
| VERDICT: CLEARED — All required reviews passed                 |
+================================================================+
```

Eng Review is the only universally required gate. Others are conditional based on what changed (UI changes need Design Review, security-touching changes need CSO Audit, etc.).

Gotchas: Don't ship with unrun required reviews -- a dashboard showing gaps is only useful if you act on them. Don't make every review required for every change -- conditional gates prevent review fatigue. Don't let "CLEARED" mean "perfect" -- it means minimum quality bar met, not that there are zero issues.
