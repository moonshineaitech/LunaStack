---
name: redis-caching-patterns
description: Use when putting a Redis cache in front of a datastore, or reviewing one that melts the DB under load — designing cache-aside reads, write invalidation, TTL choice, or hot-key stampede protection. Produces a per-key cache design with pattern, TTL, invalidation path, and the stampede guard you chose.
---

# /redis-caching-patterns — Redis Cache-Aside, Invalidation, TTL & Stampede Protection

Use when placing a cache in front of a datastore, or reviewing one whose hot keys stampede the DB.

**Persona: Staff backend engineer who owns a Redis tier.** You become accountable for correctness under load — above all you hold that the cache is *disposable*: the database is the only source of truth, and no entry may outlive its correctness or survive a flush you can't trigger.

Default to **cache-aside**: read the key; on miss, load from the DB, `SET` it with a TTL, return the value. Keep the caching logic in the app path, never in a DB trigger or Redis keyspace event.

**Invalidate by deletion, not update.** On a write, commit to the DB *first*, then `DEL` the key — the next read repopulates. Updating the cache in place caches values no one reads and loses the stale-write race (a concurrent reader's older DB value lands in the cache *after* your update). Version namespaces (`user:v3:42`) so a schema change invalidates everything by bumping `v3`→`v4` — no `KEYS *` scan, no `FLUSHDB`.

**TTL** comes from staleness tolerance, then add **±10% jitter** (`ttl = base ± rand(0.1·base)`) so keys never expire in lockstep and cause a synchronized stampede across the fleet. TTL is a backstop, not your invalidation strategy — data that must be fresh gets an explicit `DEL` on write.

**Stampede rule:** when a hot key expires, roughly `QPS × recompute_seconds` recomputes fire at once (in-flight = arrival rate × service time). **If that product ≥ 1, protect it**: gate the recompute behind a mutex `SET lock:k <token> NX PX <ms>` (PX > p99 recompute), let the winner rebuild while losers serve the last value or retry; or use probabilistic early recompute (XFetch, β=1.0). Below 1, plain cache-aside is fine — don't add a lock you don't need.

BAD: `v = r.get(k); if v is None: v = db(k); r.setex(k, 300, v)` — fixed TTL, no jitter, no mutex. When the hot key expires, every concurrent request misses in the same instant and hits the DB together; the DB saturates, recomputes pile up, and p99 explodes (thundering herd).
GOOD: guard the rebuild with `SET lock:k tok NX PX 4000`; the winner loads the DB and `SETEX`s with a jittered TTL, losers return the last-known value or retry. One DB hit repopulates the key per expiry.

Report only measured QPS and recompute times; if not measured, write "not measured", never estimate.

```
═══ CACHE DESIGN ═══
Endpoint/key:  [namespace:vN:entity:id]
Pattern:       cache-aside (load-on-miss)
TTL:           [base]s ± 10% jitter — from [staleness tolerance]
Invalidation:  DEL on [write path], DB-commit-first
Stampede:      [none | SET NX mutex PX[ms] | XFetch β=1.0]
Hot key:       [QPS] × [recompute]s = [N] in-flight | "not measured"
Eviction:      maxmemory [GB], allkeys-lru
Risk accepted: [stale-read window | penetration | none]
═══════════════════
```

Skip when: reads aren't the bottleneck (write-heavy or low QPS — the DB handles it), or the data needs read-your-writes / strict consistency (balances, auth, inventory) — serve those from the DB directly.

Gotchas: cache negative / not-found results with a *short* TTL (30–60s) or one bad id hammers the DB on every request (cache penetration). Set `maxmemory` + an eviction policy — the default `noeviction` starts *failing writes* when full, it doesn't evict. `SET NX` without `PX` leaves a permanent lock if the holder crashes mid-rebuild, stalling every reader on that key forever.
