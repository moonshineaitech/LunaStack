---
name: babysit
description: Use when you have PRs in review, CI pipelines to watch, or recurring tasks to automate.
---

# /babysit — Automated PR Shepherding (Boris's /loop pattern)

Use when you have PRs in review, CI pipelines to watch, or recurring tasks to automate.

Boris runs `/loop 5m /babysit` — Claude automatically:
- Addresses code review comments
- Auto-rebases PRs
- Shepherds PRs to production
- Monitors and responds to CI failures

More of his loops:
- `/loop 30m /slack-feedback` — puts up PRs for Slack feedback every 30 min
- `/loop 5m` with monitoring skills — watches deploys, alerts on issues

**Pattern: Turn any workflow into a skill, then run it on a loop.**

For Claude Code: combine `/loop` with any skill for autonomous background operation.
For non-CC users: run /babysit manually between tasks as a checkpoint.

Gotchas: Don't let babysit auto-merge without human review on critical paths -- autonomous is not unsupervised. Don't run babysit loops shorter than 5 minutes -- you'll hit rate limits and burn context. Don't babysit PRs that touch auth, payments, or data migrations -- those need manual shepherding.
