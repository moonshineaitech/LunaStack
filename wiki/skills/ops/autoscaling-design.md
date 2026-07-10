---
name: autoscaling-design
description: Use when designing or fixing autoscaling — replicas thrashing, scaling too late, or cloud bills spiking. Produces an autoscaling spec with load-tracking signals beyond CPU, asymmetric scale-up/scale-down behavior, min-replica floors, prewarming plan, and hard cost guardrails.
---

# /autoscaling-design — Scale on What Users Feel, Up Fast, Down Slow

Use to design autoscaling around real demand signals with asymmetric response — aggressive up, reluctant down — inside explicit cost ceilings.

**Persona: The Elasticity Engineer.** An SRE who treats CPU as a lagging proxy and scales on what actually queues: requests in flight, queue depth, p95 latency. Builds the cost guardrail into the scaler, not the postmortem. Does NOT set min=1 on anything user-facing, and does not let an autoscaler own an unbounded budget.

CPU is the worst common signal: it lags demand, saturates near 100% just as you need headroom, and misses I/O-bound and queue-bound workloads entirely. Prefer demand-side signals: **concurrent requests per replica** (Knative/Cloud Run's model — the best default for HTTP), **queue depth per worker** via KEDA scalers (SQS, Kafka lag, Redis streams) for async fleets, and p95 latency only as a *guard* signal, never primary (latency-driven scaling feeds back on itself). Target ~60-70% of measured per-replica capacity so you have headroom for the scale-out lag. Behavior must be asymmetric — **scale up fast, down slow**: up policy adds ~100% of current replicas per 30-60s with zero stabilization; down policy removes ≤10% per minute with a **stabilization window of ~300s** (HPA `behavior.scaleDown` exists precisely for this — the default 5-minute window is right; teams who shorten it buy thrash). Set **min-replica floors** from p99 baseline traffic plus one failure domain (min ≥2, spread across zones); scale-to-zero is for genuinely idle async work, never latency-sensitive paths. Prewarm what's slow to start: pause-pod/overprovisioning placeholders or Karpenter-provisioned headroom for nodes, warm pools for VMs, provisioned concurrency for Lambda when cold starts exceed your latency budget; if pod-ready-to-serving exceeds ~60s, fix the image/JIT/cache warmup before adding replicas. Cost guardrails are part of the design: a max-replica cap sized to ~3x observed peak, Karpenter `limits` on total CPU/memory, and a billing alert at the cap's dollar value — an autoscaler without a ceiling is a self-inflicted DDoS amplifier. Rule: **Scale up on demand signals with no stabilization delay; scale down at ≤10%/min behind a ~5-minute window — never make the two symmetric.**

BAD: "HPA on 80% CPU, min 1, max 100 — it'll find the right size" (scales after users already queued, thrashes on CPU noise, single-replica cold spots, and a 100x cost exposure nobody signed off). GOOD: "KEDA on SQS depth targeting 100 msgs/worker; min 2 across zones, max 24 (~3x peak); scale-up doubles per 30s, scale-down 10%/min after 300s; billing alert at max-fleet cost."

```
AUTOSCALING SPEC
════════════════
SIGNAL: [concurrency/queue-depth/RPS per replica] · TARGET: [~65% of measured capacity]
UP: [+100%/30s, stabilization 0s] · DOWN: [-10%/min, stabilization 300s]
FLOOR: [min N ≥2, zones: N] · CEILING: [max N ≈ 3x peak · $/day at ceiling: $N]
PREWARM: [headroom pods / warm pool / provisioned concurrency — cold start: Ns → budget Ns]
LOAD TEST: [date · signal verified to lead saturation by ≥N s]
```

Skip when: traffic is flat and known (fixed replicas + capacity review beats a scaler), or a batch system already owns worker counts.

Gotchas: scaling on latency creates a feedback loop — more replicas, cold caches, worse latency, more replicas; per-pod resource *requests* set too low make CPU-based signals lie even when used as guards; HPA and VPA fighting over the same deployment thrash it — pick one owner per dimension; and nobody load-tests the scale-*down* path, so the first big drain reveals connection-drain and PDB misconfigurations at 2 a.m.
