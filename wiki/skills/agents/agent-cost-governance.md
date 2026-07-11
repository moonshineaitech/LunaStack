---
name: agent-cost-governance
description: Use when agent spend is unbounded, surprising, or growing faster than usage — or before scaling an agent fleet. Produces per-task-class token/cost budgets, a model-tier routing policy (small-first with escalation), anomaly alerting, and a runaway-loop circuit breaker with hard caps.
---

# /agent-cost-governance — Budgets, Tiers, and Circuit Breakers

Use to put agent spend under engineering control: budgets per task class, cheap-model-first routing, anomaly alerts, and hard stops for runaway loops.

**Persona: Cost Controller.** You set the budgets, routing policy, and kill switches, and you make spend attributable per task and per agent. You do NOT degrade quality to save pennies — you spend deliberately and stop spending automatically when a run goes pathological.

Start with **per-task-class budgets**, not a global monthly number: classify tasks (triage, draft, deep-research, code-change) and give each a token/dollar cap derived from observed cost — commonly p95 of healthy runs times ~2; a global budget lets one runaway task starve a thousand healthy ones. Route by tier with **small-first escalation**: send every task to the cheapest model that historically clears its quality bar (Haiku-class for classification/extraction, mid-tier for drafting, frontier for judgment-heavy synthesis), and escalate on a defined failure signal — schema violation, low confidence, failed verification — not on task-sounds-hard vibes; in production mixes, commonly 60-80% of agent calls are tier-downgradable without measurable quality loss, and **prompt caching** on stable system prompts and tool definitions cuts input cost further before you touch routing at all. The non-negotiable is the **runaway-loop circuit breaker**: a hard per-run cap on steps and dollars (e.g. ~50 tool calls or ~$5 for a routine task, sized to your classes) that halts the run and checkpoints — a stuck agent's failure mode is an infinite loop of earnest, billable retries, and it will find the one path your soft limits don't cover. Layer alerting on top: flag any run over ~3x its class median in real time, and any day-over-day class spend jump over ~50%, with cost attributed by task id and agent so anomalies point at a cause. Rule: **Every agent run executes under a hard step-and-dollar cap that halts and checkpoints when hit — soft budgets and dashboards are accounting; only the circuit breaker is control.**

BAD: "Set a $2k monthly API budget alert and use the best model everywhere" (the alert fires on day 9 after a retry loop ran all weekend, and nobody can say which agent or task burned it). GOOD: "Per-class caps at 2x p95 with a hard per-run breaker, Haiku-first routing with schema-failure escalation, prompt caching on, and real-time flags on any run at 3x class median."

```
COST GOVERNANCE
═══════════════
TASK CLASS: [name] · BUDGET/RUN: [~2x p95 tokens/$] · HARD CAP: [steps + $ — halt & checkpoint]
ROUTING: [class → cheapest passing tier] · ESCALATE ON: [schema fail | low conf | verify fail]
CACHING: [system prompt + tools cached] · ATTRIBUTION: [cost per task_id/agent]
ALERTS: [run >3x class median · class spend +50% day-over-day]
REVIEW: [monthly: tier mix · escalation rate · breaker trips]
```

Skip when: total agent spend is trivial next to engineering time — measure and attribute, but skip routing complexity; or a single low-volume agent where a per-run cap alone suffices.

Gotchas: Routing by task description instead of measured quality-per-tier — you'll send easy-sounding hard tasks to the small model and eat silent quality loss. Circuit breakers that alert but don't halt — a notification does not stop a loop at 2 a.m. Forgetting that escalation retries pay twice; if escalation rate exceeds ~30% for a class, the small tier isn't cheaper, it's a toll booth. Optimizing token cost while ignoring that one bad autonomous action costs more than a year of model spend.
