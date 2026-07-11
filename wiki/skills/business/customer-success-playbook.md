---
name: customer-success-playbook
description: Use when building or fixing a B2B customer success motion — churn surprising the team, onboarding stalling, or deciding when to hire CSMs and how many. Produces the onboarding-to-renewal lifecycle map, a health score built on usage signals that actually predict churn, CSM coverage ratios by ACV, and an expansion-signal watchlist.
---

# /customer-success-playbook — Renewals Are Won in Week Two

Use to design the customer lifecycle motion — onboarding, adoption, QBR, renewal — with health scores that predict churn early enough to act and coverage ratios that match account economics.

**Persona: Customer Success Architect.** Acts as the CS leader who maps the lifecycle, defines time-to-value targets, builds the health score, and sets the coverage model. Does NOT handle individual escalations or reactive tickets — support owns break/fix; CS owns outcomes, adoption, and revenue retention.

The renewal is decided in onboarding: define **first value** as a specific customer action (first workflow live, first report shared — not "kickoff completed") and instrument **time-to-value**; if TTV exceeds ~30 days for a mid-market product, onboarding is your churn root cause regardless of what exit surveys say, because customers who never activate churn politely and blame budget. Health scores fail when built from vanity inputs — logins and NPS flatter; build on **breadth × depth × trajectory**: percent of purchased seats active in 30 days (below ~50% is a red flag commonly predicting non-renewal), number of distinct high-value features in weekly use, and usage slope over the last 60 days — a declining slope at a healthy absolute level is the earliest churn signal you'll get, typically a quarter or two ahead. Add the human signals that beat any model: champion departure (track via LinkedIn alerts or Champify-style tooling) and executive sponsor unengaged for >90 days. Coverage ratios by ACV, per common B2B practice: below ~$5-10k ACV, no human CSM — digital/tech-touch only (lifecycle emails, in-app guides via Pendo/Appcues, pooled office hours); ~$10-50k, pooled CS at very roughly ~$2M ARR per CSM; $50k+, named CSMs; $250k+, true account plans with QBRs — and make QBRs about the CUSTOMER's metrics against THEIR goals, or execs stop attending after the second one. Renewal motion starts at T-120 days for annual contracts: health check, value recap, multi-thread beyond the champion. Expansion signals worth an automated watchlist: seat utilization >~80%, usage-limit approaches, new-team invites, feature-gate hits — route these to sales/CS the week they fire, not at the QBR. Rule: **A health score must be validated against last year's churn — if departed customers weren't majority-red at least 90 days before they left, the score is decoration; rebuild it before hiring anyone to work it.**

BAD: "Hire two CSMs to call every account quarterly — our $6k-ACV customers deserve white-glove too" (at $6k ACV a human motion costs more than the revenue retains; the CSMs drown in 300 accounts each and the calls are check-ins, not outcomes). GOOD: "Sub-$10k tier goes tech-touch with lifecycle automation and usage-triggered alerts; the one CSM covers the 40 accounts over $25k with TTV, health, and T-120 renewal plays."

```
CS PLAYBOOK
════════════
LIFECYCLE: onboard [TTV target: ≤30d, first-value = action] → adopt → QBR [$250k+] → renew [T-120 start]
HEALTH SCORE: [seat activation %≥50 · feature depth · 60d usage slope · champion status] · validated vs last-yr churn: [y/n]
COVERAGE: [<$10k: digital · $10-50k: pooled ~$2M ARR/CSM · $50k+: named · $250k+: account plans]
EXPANSION WATCHLIST: [seats >80% · limit hits · new-team invites → routed to: owner, SLA]
RETENTION VIEW: [GRR/NRR by tier] · at-risk now: [accounts, $, play]
```

Skip when: fewer than ~20 customers — founders should personally onboard and talk to every account; a scored, tiered system on N=15 is bureaucracy replacing conversation.

Gotchas: health scores where 80% of accounts are green right up until they churn — trajectory beats snapshot, and unvalidated scores create false comfort. Single-threading every account through one champion, then losing the renewal to a job change you saw on LinkedIn too late. QBRs that recite your roadmap instead of the customer's ROI — attendance decay is the tell. Paying CS teams on activity (calls made, QBRs held) instead of GRR, which buys you meetings, not retention.
