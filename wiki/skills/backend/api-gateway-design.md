---
name: api-gateway-design
description: Use when designing or reviewing an API gateway or edge proxy fronting multiple services — auth, rate limiting, routing, or versioning policy. Produces a per-route gateway policy spec with an explicit trust boundary, quota, timeout/retry budget, and deprecation plan.
---

# /api-gateway-design — API Gateway & Edge Policy Design

Use when defining or reviewing the auth, rate-limit, routing, or versioning policy for a gateway fronting many services.

**Persona: Edge Platform Engineer.** You own the single trust boundary between the internet and internal services. Above all: the gateway enforces identity, quota, and blast-radius — zero business logic leaks in, and nothing downstream ever trusts a client-supplied header.

Terminate auth at the edge: validate the JWT signature against cached JWKS, check `exp`/`nbf`/`aud`/`iss`, and pin `alg` to an allowlist — reject `none`, and reject HS256 when you expect RS256 (the algorithm-confusion forgery where your public key is used as an HMAC secret). Cache JWKS ~1h but re-fetch on an unknown `kid`, or a routine key rotation 401s all live traffic. Strip every inbound `X-User-*`/`X-Tenant` header and inject identity yourself only after validation; the client must never assert who it is.

Rate-limit by authenticated principal (API key / tenant / `sub`), never by raw IP — carrier NAT hides thousands of users behind one address. Use a token bucket in Redis via a single atomic Lua script (a separate INCR then EXPIRE races and leaks un-TTL'd keys). On rejection return 429 with `Retry-After` plus `RateLimit-Limit`/`Remaining`/`Reset`.

Numeric rule: set the upstream timeout to at most 80% of the client-facing timeout, cap retries at 2, and set a 20% retry budget (Envoy's default) — otherwise a slow upstream triggers a retry storm that amplifies the outage. Retry only idempotent methods or requests carrying an idempotency key. Open the circuit breaker at ~50% error rate over a rolling window.

Version in the URI (`/v1/`) — visible, cache-friendly, unambiguous. Announce removal with the `Deprecation` (RFC 9745) and `Sunset` (RFC 8594) response headers carrying a hard date; never silently reroute `/v2` traffic into `/v1` handlers.

BAD: an upstream reads `X-User-Id` off the request to identify the caller — any client sets that header and impersonates anyone. GOOD: the gateway strips all inbound identity headers, validates the JWT, then injects `X-User-Id`/`X-Tenant` (or forwards a signed internal token / mTLS SPIFFE ID) so downstream trust is derived, never asserted.

Timeout and error thresholds must come from the upstream's measured p99 latency and error rate; if not measured, write "not measured", never estimate.

```
═══ GATEWAY POLICY: [route pattern] ═══
Auth        [JWT RS256 | API-key | mTLS]  aud=[..] iss=[..]  alg-allowlist=[RS256]
Identity    strip [X-User-*] inbound → inject [X-User-Id, X-Tenant] post-auth
Rate limit  [N] / [window] per [principal]   algo=token-bucket  store=Redis
On limit    429 + Retry-After + RateLimit-{Limit,Remaining,Reset}
Route       [/v1/orders/*] → [orders-svc]  timeout=[≤80% of client] retries=2 budget=20%
Breaker     open at [50%] errors over [rolling window]
Versioning  URI /vN; deprecate via Deprecation (RFC9745) + Sunset=[date]
Fail mode   limiter store down → [fail-open | fail-closed]   ← decide explicitly
═══════════════════════════════════════
```

Skip when: a single service behind a plain reverse proxy with no external clients, or east-west service-to-service traffic already covered by a service mesh (mTLS + policy).

Gotchas: trust only the `X-Forwarded-For` hop your own proxy appended (parse Nth-from-right by trusted-proxy count) — the rest is client-spoofable for rate-limit/allowlist bypass; a fail-open limiter turns a Redis outage into an unmetered DoS while fail-closed 429s everyone, so choose deliberately and alarm on it; caching JWKS without honoring `kid` rotation means the day keys rotate, every token 401s at once.
