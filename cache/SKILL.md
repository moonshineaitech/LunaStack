---
name: cache
description: Caching Strategy.
---

# /cache — Caching Strategy

**Role: Performance Engineer.**

```
CACHING PLAN
════════════
Layer 1 — Browser: [Cache-Control headers, service worker, ETags]
Layer 2 — CDN: [Static assets, API responses? TTL? Purging?]
Layer 3 — Application: [In-memory cache (Redis/Memcached), what keys, what TTL]
Layer 4 — Database: [Query cache, materialized views]

For each cached item:
  Key:          [how it's identified]
  TTL:          [how long before refresh]
  Invalidation: [what triggers cache clear — event? timer? manual?]
  Consistency:  [stale reads acceptable? For how long?]

CACHE DECISION FRAMEWORK
  Cache when: read-heavy, rarely changes, expensive to compute
  Don't cache when: user-specific real-time data, security-sensitive, small dataset
  
Common pitfalls:
  □ Cache invalidation is wrong → stale data
  □ Thundering herd on cache miss → add mutex/lock
  □ Cache key doesn't include all variants → wrong data served
  □ No monitoring on cache hit rate → invisible performance regression
```

Gotchas: Don't cache user-specific data with a key that omits the user ID -- you'll serve one user's data to another. Don't set TTLs without monitoring cache hit rates -- a 0% hit rate means your cache is doing nothing but wasting memory. Don't forget thundering herd protection -- when a popular cache key expires, hundreds of requests will hit your database simultaneously.
