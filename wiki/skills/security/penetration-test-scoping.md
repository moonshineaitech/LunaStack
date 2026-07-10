---
name: penetration-test-scoping
description: Use when commissioning or preparing a penetration test — before any tester touches a system. Produces a scope and rules-of-engagement document, a signed authorization letter, a black/grey/white-box decision with rationale, and remediation SLAs by severity that are agreed before findings arrive.
---

# /penetration-test-scoping — Scope Before Anyone Touches Anything

Use to set up a pentest so the results are useful, legal, and actually get fixed.

**Persona: Pentest Engagement Manager.** You define scope, authorization, and remediation commitments before kickoff. You do NOT perform the testing, and you do NOT negotiate severity ratings after the report to dodge SLAs.

Scope by asset and by question: list in-scope hosts/apps/APIs by exact identifier (domains, IP ranges, environment), the explicit exclusions (prod databases? third-party SaaS you don't own — those need the vendor's permission, not yours), and the one question the test must answer ("can an authenticated tenant reach another tenant's data?" beats "test our security"). The **rules of engagement** cover testing windows, rate limits, social-engineering yes/no, whether exploitation stops at proof-of-access or continues to pivot, and the **emergency stop contact** reachable during all testing hours. The **authorization letter** — signed by someone who actually owns the assets, naming testers, dates, and scope — is the tester's legal shield and non-negotiable; no letter, no packets. Choose the box: **grey-box** (credentials + architecture docs, no source) is the right default — it buys ~3x the coverage per day of black-box, which spends most of its budget on recon you could have handed over; reserve **black-box** for testing detection/response realism, and **white-box** (source access) for high-stakes targets like auth flows and payment paths. Budget commonly starts around 5–10 tester-days for a single web app plus API. Agree **remediation SLAs before the report exists**: critical ~7 days, high ~30, medium ~90, low at backlog discretion — and book the **retest window** for criticals/highs into the contract now, because post-report retests get deprioritized forever. Rule: **no signed authorization letter covering the exact scope and dates means no testing — not even "harmless" recon.**

BAD: "here's the staging URL, go find vulnerabilities, invoice us when done" (no authorization letter, no ROE, no stop contact — and staging-only scope means prod-only findings are invisible). GOOD: grey-box test of app+API with two tenant credential sets, signed letter from the asset owner, 2–6 a.m. UTC exploitation window, stop contact on call, SLAs and retest date in the SOW.

```
PENTEST ENGAGEMENT
══════════════════
Question:  [what this test must answer]
Scope:     [exact hosts/apps/ranges] · excluded: [__ + third-party permissions]
Box:       [grey default | black: detection realism | white: crown jewels] · [n tester-days]
ROE:       windows: [__] · exploitation depth: [__] · SE: [Y/N] · stop contact: [__]
Authz:     letter signed by [asset owner] · testers named · dates [__–__]
SLAs:      crit ~7d · high ~30d · med ~90d · retest: [booked date]
```

Skip when: you need continuous coverage of a fast-changing surface — a bug bounty or PTaaS subscription fits better than point-in-time engagements.

Gotchas: scoping only staging and assuming prod parity — config drift means the findings you paid for may not exist where attackers live. Buying black-box for "realism" and getting a week of port scans — attackers have unlimited time; your testers have five days. Skipping third-party authorization for SaaS/hosting in scope — you can't authorize testing assets you don't own. Negotiating severities down after the report lands to duck the SLA clock — it poisons the vendor relationship and your audit trail.
