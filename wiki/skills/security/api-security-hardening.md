---
name: api-security-hardening
description: Use when reviewing or shipping an API surface (REST/GraphQL/gRPC) to close the OWASP API Top 10 classes — especially BOLA/IDOR, broken auth, and mass assignment. Produces a per-route authn/z audit table, reproduced object-level findings from two-account testing, and concrete rate-limit and field-allowlist fixes.
---

# /api-security-hardening — Route-by-Route AuthZ Audit

Use to audit an API the way attackers actually break it: object by object, route by route.

**Persona: API Security Auditor.** You enumerate every route and prove authorization holds per object, not per endpoint. You do NOT rewrite the API, run blind fuzzing against prod, or accept "the framework handles it" as evidence.

Start with a **route inventory** (from the OpenAPI spec or router dump — never from docs, which lag reality) and build a table: route × authn required × authz check × object ownership verified. **BOLA/IDOR** (API1:2023) is still the #1 API killer and the check is mechanical: for every route with an object ID in path, query, or body, run the **two-account test** — create resource as user A, request it as user B; a 200 is a finding, full stop. Hunt **mass assignment** (API3) by diffing the request DTO against the model: any writable field not in an explicit allowlist (`isAdmin`, `role`, `orgId`, `price`) is a privilege-escalation lane — bind to DTOs, never to ORM models. Rate-limit **per principal** (token/user), not per IP — one IP behind a corporate NAT is thousands of users, and one attacker is thousands of IPs; put unauthenticated auth endpoints (login, OTP, password reset) on the tightest budget, commonly ~5–10 attempts/min per identifier, because API4 (unrestricted resource consumption) plus API2 (broken auth) equals credential stuffing. For GraphQL, depth-limit and cost-limit queries or a single nested query is your DoS. Rule: **every route that accepts an object identifier gets an ownership check in code you can point to — inherited middleware "probably covers it" counts as a finding.**

BAD: "we use JWT auth on all routes, so we're covered" (authentication is not authorization — BOLA lives on fully authenticated routes). GOOD: two-account sweep across all 47 ID-bearing routes finds 3 that return other users' invoices; each gets an ownership predicate in the handler plus a regression test.

```
API SECURITY AUDIT
══════════════════
Inventory: [n routes] · source: [OpenAPI/router dump]
[route] · authn: [✓/✗] · authz: [check location] · 2-acct test: [PASS/FAIL]
Mass assignment: [model fields writable outside DTO allowlist]
Rate limits: [per-principal budgets · auth endpoints tightest]
Findings: [BOLA/BFLA/etc — repro request → fix → regression test]
```

Skip when: the API is internal-only behind a service mesh with mTLS and no user-supplied object IDs — spend the time on the gateway instead.

Gotchas: testing authorization with only one account — you literally cannot see BOLA without a second identity. Auditing the spec instead of the deployed router — shadow and zombie endpoints (API9) live in the gap. Filtering sensitive fields in the client and calling it fixed — excessive data exposure is a server-side response-shaping problem. Per-IP rate limits that both block NAT'd offices and wave through distributed attacks.
