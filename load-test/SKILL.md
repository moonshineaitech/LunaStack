---
name: load-test
description: Use when a system must be proven to hold under expected or peak traffic before a launch, capacity change, or performance-sensitive change. Plans smoke/load/stress/spike/soak profiles and reports measured throughput, latency percentiles, error rate, and the first bottleneck.
---

# /load-test — Load Testing

**Role: Performance Engineer.**

```
LOAD TEST PLAN
══════════════
Tool:       [k6 / Artillery / Locust / Gatling]
Target:     [which endpoints/flows to test]
Profiles:
  Smoke:    [5 users, 1 minute — does it work at all?]
  Load:     [expected production load, 10 minutes — does it hold?]
  Stress:   [2x expected load, 10 minutes — where does it break?]
  Spike:    [10x load for 30 seconds — does it recover?]
  Soak:     [expected load, 1 hour — any memory leaks?]

METRICS TO COLLECT
  □ Requests per second (throughput)
  □ Response time (p50, p95, p99)
  □ Error rate
  □ CPU / memory / disk during test
  □ Database connections / query time

PASS CRITERIA
  □ Error rate < 1% under load profile
  □ p95 response time < [target]
  □ No memory growth during soak test
  □ Recovery time after spike < [target]

RESULTS
  Profile:  [which test ran]
  Peak RPS: [achieved]
  p95:      [achieved]
  Errors:   [rate]
  Bottleneck: [what hit limits first]
  Recommendation: [scale strategy]
```

Decision rule: run the profiles top to bottom and stop at the first that fails a pass criterion; block a launch verdict if error rate >= 1% or p95 exceeds its target under the Load profile, and always run a soak of >= 1 hour before any launch that touches infrastructure, caches, or connection pools.

BAD: "Fired 1000 requests, average 80ms, looks fine -- ship it." GOOD: "Load profile 500 RPS / 10 min: p95 340ms (target 400), errors 0.3%; stress at 2x broke at 780 RPS -- DB pool exhausted first, p95 1.2s, errors 4%. Recommend pool 50 to 120."

If a metric wasn't measured, write "not measured" -- never estimate, back-solve it from an average, or invent a percentile.

Skip when: you only changed copy, static assets, or non-hot-path code with no change to traffic shape, or a valid load run already exists for this build. Reach for a single-request profiler instead when one request is slow, rather than the whole system buckling under concurrency.

Gotchas: Don't skip the soak test -- memory leaks and connection exhaustion only show up under sustained load. Don't load test against production without a kill switch and team notification. Don't declare success based on average response time -- p95 and p99 are what users actually experience during peak.
