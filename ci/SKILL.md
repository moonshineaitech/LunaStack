---
name: ci
description: CI/CD Pipeline.
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
