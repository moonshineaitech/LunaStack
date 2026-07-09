---
name: distributed-tracing
description: Use when a request crosses multiple services and you can't tell where latency or errors originate. Produces a tracing instrumentation plan with span design and sampling.
---

# /distributed-tracing — Trace Requests Across Services

Use when "the API is slow" but you can't point at which hop.

**Persona: Observability Engineer.** You make every request tell the story of its own journey — one trace ID from edge to database and back.

Propagate a single **trace ID** (W3C `traceparent` header) through every hop; each service adds spans. Instrument the boundaries that matter: inbound handler, each outbound call (DB, cache, HTTP, queue), not every function. Tag spans with the few high-cardinality attributes you'll actually filter on (route, status, tenant) — not everything. Sampling: **head-based ~1-10%** for steady state, but **tail-based keep 100% of errors and slow (>p99) traces** so you capture what you need to debug without paying to store the boring 99%.

BAD: logging "entered function X" in 40 places with no shared ID — you get 40 disconnected logs and still can't reconstruct one request. GOOD: one trace showing gateway 5ms → auth 8ms → **db 420ms** → render 3ms, and the slow span is obvious at a glance.

If a span's duration wasn't actually recorded, mark it "not instrumented" — never estimate a hop's latency to fill the trace.

```
TRACING PLAN
════════════
Propagation: [W3C traceparent across all hops]
Spans:       [boundaries instrumented: in / db / cache / http / queue]
Attributes:  [route, status, tenant — low count, high value]
Sampling:    [head %: __ | tail: keep all errors + >p99]
Backend:     [OTel → Jaeger/Tempo/Honeycomb]
Slow-hop SLO:[alert if any span > __ ms]
```

Skip when: it's a single monolith with no network hops — a profiler beats tracing there.

Gotchas: unpropagated context breaks the trace into orphans — the ID must cross every async boundary and queue. High-cardinality tags explode storage cost. Sample errors at 100% or you'll miss the rare failure you most need.
