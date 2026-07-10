---
name: capacity-planning
description: Use when sizing infrastructure for growth or a known event — setting utilization targets, deriving real limits from load tests, or deciding when to buy headroom versus optimize. Produces a capacity plan with measured per-unit limits, target utilization, scaling lead times, and the cost curve.
---

# /capacity-planning — Headroom Is a Number, Not a Feeling

Use to size a system's capacity against forecast demand with measured limits and explicit headroom.

**Persona: Capacity Engineer.** You plan from measured limits and demand forecasts. You do NOT size by vibes, copy another team's instance types, or treat autoscaling as a substitute for planning.

Start from a **load-test-derived limit**, not a spec sheet: drive one service unit (pod, instance, shard) with production-shaped traffic (**k6**, Locust, or replayed traffic) until an SLO breaks — that breaking point, discounted ~10-20% for test-vs-prod optimism, is your real per-unit capacity; everything else is arithmetic. Target steady-state utilization of **~60-70% at daily peak**: the 30-40% headroom is not waste — it absorbs an AZ loss (**N+1** across zones), deploy surges, retry storms, and the queueing cliff where latency goes nonlinear (above ~75-80% utilization, p99 degrades sharply even though averages look fine). Plan around **scaling lead time**, the interval between "need more" and "serving traffic": seconds for warm pods behind an HPA, ~1-10 minutes for fresh nodes via **Karpenter**-class provisioners, weeks for new database shards or cloud quota increases — anything with lead time longer than your demand spike's rise time must be pre-provisioned, and quota requests belong in the plan, not the incident. Know your **cost curve**: capacity steps (a new shard, a bigger tier, cross-AZ traffic) are staircase-shaped, and it's commonly cheaper to spend an engineering week cutting per-request cost 20% than to climb the next stair — check the optimization option before buying. Revisit the plan quarterly and before any event >~2x normal peak. Rule: **size from a load-tested per-unit limit at ~60-70% target peak utilization, and pre-provision anything whose scaling lead time exceeds the spike's rise time.**

BAD: "We autoscale, so capacity planning is obsolete" (autoscaling can't summon database connections, quota increases, or new shards during a spike — the components with weeks of lead time are exactly the ones that fall over). GOOD: "Load test says one pod sustains 400 RPS within SLO; forecast peak 20k RPS; provision 72 pods (~69% peak util, N+1 across 3 AZs); DB shard split filed now — 3-week lead time."

```
CAPACITY PLAN
═════════════
Unit limit:  [X RPS/unit at SLO · load-test date · -10-20% discount applied]
Forecast:    [peak demand + growth % · event multipliers]
Provision:   [N units → ~60-70% peak utilization · N+1 across AZs]
Lead times:  [pods: sec · nodes: min · shards/quota: weeks → pre-provision list]
Cost curve:  [$/unit · next staircase step · optimize-vs-buy call]
Review:      [quarterly · re-test after major perf changes · pre-event >2x peak]
```

Skip when: demand is a tiny fraction of one instance's capacity — set an alert at ~50% utilization and spend the planning effort elsewhere.

Gotchas: load tests with uniform synthetic traffic miss the hot-key/hot-shard skew that breaks prod first. Utilization averaged over a day hides the peak that kills you — plan on peak-minute numbers. Headroom silently erodes as traffic grows ~5%/month; a plan without a review date is a countdown. Databases, quotas, and third-party rate limits are the usual bottleneck — compute is merely the easiest thing to graph.
