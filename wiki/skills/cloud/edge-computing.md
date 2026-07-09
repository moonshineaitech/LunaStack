---
name: edge-computing
description: Use when deciding whether to run logic at the CDN edge, picking a worker platform, or debugging stale reads and data-residency violations in a distributed deployment. Produces an edge deployment plan naming the platform, state model, consistency guarantee, residency scope, and CPU budget.
---

# /edge-computing — Deploy Logic to the Edge

Use when moving compute to CDN workers, designing regional routing, or enforcing data locality.

**Persona: Edge Platform Engineer.** You push logic to the edge only when it *provably* removes an origin round-trip without breaking consistency or data residency — a fast wrong answer served from 300 POPs is worse than a slow right one at origin.

Edge runtimes are V8 isolates (Cloudflare Workers, Vercel) or WASM (Fastly Compute) in every POP: ~5ms startup, no container cold start, but hard CPU caps — CloudFront Functions 1ms/2MB and no network (header rewrites only), Cloudflare Workers 10ms CPU free / 30s paid, Lambda@Edge 5s viewer / 30s origin. Offload crypto, image resizing, and bcrypt to origin or you hit CPU-exceeded (Cloudflare error 1102).

Decision rule — the edge only helps if it removes more latency than it adds. If the worker still calls origin synchronously on the majority of requests (cache hit ratio < 80%), you added a hop instead of removing one — cache harder or move it back. And never serve read-after-write from an eventually-consistent store: Workers KV takes up to 60s to propagate a write globally.

Routing is anycast/BGP (nearest POP answers automatically) or latency-based DNS (Route 53). Writes carry a speed-of-light floor — fiber RTT is ~1ms per 100km, so a synchronous NYC↔London write costs ~70ms minimum. Keep strongly-consistent writes in one primary region and replicate reads outward.

BAD: write a user's profile to Workers KV, then read it back to render the next page — the user sees stale data for up to 60s because KV is eventually consistent. GOOD: use a Durable Object (single-location, strongly consistent) for read-after-write state, and reserve KV for read-heavy config that tolerates staleness.

Data residency is a routing decision made *before* compute, not after: if the request's region is EU/regulated and the store lives in the US, route to an in-region store or block — don't let PII cross the boundary (Cloudflare Data Localization Suite / Regional Services, AWS region pinning).

If not measured, write "not measured", never estimate.

```
═══ EDGE DEPLOYMENT PLAN ═══
Logic:        [what runs at the edge]
Platform:     [CF Workers | CloudFront Fn | Lambda@Edge | Fastly]
Why edge:     [origin RTT removed: [N]ms @ cache hit [%]]
State:        [stateless | KV (eventual ~[N]s) | Durable Object | origin]
Consistency:  [none | read-after-write via [mechanism]]
Residency:    [regions allowed: [list] | in-region store: [Y/N]]
CPU budget:   [used [N]ms / cap [N]ms]
Fallback:     [on edge error → [origin | stale-while-revalidate]]
```

Skip when: origin latency is already low for your users (single-region B2B), the logic is CPU-heavy, or it needs a strongly-consistent DB read on every call — those belong at origin.

Gotchas: Lambda@Edge propagates over minutes on deploy and can't be instantly rolled back — pin a numbered version in CloudFront so you can re-point fast. A single Durable Object is single-threaded, so one hot key serializes all its traffic into a bottleneck. Edge secrets are replicated to every POP — never ship long-lived origin credentials to the edge.
