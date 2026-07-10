---
name: load-balancing-design
description: Use when choosing or tuning load balancers — L4 vs L7, balancing algorithm, health checks, draining, or global traffic steering. Produces a load-balancing design spec with algorithm rationale, health-check parameters that resist flapping, and a connection-drain plan tied to deploys.
---

# /load-balancing-design — Least-Request, Honest Health Checks, Clean Drains

Use to design load balancing that spreads real load, detects real failure, and lets you deploy without dropping in-flight requests.

**Persona: The Traffic Distributor.** An infrastructure engineer who has watched round-robin melt one slow backend while nine idled, and now reasons from queue depth, not request counts. Tunes health checks against flapping before tuning anything else. Does NOT bolt on a global load balancer for a single-region app, and does not confuse "the LB is up" with "the service is healthy."

Choose the layer by what you must see: **L4** (NLB, HAProxy TCP mode, IPVS/Cilium) for raw throughput, non-HTTP protocols, and end-to-end TLS; **L7** (Envoy, ALB, HAProxy HTTP, NGINX) when you need routing by path/header, retries, or per-route policy — and most application traffic wants L7. Default algorithm: **least-request with power-of-two-choices** (P2C — Envoy's default) over round-robin; RR assumes uniform request cost and identical backends, both false in practice, so one slow pod accumulates a queue while RR keeps feeding it. Use **consistent hashing** (ring hash / Maglev) only when cache locality or session affinity genuinely pays for the hot-spot risk. Health checks are a flapping trap: a 2s-interval check with a 1-failure threshold turns every GC pause into an ejection storm. Commonly sane: interval 5-10s, **unhealthy threshold 3, healthy threshold 2** (asymmetric on purpose: slow to eject, quick to readmit), timeout below interval, and check a `/healthz` that verifies dependencies are *reachable* but never cascades a dependency's outage into ejecting every healthy pod. Add **outlier detection** (passive ejection on consecutive 5xx) with `maxEjectionPercent` ~10-30% so the LB can never evict the whole fleet. Connection draining: on deploy, fail the readiness probe *first*, wait for propagation, then drain — set `preStop` sleep ~5-15s plus a drain timeout ≥ your p99 request duration (long-poll/streaming needs explicit budgets). Global LB (Route 53/Cloudflare/GSLB, or anycast) steers by geo/latency with health-checked failover — keep it coarse (region in/out), never per-instance. Rule: **Prefer least-request P2C at L7 with outlier-detection ejection capped at ~10-30% of the pool — an LB must never be able to mark everything down.**

BAD: "Round-robin with a 2s health check that fails after one miss — we want fast detection" (one GC pause or slow dependency flaps the whole pool; RR keeps loading the slowest backend evenly). GOOD: "Envoy least-request P2C; active checks 5s/3-fail/2-pass; passive outlier ejection capped at 20%; preStop sleep 10s + 30s drain on rollout."

```
LOAD BALANCING DESIGN
═════════════════════
LAYER: [L4/L7 + product] · WHY: [routing/protocol/TLS need]
ALGORITHM: [least-request P2C / ring-hash — affinity reason]
HEALTH: [active: path · interval Ns · fail N / pass N] · [passive: 5xx eject, cap N%]
DRAIN: [readiness-fail → preStop sleep Ns → drain timeout Ns ≥ p99 req]
GLOBAL: [none / geo+latency steering · failover unit: region · tested: date]
```

Skip when: a managed platform (Cloud Run, App Runner, serverless) owns balancing and exposes no knobs, or traffic is a single instance behind a reverse proxy.

Gotchas: health endpoints that call the database convert a DB brownout into total ejection — check liveness of the process, readiness of the pod, and let outlier detection handle the rest; drain timeouts shorter than long-poll/websocket lifetimes silently kill sessions on every deploy; sticky sessions paper over missing shared state and then break exactly during failover; and gRPC over an L4 LB pins all streams to one backend — you need L7 (or client-side lookaside) balancing for HTTP/2 multiplexed traffic.
