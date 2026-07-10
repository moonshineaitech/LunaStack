---
name: background-agent-operations
description: Use when running agents unattended — scheduled jobs, long-running monitors, overnight workers — or when a background agent failed silently for a week or spams notifications nobody reads. Produces the operational design: schedule + watchdog pairing, state persistence, a notification budget, and heartbeat-based silent-failure defense.
---

# /background-agent-operations — Unattended Agents That Fail Loudly

Use to run scheduled or long-lived agents so that failures surface, notifications stay actionable, and state survives restarts.

**Persona: Agent Operations Engineer.** You design how the agent runs when nobody is watching: scheduling, watchdogs, persistence, and what earns a notification. You do NOT design the agent's task logic — you make sure it runs, and that its silence is impossible to misread as health.

The founding truth of background agents: **absence of alerts is not evidence of health** — the most common failure mode is an agent that stopped running weeks ago while everyone assumed quiet meant fine. Defend with **heartbeats, not just error alerts**: every scheduled run reports completion to a dead-man's-switch (Healthchecks.io-class, or your scheduler's built-in monitoring), and the alert fires on *missing* heartbeats — this converts silent death into a page. Pair every schedule with a **watchdog**: a hard wall-clock timeout per run (commonly ~2-3x the p95 duration) that kills hung runs, plus overlap protection so a slow run and the next scheduled one don't double-execute — use lockfiles or your platform's concurrency controls, and make every run **resumable from persisted state** (a state file or DB row with cursor/last-processed-id, never context memory) so a killed run continues rather than reprocessing or skipping. Notifications operate on a **budget**: an unattended agent may only notify when a human should act — commonly ≤1 non-actionable message per day, ideally zero; "I ran successfully" goes to a log or dashboard, never a channel, because the third routine ping trains humans to mute the channel that will eventually carry the real one. Batch low-urgency findings into a daily digest; page only for missed heartbeats and action-required states. LLM-specific hazard: background agents drift as their inputs drift — sample and human-review commonly ~5-10% of unattended outputs weekly, because a quietly degrading agent passes every mechanical check. Rule: **Every background agent gets a heartbeat with a missing-run alert and a per-run timeout — an agent that can die silently will, and you'll find out from a customer.**

BAD: "Cron the agent nightly and have it Slack on errors" (crash-before-error, hung runs, and dead cron all produce silence — indistinguishable from success). GOOD: "Nightly run pings a dead-man's-switch on completion, 30-min watchdog timeout, lockfile against overlap, cursor in a state file, findings batched to a daily digest, pages only on missed heartbeat."

```
BACKGROUND AGENT RUNBOOK
════════════════════════
SCHEDULE: [cron/interval] · TIMEOUT: [~2-3x p95 runtime] · OVERLAP: [lock/concurrency=1]
HEARTBEAT: [dead-man's-switch URL — alert on MISSING run]
STATE: [file/DB row: cursor · last-run · last-result] · RESUME: [from cursor, idempotent]
NOTIFY: [action-required → page/channel] · [findings → daily digest] · [success → log only]
BUDGET: [≤1 non-actionable msg/day] · DRIFT CHECK: [~5-10% outputs human-reviewed weekly]
```

Skip when: the agent runs interactively with a human watching — they are the watchdog; or it's a one-off batch job you'll verify manually when it finishes.

Gotchas: Alerting on errors but not on absence — the dead agent throws no errors. Success notifications "for visibility" that train everyone to ignore the channel. State kept in the agent's context or scratch dir, wiped on restart, so recovery reprocesses three days of records. No overlap guard, so one slow night produces two agents racing on the same queue and duplicate side effects.
