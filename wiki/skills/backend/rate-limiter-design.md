---
name: rate-limiter-design
description: Use when choosing or implementing a rate-limiting algorithm for an API, endpoint, queue, or shared resource. Produces an algorithm choice with justification, a race-free distributed implementation plan, and correct 429 response semantics.
---

# /rate-limiter-design — Rate Limiter Algorithm Selection & Implementation

Use when adding, fixing, or reviewing a rate limiter on an API, endpoint, queue, or contended resource.

**Persona: API-platform / distributed-systems engineer.** You become the person who owns the limit holding *exactly* under concurrency and horizontal scaling — that correctness ranks above throughput, elegance, or line count.

Pick the algorithm from the traffic shape, not habit: **token bucket** when legitimate clients need bursts (capacity `b` = the largest burst you'll tolerate, refill rate `r` = the sustained limit); **leaky bucket** when you must smooth output to a constant downstream rate; **sliding-window counter** for exact-ish enforcement at scale — bounded memory, ≈0.003% of requests mis-classified in Cloudflare's 400M-request analysis; **sliding-window log** only when you need true exactness and can afford O(N) timestamps per key (N = the limit); **GCRA** (redis-cell) when you want token-bucket behavior stored as a single value (theoretical arrival time).

Decision rule: **fixed-window counters admit up to 2× the limit** in a burst straddling the boundary (100 req at 0:59.9 + 100 at 1:00.0). If 2× would breach an SLA, billing cap, or abuse threshold, do not use fixed window. And: if more than **1 instance** serves a given key, state MUST be shared (Redis) — a per-process in-memory limiter on N replicas enforces N× the intended limit.

Make check-and-increment atomic. BAD: `c = redis.get(k); if c < limit: redis.set(k, c+1)` — two concurrent requests both read 99 under a limit of 100, both pass, count reaches 101. GOOD: one Lua script — `local c = redis.call('INCR', k); if c == 1 then redis.call('EXPIRE', k, window) end; return c <= limit` — the increment and TTL land atomically, so a crash between them can't leave a never-expiring key that locks the user out forever.

On breach return **429** with `Retry-After: <seconds>` plus `RateLimit-Limit / -Remaining / -Reset` (IETF RateLimit-headers draft). Decide the Redis-down policy explicitly: **fail-open** (allow) for availability-critical public APIs; **fail-closed** (deny) when the limiter guards billing or abuse.

If you report latency or error numbers, report only values you measured; if not measured, write "not measured" — never estimate.

```
═══ RATE LIMITER DESIGN ═══
Scope:      [per-user | per-IP | per-API-key | global]
Limit:      [N] req / [window]
Algorithm:  [token-bucket | sliding-window-counter | GCRA | leaky | window-log]
  because:  [burst tolerance | exact @ scale | output smoothing | ...]
Store:      [Redis+Lua | redis-cell | in-process (single instance only)]
Atomicity:  [Lua check-and-incr | atomic INCR+EXPIRE]
On breach:  429, Retry-After [s], RateLimit-Remaining [n]
Redis down: [fail-open | fail-closed] — [reason]
p99 added:  [X ms | not measured]
═══════════════════════════
```

Skip when: there is no shared/contended resource, or a gateway/framework limiter (Envoy, Kong, nginx `limit_req`, API Gateway) already enforces it — configure that instead of hand-rolling one.

Gotchas: limit on the key you actually mean — a naive per-IP limit behind a NAT or proxy throttles a whole office as one client (key on the real `X-Forwarded-For` client or the API key); nginx `limit_req` is leaky-bucket, so `burst=` queues excess and you need `nodelay` to serve it immediately; clock skew across app nodes corrupts timestamp windows — derive time from Redis (`TIME`) inside the script, not each server's local clock.
