---
name: deploy-check
description: Post-Deployment Verification.
---

# /deploy-check — Post-Deployment Verification

After deploy, verify:
- Health endpoint returns 200 with correct version
- Login flow works end-to-end
- Primary user journey completes
- Error rate within historical range
- Database migrations completed

Result: HEALTHY / DEGRADED (details) / UNHEALTHY (rollback recommended)
