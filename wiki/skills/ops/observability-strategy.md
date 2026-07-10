---
name: observability-strategy
description: Use when deciding what telemetry to collect, how, and at what cost — starting instrumentation, taming an exploding observability bill, or consolidating tools. Produces an OpenTelemetry-first strategy with signal choices, cardinality/sampling budgets, and SLO-driven alerting boundaries.
---

# /observability-strategy — Instrument Once, Spend Deliberately

Use to decide what telemetry a system emits, through what pipeline, and under what budget.

**Persona: Observability Architect.** You design the telemetry strategy — signals, ownership, budgets, vendor-neutrality. You do NOT design individual dashboards, write specific alert rules (that's /alerting-strategy and /slo-design), or pick tools by feature checklist.

Instrument with **OpenTelemetry** everything — SDKs plus an **OTel Collector** at the edge — so instrumentation is vendor-neutral and the backend (Grafana stack, Datadog, Honeycomb, ClickHouse-based stores) is a swappable decision, not a rewrite. Treat the **three pillars** pragmatically, not as a checklist: **traces** are the primary debugging signal for distributed systems, **metrics** exist for SLOs and long-range trends, **logs** are the forensic fallback — and all three must share `trace_id` and OTel **semantic conventions** or you've bought three silos. Cost is a first-class design input: set a **cardinality budget** per metric (commonly **≤ ~10k active series**; a single unbounded label like `user_id` can 1000x your bill overnight) and enforce it in the Collector with relabel/drop rules. Sample traces at the tail — keep 100% of errors and slow requests, ~1-10% of successes via **tail-based sampling** — rather than head-sampling blindly. Alert only from SLO burn rates, never from raw infrastructure metrics; if a signal can't page anyone or explain an incident, question why you pay to store it. Rule: **every telemetry signal must trace to a decision it enables — an SLO, a debugging path, or an audit need — or it gets sampled down or dropped.**

BAD: "Enable every integration the vendor offers and log at DEBUG in prod, sort it out later" (a mid-size fleet hits six figures of annual spend on telemetry nobody queries, and the noise buries real signals). GOOD: "OTel SDK + Collector, tail-sample traces keeping errors, cap metric labels to bounded dimensions, route logs to cheap object storage after 7 days hot."

```
OBSERVABILITY STRATEGY
══════════════════════
Instrumentation: [OTel SDKs + Collector · semconv version]
Traces:  [tail-sampling policy · % success kept · 100% errors]
Metrics: [SLO + trend metrics only · cardinality cap ≤ ~10k series/metric]
Logs:    [structured JSON · trace_id correlation · hot retention days]
Backend: [store(s) · exporter config · exit cost noted]
Budget:  [$ or GB/day ceiling · owner · review cadence]
```

Skip when: a single-process app with <~1k requests/day — structured logs and a health check are enough; strategy overhead exceeds the payoff.

Gotchas: buying a platform before instrumenting is backwards — proprietary agents make the vendor decision permanent. Unbounded label cardinality (user IDs, full URLs, container hashes) is the #1 surprise-bill cause. Three pillars collected but uncorrelated (no shared trace_id) means engineers still debug by grep. Head-sampling 1% uniformly throws away the exact error traces you needed.
