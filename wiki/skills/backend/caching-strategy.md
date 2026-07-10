---
name: caching-strategy
description: Use when adding a cache layer (Redis/Valkey, CDN, in-process) or debugging stale data, stampedes, or cache-driven latency spikes. Produces a cache design covering hierarchy placement, cache-aside vs write-through choice, an honest TTL-vs-invalidation decision, stampede protection (single-flight, jittered expiry), and a keyed invalidation plan with negative-caching and hit-rate targets.
---

# /caching-strategy — Caches That Lie Predictably

Use to design or review a caching layer so staleness is a chosen budget, not an accident.

**Persona: Staff engineer who treats every cache as a deliberate consistency downgrade.** You decide where in the hierarchy data lives, how stale it may legally be, and what happens when 10k requests miss at once. You do NOT add caches to hide slow queries you haven't profiled, and you never promise "invalidation will keep it fresh" without a written trigger list.

Place data at the outermost tier that tolerates its staleness: CDN/edge (Cloudflare, Fastly) for anonymous reads, shared **Redis/Valkey** for per-user or cross-node data, in-process (Caffeine, `ristretto`, `moka`) only for tiny hot sets — in-process caches multiply staleness by node count and dodge central invalidation, so cap them at seconds. Default to **cache-aside** (read-through on miss, delete-on-write); choose **write-through/write-behind** only when read-after-write consistency is a product requirement and you control every write path — one uncached writer (admin script, another service, a manual SQL fix) silently breaks write-through forever. Be honest about the TTL-vs-invalidation trade: explicit invalidation is only as complete as your enumeration of write paths, so *always* set a TTL as the backstop even when you invalidate — a common ceiling is 5–15 min for user-visible business data, 24h+ for immutable content-addressed keys. Protect against **stampedes** with **single-flight** (Go `singleflight`, Redis `SET NX` lock, or probabilistic early refresh à la XFetch) plus ±10–20% **TTL jitter** so keys don't expire in unison; cache negative results (404s) with a short TTL (~30–60s) or one missing hot key becomes a DB DoS. Version keys (`user:v3:{id}`) so schema changes and mass invalidation are a constant-time prefix bump, not a `KEYS`+`DEL` scan. Rule: **Every cached key gets a TTL even when explicitly invalidated — if you can't state the maximum tolerated staleness in seconds, you're not allowed to cache it.**

BAD: "Cache the query result forever and delete the key whenever we update the row" (the third write path you forgot — a bulk import — serves stale data indefinitely with no backstop). GOOD: "Cache-aside with 10-min jittered TTL, delete-on-write from the one repository method that owns updates, single-flight on miss, and a `v2:` key prefix for emergency flush."

```
CACHE DESIGN — [dataset]
═══════════════════════════════════════
Tier:         [edge | Redis/Valkey | in-process] · nodes=[n]
Pattern:      [cache-aside | write-through | write-behind] — why: [reason]
Staleness:    max tolerated=[Ns] · TTL=[N ± jitter%] · backstop even w/ invalidation: yes
Invalidation: triggers=[write path 1 · path 2 · …] · uncovered paths=[none | LIST ✗]
Keys:         [prefix:vN:id] · flush plan=[version bump]
Stampede:     [single-flight | early refresh] · negative cache=[TTL]
Targets:      hit-rate ≥ [%] · miss p99 ≤ [ms] · alarm on hit-rate drop > [%]
═══════════════════════════════════════
```

Skip when: the uncached query is already <5ms at projected peak load (a cache adds a failure mode, not speed), or data is written and read once (queue it, don't cache it).

Gotchas: caching before profiling hides an unindexed query that a 2-line index fixes. Delete-then-write vs write-then-delete both race under concurrency — pair delete-on-write with a short TTL rather than chasing perfect ordering. A 99% hit rate means the DB must still survive the 1% — plus a cold restart of 100% misses; test cache-off load. In-process caches on autoscaled pods give every node its own stale truth and no way to flush them all.
