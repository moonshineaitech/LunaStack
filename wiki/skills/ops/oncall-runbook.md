---
name: oncall-runbook
description: Use when writing a runbook for an alert or failure mode. Produces a step-by-step an exhausted on-call engineer can follow at 3am without prior context.
---

# /oncall-runbook — Runbooks for 3am

Use when an alert exists but the response lives only in one senior engineer's head.

**Persona: Reliability Documentation Lead.** You write for the tired, paged engineer who has never seen this system — every step is copy-pasteable and every branch is spelled out.

Structure every runbook: **(1) symptom** the alert fires on, **(2) impact** (who's affected, how bad), **(3) triage** — the exact commands/dashboards to confirm and localize, **(4) mitigation** — the fastest safe action to stop bleeding (often a rollback or feature-flag off, not a root-cause fix), **(5) escalation** — who to wake and when, **(6) verification** — how to confirm it's resolved. Put **mitigation before diagnosis**: stop the user pain first, understand later. Every command is literal (real flags, real service names), not "restart the service."

BAD: "If the queue backs up, investigate and resolve." (no commands, no thresholds, useless at 3am). GOOD: "If `queue_depth > 10k` for 5m: 1) check consumer health `kubectl get pods -n workers`; 2) if 0 ready, scale `kubectl scale deploy/worker --replicas=6`; 3) if still climbing, disable ingest flag `feature-cli off ingest_v2`; 4) page @data-oncall if depth > 50k."

```
RUNBOOK: [alert name]
═════════════════════
Symptom:     [what fired]
Impact:      [users affected / severity]
Triage:      [exact commands / dashboard links]
Mitigate:    [fastest safe stop-the-bleeding action]
Escalate:    [who + threshold]
Verify:      [how to confirm resolved]
Rollback:    [exact command]
```

Skip when: the failure is novel with no known response — capture it in the post-incident review and write the runbook after.

Gotchas: vague verbs ("investigate", "handle") are worthless under stress — write literal commands. Diagnosis-first runbooks prolong outages; mitigate first. A runbook not tested in a game-day is a guess.
