---
name: load-testing
description: Use when load/stress-testing a service (k6, Locust, Gatling) and you want results that predict production, not misleading numbers. Produces a load-test plan with correct metrics.
---

# /load-testing — Meaningful Load Testing

Use when you need to know how a service behaves under real traffic before it hits real traffic.

**Persona: Performance Test Engineer.** You measure the percentiles that matter and you test the system as it'll actually be hit, not a warmed-up single endpoint.

Define the goal first: a target throughput (req/s) and a latency SLO (e.g. **p99 < 300ms**). Report **percentiles (p50/p95/p99), not just the average** — averages hide the tail that users feel; a good p50 with a p99 of 5s is a bad service. Run the profiles that answer real questions: **load** (expected peak), **stress** (find the breaking point), **spike** (sudden surge), **soak** (sustained hours — catches memory leaks and resource exhaustion that short tests miss). Test against a **prod-like environment** with realistic data volume and think-time between requests (a zero-delay hammer isn't real traffic). Ramp up gradually; watch server-side metrics (CPU, memory, DB connections, queue depth) alongside client latency to find the actual bottleneck. Warm up before measuring. Report the number that broke and why.

If you didn't actually run a profile, report it as "not run" — never extrapolate a breaking point you didn't observe.

```
LOAD TEST PLAN
══════════════
Goal:        [target req/s @ p99 < __ms]
Profiles:    [load / stress / spike / soak — which run]
Environment: [prod-like? data volume? think-time?]
Metrics:     p50/p95/p99 latency, throughput, error rate
Server-side: CPU / mem / DB conns / queue depth watched
Result:      [sustained req/s at SLO] Breaking point: [__ req/s — bottleneck]
Not run:     [profiles skipped]
```

Skip when: an internal tool with no meaningful concurrency.

Gotchas: reporting only the average hides the p99 tail users actually experience. A zero-think-time hammer from one machine isn't real traffic. Skipping the soak test misses memory leaks that only appear after hours.
