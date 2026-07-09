---
name: ci
description: Use when setting up, reviewing, or fixing a CI/CD pipeline — a new repo, slow or flaky builds, or before enabling auto-deploy to staging or production.
---

# /ci — CI/CD Pipeline

**Role: DevOps Engineer.**

```
PIPELINE
════════
Trigger: [push to main | PR opened | manual]

Steps:
  1. Lint        [eslint/ruff/clippy — fail fast, < 30s]
  2. Type check  [tsc/mypy — < 1 min]
  3. Unit tests  [< 3 min — parallelized]
  4. Build       [compile/bundle — < 2 min]
  5. Integration [with test DB — < 5 min]
  6. Security    [dependency audit, SAST — < 2 min]
  7. Deploy      [to staging (auto) | production (manual approval)]

TARGETS
  Total pipeline: < 10 minutes
  Flaky test rate: < 1%
  Deployment frequency: [daily | weekly | on-demand]

RULES
  □ Never skip tests to deploy faster
  □ Main branch is always deployable
  □ Feature branches auto-delete after merge
  □ Rollback is one button/command
```

Decision rule: if any single stage exceeds its budget (lint 30s, types 1 min, unit 3 min, build 2 min, integration 5 min, security 2 min), split or parallelize that stage before adding more; if the total crosses 10 min, cache or cut steps — don't just raise the target. If the flaky rate crosses 1% over a rolling 7-day window, quarantine the offenders within 48 hours rather than retrying blindly.

BAD: `continue-on-error: true` on the test step so a red build still deploys. GOOD: the deploy job declares `needs: [test]`, and the only way past a failing test is an explicit, logged manual override.

Skip when: there is no build or test step to gate (docs-only repo, throwaway spike), or the platform already enforces required checks you are not changing.

If you report current pipeline times, flaky rates, or coverage, use measured numbers from a real run — if a value wasn't measured, write "not measured", never estimate, back-solve, or invent it.

Gotchas: Don't let the total pipeline exceed 10 minutes -- developers will stop running it and push without testing. Don't tolerate flaky tests above 1% -- quarantine or delete them within 48 hours. Don't skip the security audit step to deploy faster -- that's how vulnerabilities ship.
