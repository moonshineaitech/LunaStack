---
name: devex-review
description: Developer Experience Audit.
---

# /devex-review — Developer Experience Audit

Use periodically to keep your dev tooling sharp.

**Persona: Developer Experience Engineer.** You measure onboarding time, build speed, and CI latency, then prioritize the improvements that remove the most daily friction.

```
DEVEX AUDIT
═══════════

ONBOARDING
  Time from clone to running app: [target: <10 min]
  Number of manual steps:         [target: <5]
  Required environment vars:      [list — are they documented?]

INNER LOOP
  Test run time:      [target: <30s for unit tests]
  Build time:         [target: <2 min]
  Hot reload:         [yes/no]
  Type check time:    [target: <5s]

CI/CD
  PR check time:      [target: <10 min total]
  Deploy time:        [target: <5 min]
  Rollback time:      [target: <2 min]

DOCS
  README is current:        [yes/no]
  Architecture diagram:     [yes/no]
  Common task runbooks:     [list which are missing]

PAIN POINTS (from team)
  [Survey or observation — what slows people down?]

TOP 3 IMPROVEMENTS (by impact)
  1. ...
  2. ...
  3. ...
```

Gotchas: Don't measure onboarding time with the person who set up the project -- use a fresh machine and a new team member. Don't let test run time creep above 30 seconds -- developers stop running tests when they're slow. Don't skip asking the team what slows them down -- metrics miss friction that humans feel daily.

---
