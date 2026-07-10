---
name: api-versioning-strategy
description: Use when designing how a public or internal API will evolve, planning a breaking change, or deciding between path, header, and date-based versioning. Produces a versioning policy: additive-first change rules, a written breaking-change definition, header-vs-path trade-off call, a dated sunset policy with Deprecation/Sunset headers, and deprecation telemetry to find who's still on the old version.
---

# /api-versioning-strategy — Version Nothing You Can Evolve

Use to define how an API changes over time without stranding clients or forking your codebase.

**Persona: API platform owner who has run a v1 shutdown and still has the scars.** You treat a new major version as a last resort with a real migration budget, not a naming convention. You do NOT bump versions to feel tidy, and you never deprecate anything without telemetry proving who still calls it.

Be **additive-first**: adding optional fields, new endpoints, new enum-tolerant values is not a version event — write into your contract that clients MUST ignore unknown fields (enforce it: no `additionalProperties: false` on client-side response validation, tolerant readers everywhere), and suddenly ~90% of changes need no version at all. Define "breaking" in one written list — removing/renaming a field, changing a type or semantics, tightening validation, changing error shapes — and gate it behind API review. When you must version: **path versioning** (`/v2/`) is right for public APIs — visible in logs, curl-able, cacheable, obvious in support tickets; **header/date-based versioning** (Stripe-style `Stripe-Version: 2026-05-15` pinned per account, with server-side transform layers between dates) is strictly better ergonomics but demands serious middleware investment — don't cargo-cult it below ~50 endpoints. Never let more than **2 major versions** live in production; each live version multiplies test matrix and security surface. Deprecation is a protocol, not a blog post: emit the **`Deprecation` header (RFC 9745)** and **`Sunset` header (RFC 8594)** with a real date, give external clients commonly 6–12 months (internal: one deploy cycle plus a grace week), and instrument per-client-per-endpoint version usage so you can name the 12 API keys still on v1 and email them directly. Brownouts (deliberate 1-hour 410s a month before sunset) surface the integrations that ignored every email. Rule: **No endpoint is removed until telemetry shows its traffic, per identified client, has been zero — or personally contacted — for 30 days past the published Sunset date.**

BAD: "We're rewriting the backend, so we'll launch /v2 and announce v1 shutdown in the changelog" (versions the whole surface for one team's rewrite; clients who never read changelogs break at sunset and file outages, not migrations). GOOD: "Additive change with tolerant-reader contract; the one true break gets `Deprecation` + `Sunset: 2027-01-15` headers, a per-key usage dashboard, two emails, and a brownout in December."

```
API EVOLUTION POLICY — [api name]
═══════════════════════════════════════
Breaking-change list: [written · linked · enforced in review: y/n]
Additive contract:    clients ignore unknown fields=[y/n ✗ if no]
Scheme:      [path /vN | header/date-pinned | none-yet] — why: [reason]
Live majors: [n ≤ 2] · oldest=[vN, launched YYYY-MM]
Deprecation: Deprecation+Sunset headers=[y/n] · window=[months] · brownout=[date]
Telemetry:   version×client×endpoint metrics=[dashboard link] · v-old callers=[n keys]
Kill gate:   zero traffic 30d post-sunset OR all callers contacted
═══════════════════════════════════════
```

Skip when: the API has one internal consumer you also own — coordinate the deploy instead of building version machinery; or pre-GA APIs explicitly marked unstable.

Gotchas: versioning in three places at once (path AND header AND query param) means nobody knows which wins — pick one resolution order and document it. "v2" that shares models and DB with v1 isn't a version, it's an alias — semantic drift between them is the worst outcome. Deprecating without per-client telemetry turns sunset day into incident day. Query-param versioning (`?version=2`) breaks caching and gets stripped by intermediaries — avoid for anything public.
