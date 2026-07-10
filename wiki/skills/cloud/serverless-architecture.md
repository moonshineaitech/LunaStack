---
name: serverless-architecture
description: Use when designing or reviewing a serverless function or event-driven flow and you must choose runtime, memory, timeout, concurrency, and where state lives. Produces a design card that enforces statelessness and idempotency, checks the platform's hard limits, and flags cold-start and downstream-exhaustion risks before they reach production.
---

# /serverless-architecture — Designing Serverless Systems

Use when you design or review a Lambda / Cloud Function / Cloudflare Worker or an event-driven flow and must pick runtime, memory, timeout, concurrency, and where state lives.

**Persona: Serverless systems architect who owns the invocation contract.** You design every function as if it runs cold, runs a thousand times at once, and gets retried — statelessness, idempotency, and the platform's hard limits come before a line of business logic, because a function that ignores them fails only under the load you shipped it for.

Design rules: every handler is stateless and idempotent. Put SDK clients, connection pools, config, and warm caches in module scope (outside the handler) so the reused execution environment shares them across warm invocations — opening a connection inside the handler pays setup on every call and multiplies connections. Persist durable state to an external store (DynamoDB, S3, ElastiCache); `/tmp` (512MB default, up to 10,240MB) survives warm reuse but is never guaranteed and is shared across callers. Derive an idempotency key from the event (SQS `messageId`, request id) — async, SQS, and EventBridge sources retry, and at-least-once delivery means a duplicate will arrive.

Know the hard limits before you design: 15-minute max timeout, 6MB synchronous / 256KB async payload, 250MB unzipped package (10GB container image), 4KB total env vars, 1,000 default concurrent executions (soft). DECISION RULE: behind API Gateway the real ceiling is its 29-second integration timeout, not Lambda's 15 minutes — a sync handler slower than 29s times out at the gateway while the function keeps billing. If the job needs >15 minutes it is not a function; use Step Functions, Fargate, or Batch. If a sync payload exceeds 6MB, apply the claim-check pattern: write the blob to S3, pass the pointer.

Cold starts run your module-scope init before the handler: interpreted runtimes (Node/Python) add ~100-400ms, JVM/.NET can add 1-10s — keep the package lean and lazy-load heavy clients. For latency-critical paths use Provisioned Concurrency (keeps environments warm, billed even when idle), SnapStart (Java/Python/.NET, up to ~10x faster init from a restored snapshot), or Cloudflare Workers (V8 isolates, ~5ms instead of a container boot). Tune memory before code: CPU scales linearly with memory and you get one full vCPU at 1,769MB, so a compute-bound function is often faster and cheaper at higher memory — use AWS Lambda Power Tuning to find the cost/latency knee.

Protect downstream from fan-out: N concurrent invocations open N connections. DECISION RULE: never point Lambda straight at RDS at scale — set reserved concurrency below the database's connection ceiling (if Postgres `max_connections` is 100, cap reserved concurrency well under it, allowing for other clients) and front it with RDS Proxy, or use a connectionless store like DynamoDB. Reserved concurrency throttles a runaway fan-out; provisioned concurrency kills cold starts — different knobs, do not confuse them.

BAD: `def handler(event): conn = psycopg2.connect(DSN)` — a fresh Postgres connection every invocation; at 1,000 concurrent Lambdas you exceed `max_connections`, the database refuses connections, and every function errors at once.
GOOD: create the client once in module scope for warm reuse, front RDS with RDS Proxy (or use DynamoDB), and set reserved concurrency below the connection ceiling so fan-out cannot exhaust the DB.

Cold-start and latency fields report measured values — if you have not measured p99 from logs or a load test, write "not measured", never estimate.

```
═══ SERVERLESS DESIGN — [function] ═══
Trigger:      [sync API GW | async event | SQS/SNS | stream | cron]
Runtime/mem:  [runtime] @ [MB] → [~vCPU]
Timeout:      [Ns]  (caller cap: [API GW 29s | none])
State:        [stateless + store: DynamoDB/S3/Redis]
Idempotency:  [key source | NONE — retries will duplicate]
Concurrency:  reserved=[N|none] provisioned=[N|0]  (downstream cap: [reason])
Cold start:   p99=[Xms | not measured]  mitigation=[none | PC | SnapStart | Workers]
Limits:       payload [X/6MB] · pkg [X/250MB] · /tmp [X/512MB] · timeout [X/900s]
Verdict:      [SHIP | FIX: reason]
═══════════════════════════════
```

Skip when: the workload is long-running or stateful (persistent DB, WebSocket server, >15-min batch), steady high-throughput where always-on containers cost less per request, or you need predictable sub-10ms latency with zero cold-start tolerance — reach for Fargate/ECS/K8s instead.

Gotchas: API Gateway caps at 29s while Lambda allows 900s, so a slow sync handler times out at the gateway with the function still billing; module-scope globals and `/tmp` persist across warm invocations of different callers, so caching one user's data there leaks it to the next; a self-triggering function (writes to the same S3 bucket/prefix that invokes it, or re-invokes itself) runaway-scales to the account concurrency cap and bills the whole account — use a separate bucket/prefix and set reserved concurrency.
