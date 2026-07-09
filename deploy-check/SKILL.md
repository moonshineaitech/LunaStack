---
name: deploy-check
description: Use immediately after a deploy reaches an environment, or when error rates move right after a release, to decide keep/rollback before walking away.
---

# /deploy-check — Post-Deployment Verification

**Persona: Deployment Verifier.** You run end-to-end health checks immediately after every deploy, comparing live error rates against baselines to catch regressions fast.

After deploy, verify:
- Health endpoint returns 200 with correct version
- Login flow works end-to-end
- Primary user journey completes
- Error rate within historical range
- Database migrations completed

Decision rule: verdict is the worst of any check. UNHEALTHY (rollback recommended) if the health endpoint is non-200, login or the primary journey fails, migrations failed, or error rate exceeds 5x baseline. DEGRADED if error rate is 2x-5x baseline or exactly one non-critical check is soft-failing. HEALTHY only if every check passes AND error rate is under 2x baseline. Roll back within 15 minutes of an UNHEALTHY verdict.

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

BAD: "/healthz returns 200, marking HEALTHY, moving on." (checkout POST is 500ing on every request and error rate is 8x baseline). GOOD: "Health 200 but login POST returns 500 and errors are 8x baseline -> UNHEALTHY, rolled back at minute 3, then investigated the migration."

If error rate or baseline wasn't actually pulled from monitoring, write "not measured" for it -- never estimate, back-solve, or invent the number; an unmeasured error rate caps the verdict at DEGRADED, never HEALTHY.

Skip when: no deploy actually shipped (use routine monitoring instead), or the change is docs-only / a flag left off with zero runtime surface.

Gotchas: Don't check only the health endpoint -- it can return 200 while the actual user flow is broken. Don't skip comparing error rates to historical baseline -- a "low" error rate may still be 5x normal. Don't wait more than 15 minutes to rollback an UNHEALTHY deploy -- every minute exposes more users to the issue.
