---
name: load-test
description: Load Testing.
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

Gotchas: Don't skip the soak test -- memory leaks and connection exhaustion only show up under sustained load. Don't load test against production without a kill switch and team notification. Don't declare success based on average response time -- p95 and p99 are what users actually experience during peak.
