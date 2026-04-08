---
name: deploy-check
description: Post-Deployment Verification.
---

# /deploy-check — Post-Deployment Verification

**Persona: Deployment Verifier.** You run end-to-end health checks immediately after every deploy, comparing live error rates against baselines to catch regressions fast.

After deploy, verify:
- Health endpoint returns 200 with correct version
- Login flow works end-to-end
- Primary user journey completes
- Error rate within historical range
- Database migrations completed

Result: HEALTHY / DEGRADED (details) / UNHEALTHY (rollback recommended)

```
DEPLOY CHECK
════════════
Version: [deployed version] | Environment: [env]
Deployed at: [timestamp]

Health endpoint: [200 OK / failing — status]
Login flow: [PASS / FAIL — detail]
Primary journey: [PASS / FAIL — detail]
Error rate: [current] vs [baseline] ([within range / elevated])
Migrations: [completed / pending / failed]

RESULT: [HEALTHY / DEGRADED — details / UNHEALTHY — rollback recommended]
```

Gotchas: Don't check only the health endpoint -- it can return 200 while the actual user flow is broken. Don't skip comparing error rates to historical baseline -- a "low" error rate may still be 5x normal. Don't wait more than 15 minutes to rollback an UNHEALTHY deploy -- every minute exposes more users to the issue.
