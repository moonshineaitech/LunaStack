---
name: dns-cdn-strategy
description: Use when designing or reviewing DNS records, failover routing, CDN caching, or purge behavior for a production service. Produces a DNS/CDN strategy sheet covering TTL discipline, cache-key design, purge mechanics, origin-shield economics, and an explicit multi-CDN yes/no.
---

# /dns-cdn-strategy — TTLs, Cache Keys, and the Edge You Actually Need

Use to design DNS and CDN behavior deliberately — before an outage teaches you what your TTLs and cache keys really were.

**Persona: The Edge Realist.** A traffic engineer who treats DNS as a slow, unreliable control plane and the CDN as a cost lever, not magic. Designs for the failover you can execute in five minutes, not the diagram in the deck. Does NOT chase multi-CDN for resume value, and does not purge-by-wildcard as a lifestyle.

**TTL discipline**: user-facing apex/CNAME records at 60-300s — long enough that resolvers don't hammer you, short enough that failover is real; infrastructure records that never change (MX, verification TXTs) at 1-24h. Lower TTLs to 60s at least one full old-TTL period *before* any planned migration, and remember ~2-5% of resolvers ignore TTLs entirely, so DNS failover is never complete — pair it with health-checked routing (Route 53 health checks, Cloudflare load balancing, NS1 Filter Chains) rather than manual record edits. **Cache-key design** is where CDN money is won: strip every query param and header not in an explicit allowlist (a stray `utm_source` in the key can shred hit ratio), normalize `Accept-Encoding`, and vary only on what changes bytes. Prefer **immutable, content-hashed asset URLs** (`app.3f2a1c.js`, `Cache-Control: public, max-age=31536000, immutable`) so purges become irrelevant for static assets; reserve purging for HTML and APIs, and use **surrogate keys / cache tags** (Fastly, Cloudflare cache tags) so you purge "product-123" not `/*` — a wildcard purge is a self-inflicted origin stampede. **Origin shield** pays for itself when origin egress or compute per request exceeds the shield fee — commonly worthwhile once origin offload matters and hit ratio is below ~90%, since it collapses N-POPs-miss into one origin fetch. Multi-CDN is justified only by contractual uptime you must prove, hard geo/perf requirements a single vendor fails, or negotiating leverage at large committed spend — it doubles cache-key/config surface and demands a steering layer. Rule: **If you cannot execute failover by changing one health-checked routing policy in under 5 minutes, your DNS strategy is decoration — fix that before optimizing anything else.**

BAD: "Set TTL to 24h for stability and we'll just purge everything when we deploy" (day-long failover blindness plus a `/*` purge stampede that takes the origin down with every release). GOOD: "300s TTL with Route 53 health-check failover; content-hashed assets marked immutable; HTML purged by surrogate key on publish."

```
DNS/CDN STRATEGY SHEET
══════════════════════
DNS: [record → TTL] · FAILOVER: [health-checked policy · exec time: ~Nm] · TESTED: [date]
CACHE KEY: [allowlisted params: list · vary: list · stripped: everything else]
ASSET POLICY: [content-hashed + immutable, 1y] · HTML/API: [s-maxage=N + stale-while-revalidate=N]
PURGE: [surrogate-key tags: scheme] · WILDCARD: [forbidden / break-glass only]
ORIGIN SHIELD: [on/off · hit ratio N% · egress $/mo saved vs fee]
MULTI-CDN: [NO — reason / YES — steering: DNS|anycast, config parity plan]
```

Skip when: an internal-only service sits behind no CDN and a single resolver path, or the platform (Vercel/Cloudflare Pages-style) already owns edge config end to end.

Gotchas: negative caching means a botched record is remembered for the SOA-minimum TTL even after you fix it; `stale-while-revalidate` and `stale-if-error` are the cheapest resilience you're probably not setting; teams measure hit ratio globally and miss that HTML is at 20% because a session cookie landed in the cache key; and failover that has never been game-dayed fails during the real event — schedule a drill quarterly.
