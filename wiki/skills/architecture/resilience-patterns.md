---
name: resilience-patterns
description: Use when a system calls anything over a network — other services, databases, third-party APIs — and must survive their bad days. Produces a per-dependency resilience spec: explicit timeouts, budgeted retries with jitter, circuit breakers, bulkheads, and a named degraded mode for each dependency.
---

# /resilience-patterns — Fail Fast, Degrade on Purpose

Use to make every network dependency survivable: bounded in time, bounded in retries, and with a rehearsed fallback.

**Persona: Failure-Mode Engineer.** Becomes the reviewer who walks each dependency asking "what happens when this hangs, errors, or answers slowly?" and refuses defaults. Specifies timeouts, budgets, breakers, and degraded modes; does NOT add resilience machinery to in-process calls or promise availability the dependencies can't support.

The missing default in most outages is the **timeout**: client libraries commonly ship with none (or minutes), so one slow dependency silently consumes every thread and connection upstream. Set an explicit timeout on every network call — a sane starting point is ~2-3x the dependency's observed p99, and enforce a **deadline budget** end-to-end: if the caller gives you 2s, your downstream calls must fit inside it (propagate via gRPC deadlines or a context/deadline header), because a timeout longer than your caller's is a promise you can't keep. Retries are the pattern that turns brownouts into outages: retry only idempotent operations, only on retryable failures (timeouts, 429/503 — never 400s), with **exponential backoff + full jitter**, capped at 2-3 attempts, and governed by a **retry budget** (commonly ≤10% of total traffic may be retries — token-bucket style, as in Envoy/linkerd) so a struggling dependency sees load shed, not multiplied; layer retries at ONE level, not client+mesh+SDK stacked into a 27x amplifier. **Circuit breakers** (resilience4j, Polly v8, or mesh-level outlier detection in Envoy/Istio) trip when error rate crosses ~50% over a sliding window, fail fast while open, and probe with a trickle in half-open — their job is giving the dependency room to recover. **Bulkheads** cap the blast radius: separate connection pools/semaphores per dependency, sized so one hung service can exhaust its own compartment and nothing else. Finally, make degradation a design artifact: for each dependency write the **degraded mode** — serve stale cache, hide the panel, queue the write — because a fallback invented mid-incident is a second incident; verify the whole stack with fault injection (Toxiproxy in CI, chaos experiments in staging). Rule: **No network call ships without an explicit timeout that fits inside its caller's deadline — a call with no deadline is an unbounded liability.**

BAD: "Wrap the flaky payment API in retry(5) so users stop seeing errors" (five retries with no backoff or budget turns the provider's brownout into a self-inflicted DDoS and quintuples duplicate-charge risk on a non-idempotent call). GOOD: "1.5s timeout inside the 3s request deadline, 2 retries with full jitter on 503 only, idempotency key on every charge, breaker at 50% errors, fallback: queue and confirm asynchronously."

```
RESILIENCE SPEC — [DEPENDENCY]
══════════════════════════════
Timeout: [Xms ≈ 2-3x p99] · Caller deadline: [Yms] · Budget fits: [y/n]
Retries: [count ≤3 · backoff+full jitter · idempotent? · retryable codes] · Retry budget: [≤10% traffic]
Breaker: [error-rate ~50% / window · half-open probe] · Bulkhead: [pool size / semaphore]
Degraded mode: [stale cache / hide feature / queue write] · User sees: [what]
Fault test: [Toxiproxy/chaos scenario proving fallback works]
```

Skip when: the call is in-process or to a same-box resource — resilience machinery there is pure overhead; or a service mesh already enforces timeouts/retries/outlier detection and you'd be stacking a second layer on top.

Gotchas: retries stacked across layers (HTTP client × sidecar × job runner) multiply into amplification storms — audit the whole path and pick one layer; timeouts without idempotency keys mean every timeout is a possible duplicate write; circuit breakers on 4xx errors trip on your own bad requests and mask client bugs as dependency failure; fallbacks that call the same failing dependency ("on error, fetch from the API's other endpoint") aren't fallbacks; caches that expire during long outages convert graceful degradation into a cold-start stampede — serve stale-while-revalidate instead.
