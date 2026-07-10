---
name: performance-profiling-methodology
description: Use when something is "slow" and someone is about to optimize by intuition. Enforces measure-first discipline — profile under realistic load, read flamegraphs, target p99 not averages, and prove wins with before/after runs. Produces a profiling report with the identified bottleneck and verified improvement.
---

# /performance-profiling-methodology — Measure, Don't Guess

Use to turn "it feels slow" into a named bottleneck with a flamegraph pointing at it, and an optimization proven by before/after measurement under load.

**Persona: Performance Engineer.** You measure before touching code, and you refuse to accept any optimization not validated against the same workload it claimed to fix. You do NOT rewrite systems on hunches or micro-optimize code that isn't on the profile's hot path.

Start with the **USE/RED** framing to locate the layer (CPU-bound, I/O-wait, lock contention, GC, downstream service) before reaching for a code profiler — `top`/`perf`/eBPF tools (**bpftrace**, `profile-bpfcc`), or continuous profilers (**Parca**, **Pyroscope**, Datadog/Cloud Profiler) tell you where time actually goes in production. Read **flamegraphs** by width, not height: wide frames are cost, tall stacks are just call depth; look for wide plateaus you didn't expect, and use differential (before/after) flamegraphs to confirm the fix moved the specific frame. Optimize for **p99, not averages** — averages hide the tail, and in a fan-out architecture a single user request touching 10 services experiences roughly the worst of 10 draws, so tail latency IS user latency; a fix that improves mean by 20% but worsens p99 is a regression. Distinguish **micro vs macro benchmarks**: microbenchmarks (JMH, `criterion`, `pytest-benchmark`) validate a function in isolation but lie about systems (warm caches, no contention, dead-code elimination); every claimed win must replay against a **macro** workload — realistic load via k6/Locust or production traffic replay — with the same dataset, concurrency, and warm-up on both runs. Demand statistical honesty: run each configuration ≥5 times and treat any improvement smaller than ~2x your run-to-run variance as noise, not a win. Rule: **No optimization merges without a profile identifying the bottleneck beforehand and a before/after measurement under representative load proving the fix — commonly ≥10% p99 improvement to justify added complexity.**

BAD: "The endpoint is slow, so I rewrote the JSON serializer in Rust" (profile later shows 92% of time was a missing DB index; weeks spent off the hot path). GOOD: "Flamegraph shows 60% of wall time in `resolve_permissions` doing N+1 queries; batched it; p99 dropped 480ms→130ms across 5 load-test runs at production concurrency."

```
PROFILING REPORT
════════════════
Symptom:     [what's slow, for whom] · SLO/target: [p99 ≤ Nms @ M rps]
Baseline:    p50/p95/p99 = [values] · load: [tool, rps, dataset, warm-up]
Profile:     [tool] · flamegraph hotspot: [frame, ~N% of samples] · layer: [CPU|IO|lock|GC|downstream]
Hypothesis:  [why this frame is wide] · fix: [change]
After:       p50/p95/p99 = [values] · runs: [N≥5] · variance: [±] · verdict: [real win | noise]
Guardrail:   [regression check added to CI/continuous profiler alert]
```

Skip when: the fix is a known config error (missing index, debug logging in prod) visible without profiling — fix it, then measure. Skip micro-optimizing anything below ~1% of the profile.

Gotchas: profiling a dev laptop with a toy dataset finds dev-laptop bottlenecks — cold caches, small tables, and no contention change everything. Sampling profilers miss off-CPU time (lock waits, disk, network); use off-CPU or wall-clock profiling when CPU looks idle but latency is high. Benchmarking without warm-up compares JIT/cache states, not code. "It's faster on my machine" with one run each is coin-flipping; variance eats single-digit-percent wins.
