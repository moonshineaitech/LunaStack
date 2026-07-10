---
name: security-headers-csp
description: Use when hardening a web app's HTTP response headers or rolling out Content-Security-Policy without breaking production. Produces the 2026-worthy header set, a nonce-vs-hash CSP decision, and a report-only-to-enforce rollout plan with a violation-rate threshold for flipping the switch.
---

# /security-headers-csp — CSP Without Breaking Prod

Use to ship the header set that actually stops XSS and cross-origin leaks, staged so nothing breaks on flip day.

**Persona: Web Hardening Engineer.** You design the policy, stage the rollout, and read the violation reports. You do NOT rewrite application code to remove inline scripts — you file that work and gate the enforcement flip on it.

The CSP worth writing in 2026 is **nonce-based with `'strict-dynamic'`** — allowlist CSPs are dead weight, bypassable via JSONP and open redirects on any whitelisted CDN. Use **nonces** when responses are dynamically rendered (rotate per response — a static "nonce" is no CSP at all); use **hashes** for fully static/CDN-cached pages where a per-request nonce is impossible. Roll out in `Content-Security-Policy-Report-Only` first, wired to the **Reporting API** (`report-to`) with an endpoint you actually read (report-uri.com or self-hosted); run it ~2 weeks of representative traffic and flip to enforce only when genuine violations (not extension noise — filter `moz-extension://`, `chrome-extension://` sources) are commonly below ~0.1% of pageviews. The rest of the set: **HSTS** `max-age=31536000; includeSubDomains` — add `preload` only after confirming every subdomain serves HTTPS forever, because preload-list removal takes months; **COOP** `same-origin` + **CORP** on your resources (add **COEP** only if you need `SharedArrayBuffer` — it breaks third-party embeds); `X-Content-Type-Options: nosniff`; `Referrer-Policy: strict-origin-when-cross-origin`; a deny-by-default **Permissions-Policy**; and `frame-ancestors` in the CSP instead of the legacy X-Frame-Options. Drop `X-XSS-Protection` entirely — deprecated, and historically introduced bugs. Rule: **never ship an enforcing CSP that hasn't run in report-only against real production traffic — staging traffic lies.**

BAD: copying a "perfect security headers" gist straight into enforcing mode on Friday (inline scripts break checkout; `unsafe-inline` gets added Monday, permanently, and the CSP is now decorative). GOOD: nonce + `strict-dynamic` in report-only for two weeks, violations triaged to 3 real inline-script fixes, then enforce — with `frame-ancestors 'none'` and HSTS already live.

```
HEADER HARDENING PLAN
═════════════════════
CSP: [nonce|hash] + strict-dynamic · frame-ancestors: [__]
Rollout: report-only [start date] → enforce when real violations <~0.1% pv
Reports: [endpoint · extension noise filtered]
HSTS: max-age=31536000 · includeSubDomains · preload: [Y/N + subdomain audit]
Isolation: COOP same-origin · CORP · COEP: [only if SAB needed]
Also: nosniff · Referrer-Policy strict-origin-when-cross-origin · Permissions-Policy [deny-default]
```

Skip when: the surface is a JSON-only API with no browser-rendered responses — CSP does nothing there; spend the effort on CORS correctness and auth instead.

Gotchas: `unsafe-inline` added "temporarily" to stop breakage — it nullifies the policy and never leaves. HSTS preload submitted before auditing subdomains — one HTTP-only internal subdomain is now bricked for months. Treating report-only as done — a policy that never flips to enforce is a dashboard, not a defense. Nonces cached by the CDN — every visitor shares one nonce, attackers included.
