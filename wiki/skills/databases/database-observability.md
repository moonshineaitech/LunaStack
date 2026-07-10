---
name: database-observability
description: Use when setting up monitoring for a production database, or when incidents keep surprising you ("the DB was fine, then it wasn't"). Produces an observability plan: slow-query capture, p99-based latency SLIs, lock/wait analysis tooling, and the leading capacity indicators that fire weeks before an outage.
---

# /database-observability — See the Outage Three Weeks Early

Use to instrument a database so degradation is visible as a trend, not discovered as an incident.

**Persona: Database Telemetry Engineer.** Instruments for questions ("what changed, what's waiting, what's growing") rather than collecting dashboards of averages, and ties every alert to an action. Does NOT tune queries or resize instances — this protocol makes problems visible; fixing them belongs to the tuning protocols.

Build four layers. **Query telemetry**: `pg_stat_statements` (or MySQL `performance_schema` / `sys`) is non-negotiable — it captures normalized query stats continuously; add `log_min_duration_statement` (~250ms–1s to start) plus `auto_explain` with `log_analyze` sampled at a few percent so slow executions arrive with their actual plans. Track latency as **p99 and p95, never mean** — means hide bimodal disasters where 5% of queries hit a lock while the average looks healthy; a p99 that doubles while mean is flat is a real incident forming. **Wait/lock analysis**: sample `pg_stat_activity.wait_event` (or use ASH-style tooling — pganalyze, Datadog DBM, RDS Performance Insights, `pg_wait_sampling`) because "the DB is slow" is almost always "the DB is waiting" — on locks, IO, or `IdleInTransaction`; alert on any lock wait exceeding ~30s and on blocked-session chains. **Capacity leading indicators** — the layer everyone skips: connection saturation vs `max_connections` (~80% warning), replication lag trend, disk growth rate as *weeks-until-full* (alert at <30 days, not at 90% used), autovacuum/dead-tuple backlog, transaction-ID age vs wraparound, and cache hit ratio trend. Wire query telemetry to deploys: diff `pg_stat_statements` before/after a release and you catch the regression the day it ships. Rule: **Alert on trends and saturation-time ("disk full in <30 days", "p99 2× the 7-day baseline"), not on instant thresholds that fire only when it's already too late.**

BAD: "We monitor CPU, memory, and average query latency with a PagerDuty alert at 90% disk" (CPU is fine during lock storms, averages hide the p99, and 90% of a 4TB volume is hours of runway). GOOD: "pg_stat_statements diffed per deploy, p99 latency SLI with a baseline-relative alert, wait-event sampling, and a days-until-disk-full forecast alerting at 30 days."

```
DB OBSERVABILITY PLAN
═════════════════════
QUERY CAPTURE: pg_stat_statements [on] · slow log [ms] · auto_explain sample [%]
LATENCY SLI: p99 [target ms] · p95 [ms] · alert [vs 7d baseline ×2]
WAITS/LOCKS: tool [ASH/DBM/wait_sampling] · lock-wait alert [>30s] · blocker chains [tracked]
LEADING INDICATORS: conns [%max] · repl lag [s] · disk [days-to-full]
  · dead tuples [trend] · txid age [% to wraparound]
DEPLOY HOOK: statement-stats diff [pre/post release]
RUNBOOK LINK: [each alert → action]
```

Skip when: a fully-managed platform (Neon, PlanetScale, Supabase) already surfaces query insights and you're pre-launch with no traffic — revisit at first real load; or the DB is an ephemeral dev fixture.

Gotchas: dashboards full of averages create confident blindness — the incident lives in the tail; logging every statement instead of sampling adds enough IO overhead to cause the slowness you're hunting; alerting on absolute thresholds ("CPU > 80%") pages for healthy batch jobs while missing a p99 doubling at 40% CPU; and nobody watches transaction-ID wraparound until Postgres forces a shutdown — it's a monthly-check line item, not an alert you tune later.
