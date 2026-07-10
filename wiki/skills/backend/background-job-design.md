---
name: background-job-design
description: Use when designing async job processing (Sidekiq, Celery, BullMQ, Temporal, SQS workers) or debugging duplicate, stuck, or lost jobs. Produces a job design covering idempotent handlers, retry policy with jittered exponential backoff and retry budgets, dead-letter queue with an ownership plan, visibility-timeout sizing, job payload and duration budgets, and enqueue-with-outbox atomicity.
---

# /background-job-design — Jobs That Survive Retries, Crashes, and You

Use to design background jobs that behave correctly under the at-least-once delivery every queue actually provides.

**Persona: Reliability engineer who assumes every job will run twice and die once halfway through.** You design handlers for redelivery, size timeouts for the slow path, and give every dead letter an owner. You do NOT trust "it only runs once," and you never enqueue inside a DB transaction's uncommitted state or after it without an outbox.

Every handler must be **idempotent** — workers crash after the side effect but before the ack, so redelivery is a certainty, not an edge case: guard with a unique key in the destination store or an inbox table, not an in-memory "seen" set (see /idempotency-design). Enqueue atomically with your data via the **transactional outbox** (insert job row in the same transaction, relay to the queue) — `tx.commit(); queue.push()` loses jobs on crash between the two, and push-then-commit runs jobs against data that never existed. Retries: **exponential backoff with full jitter** (base ~30s, cap ~1h), a finite budget of commonly 5–8 attempts, then **DLQ** — and a DLQ without an alert, a dashboard, and a redrive runbook is just a place jobs go to die quietly. Classify errors: retry only transient ones (timeouts, 429/5xx, deadlocks); permanent failures (validation, 4xx, missing record) go straight to DLQ on attempt one — retrying a `ValidationError` eight times is pure noise. Size **visibility timeout** (SQS) or lock TTL to ~2× worst-observed p99 duration and extend via heartbeat for long jobs; too short causes concurrent double-execution mid-run, too long delays crash recovery by the whole window. Budget jobs small: aim ≤ **60s** and ≤ ~256KB payload — pass IDs and refetch state, never serialize whole objects (they go stale and version-skew across deploys); split anything longer into a chunked fan-out with a checkpoint, or use a durable-execution engine (**Temporal**, **Restate**, Inngest) once a "job" is really a multi-step workflow with human-scale waits. Rule: **A job may be marked done only after its side effects are committed and its dedupe guard is written — in that order, atomically where possible.**

BAD: "Retry everything 25 times with default settings and check the failed queue when someone complains" (a poison message hammers a struggling downstream for hours, and real failures drown in validation-error noise). GOOD: "5 attempts, full-jitter backoff 30s→1h, permanent errors DLQ'd immediately, DLQ depth alarmed at >0 for 15 min with a redrive runbook."

```
JOB DESIGN — [job name]
═══════════════════════════════════════
Enqueue:    [outbox txn | direct+acceptable-loss] · payload=[IDs only, ≤KB]
Idempotency:[unique key / inbox table] on redelivery → [no-op]
Retries:    max=[n] · backoff=[base→cap, full jitter] · transient-only classifier=[y]
DLQ:        alert=[threshold] · owner=[team] · redrive=[runbook link]
Timeout:    visibility/lock=[~2× p99=Ns] · heartbeat=[y/n] · job budget ≤[60s]
Long work:  [chunked fan-out + checkpoint | Temporal/Restate workflow]
Observability: per-job attempts · age-of-oldest · queue depth=[dashboard]
═══════════════════════════════════════
```

Skip when: the work is <100ms and failure-tolerant inline (just do it in-request), or it's genuinely a multi-day stateful workflow — that's a durable-execution engine's job, not a queue handler's.

Gotchas: backoff without jitter synchronizes retries into waves that re-kill the recovering downstream. Serializing an ORM object into the payload breaks the day you rename a field mid-deploy — pass the ID. Measuring queue health by depth alone misses starvation; alert on **age of oldest message**. A global concurrency limit per queue but none per tenant lets one customer's 50k-job import starve everyone (pair with fair/weighted queues).
