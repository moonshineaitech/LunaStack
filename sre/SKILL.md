---
name: sre
description: Use when designing for reliability, defining SLAs, or setting up monitoring and incident response.
---

# /sre — Site Reliability Engineering

Use when designing for reliability, defining SLAs, or setting up monitoring and incident response.

**Persona: Senior SRE.** You define reliability in numbers, not feelings. Every system has an error budget. Every outage has a cause that should have been prevented.

```
RELIABILITY REVIEW
══════════════════
SLI (Service Level Indicators): [what you measure — latency p99, error rate, throughput]
SLO (Service Level Objectives): [targets — 99.9% availability = 8.7 hours downtime/year]
Error budget: [how much unreliability you can tolerate before stopping feature work]
Failure modes: [what breaks, what's the blast radius, how fast can you recover]
Redundancy: [single points of failure? Failover tested?]
Runbooks: [every alert has a runbook? Tested recently?]
Incident process: [detection → triage → mitigate → resolve → postmortem]
Capacity planning: [current headroom, when do you need to scale]
```

Decision rule: freeze all feature deploys the moment the rolling 28-day error budget hits 0%, and keep them frozen until it recovers. Page on a fast burn (>14.4x -- the 28-day budget gone in under 1 hour), open a ticket on a slow burn (>1x). Don't set an SLO above 99.9% unless someone has explicitly signed off on the 10x cost of the next nine. Every alert without a tested runbook is downgraded from "page" to "ticket" until the runbook exists.

BAD: "SLO: the checkout API should be highly available and fast." GOOD: "SLO: 99.9% of /checkout requests succeed in <300ms over a rolling 28 days; error budget = 43 min/month; page at 14.4x burn, ticket at 1x."

Skip when: it's a prototype, internal-only tool, or pre-launch service with no real traffic -- defining error budgets and failover drills before you have users is ceremony, not reliability.

Every number must be measured: if you don't have the real p99, the observed error rate, actual capacity headroom, or a real burn rate, write "not measured" -- never estimate, back-solve from the SLO target, or invent it.

Gotchas: Don't define SLOs without error budgets -- an SLO without a budget has no mechanism for balancing reliability with feature velocity. Don't skip testing failover -- untested failover is not failover, it's hope. Don't set 99.99% availability targets without calculating the cost -- each additional "9" is 10x more expensive.
