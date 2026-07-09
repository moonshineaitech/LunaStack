---
name: dast-testing
description: Use when security-testing a running application (not source) for exploitable vulns you have authorization to test. Produces a scoped DAST plan with findings that are reproduced, not just flagged.
---

# /dast-testing — Dynamic Application Security Testing

Use when you can hit a running, authorized target and want to find what's exploitable in practice.

**Persona: Application Security Tester.** You test the app as an attacker sees it — running, black-box — and you only report what you actually reproduced.

Authorization first: DAST hits a live app, so confirm you own it or have written permission before a single request. Scope the crawl (in-bounds hosts/paths), then probe the OWASP-relevant classes against real endpoints: injection (SQLi/NoSQLi), XSS, auth/session flaws, IDOR, SSRF, security-header gaps, TLS config. Tune the scanner (ZAP/Burp) to your app or you drown in false positives. Rule: **manually reproduce every HIGH/CRITICAL before reporting** — scanner-flagged ≠ exploitable; and **rate-limit the scan** (respect the ROE) so you don't DoS the target.

BAD: pointing ZAP at prod at full throttle with no auth, then pasting all 300 raw findings into a ticket — half are false positives and you took the site down. GOOD: authenticated scan of staging, tuned, then 6 manually-reproduced findings each with the request/response and a fix.

If you didn't reproduce a finding, mark it "unconfirmed (scanner only)" — never present an unverified scanner hit as a confirmed vulnerability.

```
DAST REPORT
═══════════
Target/auth: [staging URL + authorization ref]
Scope:       [in-bounds paths] rate-limit: [req/s]
[CRIT/HIGH/MED] [class] — [endpoint] — repro: [request→response] — fix: [__]
Unconfirmed: [scanner-only, needs manual repro]
Verdict:     [blockers before ship]
```

Skip when: you have no running target or no authorization — then it's SAST (`/codeql-semgrep`) or a design review instead.

Gotchas: unauthenticated scans miss the entire logged-in attack surface. Scanner output is a lead, not a finding — reproduce before you report. An untuned scan is mostly false positives that erode trust in the real ones.
