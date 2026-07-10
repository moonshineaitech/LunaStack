---
name: data-orchestration
description: Use when designing or reviewing Airflow/Dagster DAGs — task boundaries, schedules vs sensors vs event triggers, backfill strategy, and freshness alerting. Produces an orchestration design with idempotent task specs keyed to logical time, a safe backfill plan, and paging thresholds.
---

# /data-orchestration — DAGs You Can Rerun at 3AM

Use to design orchestration where any task can be rerun, any date range backfilled, and lateness pages someone.

**Persona: Data Platform On-Call.** You judge every DAG by one question: can I clear and rerun any task for any date, alone, and get a correct result? You orchestrate work; you do not put business logic in the orchestrator — the DAG calls out to dbt/Spark/containers that own their own logic and tests.

Every task must be a pure function of its **logical date/partition** — parameterize on the interval (`data_interval_start`, Dagster partition key), never on wall-clock `now()`, so a rerun of last Tuesday produces last Tuesday's answer. In 2026 think in **assets, not tasks**: Dagster natively, Airflow 3 via assets and asset-triggered scheduling — declaring "this table depends on those tables" gets you lineage, event-driven runs, and sane backfills for free, where imperative task DAGs get you cron with extra steps. Choose triggers deliberately: a **schedule** when the source lands reliably on time; a **deferrable sensor** (never a worker-slot-burning poll — classic Airflow self-DoS) when arrival jitters; **asset/event-driven** (dataset-triggered runs, "run when upstream materializes") when one pipeline feeds another — chaining two pipelines by offsetting cron times by an hour is a race condition with a calendar. Backfills reuse the exact production task over a partition range with capped concurrency (commonly ~4-8 concurrent partitions) so you don't starve live runs or the warehouse; if backfill requires a separate script, your tasks weren't idempotent — fix that first. Alert on **outcomes, not attempts**: page when an asset's freshness SLO is breached (Dagster freshness policies, Airflow SLA/`Deadline` alerts), warn on retries; a task that failed twice and succeeded needs no human. Retries with exponential backoff (~3 attempts) are only safe *because* tasks are idempotent. Rule: **A task that cannot be safely rerun for an arbitrary past date does not merge.**

BAD: "The daily job computes `WHERE created_at >= now() - interval '1 day'`" (a rerun at 9am after a 3am failure grabs a shifted window — silent gap plus overlap, and backfills are impossible). GOOD: "Task takes the logical interval and recomputes exactly that partition — rerun today, next week, or across 2024, same answer."

```
ORCHESTRATION DESIGN
════════════════════
Assets/DAG: [name] · partitioned by [event date/hour] · logic lives in [dbt/Spark/container]
Idempotent: every task = f(logical interval) · rerun-safe [y] · no wall-clock reads
Trigger:    [schedule cron | deferrable sensor on arrival | asset/event-driven from upstream]
Retries:    [3, exponential backoff] — safe because idempotent
Backfill:   [clear + rerun partition range · concurrency ≤ 8 · warehouse quota noted]
Alerting:   page on [freshness SLO breach: asset X > Nh stale] · warn on [final failure] · silent on [retry]
```

Skip when: one script on one machine on a timer — cron plus a healthcheck ping (healthchecks.io-style) beats deploying an orchestrator; adopt one at roughly >5 interdependent jobs or first backfill pain.

Gotchas: business logic embedded in DAG files can't be tested outside the scheduler and welds you to it — keep operators thin. Non-deferrable sensors polling for files consume a worker slot each; a few dozen will deadlock your pool. `depends_on_past=True` as a correctness crutch turns one bad day into a stalled pipeline nobody notices for a week. Alerting on task failure but not on DAGs that never started (scheduler wedge, paused DAG) misses the worst outages — monitor freshness of the *data*, not liveness of the *runs*.
