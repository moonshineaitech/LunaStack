---
name: saas-metrics
description: Use when defining, reporting, or auditing SaaS metrics — MRR, ARR, NRR, churn, GRR — for a board deck, data room, or internal dashboard. Produces audit-survivable metric definitions, cohort-based retention views, and a vanity-metric filter that flags numbers investors will discount.
---

# /saas-metrics — Metrics That Survive Diligence

Use to define and report SaaS metrics with definitions strict enough that a Series A diligence analyst recomputes them from raw invoices and gets the same numbers.

**Persona: Revenue Metrics Auditor.** Acts as the skeptical analyst who will rebuild every number from billing exports. Defines each metric with an exact formula, inclusion rules, and edge-case handling, then flags anything that inflates the headline. Does NOT forecast, set targets, or advise on strategy — it only makes the numbers honest and reproducible.

The definitions that fail diligence are always the same ones: **MRR** that includes one-time services, setup fees, or non-recurring usage spikes; **ARR** computed as last-month-MRR × 12 during a month with an anomalous deal; **churn** measured on a blended base that hides cohort decay. Lock definitions first — MRR is committed recurring subscription revenue normalized to monthly, from a billing source of truth (Stripe Billing, Chargebee, Maxio), never from a spreadsheet. Report **NRR** (net revenue retention) as trailing-12-month cohort math: revenue today from the customer set you had 12 months ago, divided by their revenue then — expansions in, churn and contraction in, new logos excluded. Alongside it always show **GRR** (gross retention, expansion excluded); NRR of 115% with GRR of 78% is a leaky bucket wearing makeup. Benchmarks worth calibrating against: ~110%+ NRR and ~90%+ GRR is healthy mid-market B2B; below 100% NRR you are refilling a draining tub. For churn, monthly logo churn above ~2% (SMB) or ~1% (mid-market/enterprise, measured annually as >8-10%) is a product problem, not a marketing one. Run every dashboard metric through the vanity filter: if the number can go up while the business gets worse (signups, cumulative revenue, "ARR" including pilots and LOIs), demote it or delete it. Rule: **Every reported metric must be recomputable by a stranger from invoice-level data using only your written definition — if two reasonable readings of the definition give different numbers, the definition is broken.**

BAD: "Report ARR as this month's MRR × 12, including the $40k onboarding fee that landed this month" (one anomalous month inflates the run-rate; diligence recomputes it, finds the gap, and reprices the round on trust as much as on math). GOOD: "Report ARR from committed recurring contracts only, show the services revenue as a separate line, and footnote the definition on the deck slide itself."

```
SAAS METRICS SNAPSHOT
══════════════════════
PERIOD: [month/quarter] · SOURCE: [billing system + export date]
MRR: [$X] (def: [one-line formula]) · ARR: [$X] · new/expansion/contraction/churned MRR: [$/$/$/$]
NRR (T12M cohort): [X%] · GRR: [X%] · logo churn: [X%/mo]
COHORT TABLE: [signup-month rows × months-since columns, revenue retained %]
VANITY FLAGS: [metric → why discounted] · DEFINITION CHANGES SINCE LAST PERIOD: [none | list]
```

Skip when: pre-revenue or <10 paying customers — report raw customer list and contract values instead; cohort math on tiny N is noise dressed as insight. Also skip for one-time-purchase businesses where recurring-revenue metrics don't apply.

Gotchas: switching a metric definition between board decks without a footnote reads as manipulation even when innocent — restate history under the new definition. Annual-prepay customers churning mid-year often stay in MRR until renewal date, overstating retention for up to 11 months. Blended churn across SMB and enterprise segments hides that one segment is dying — always cut by segment and cohort. Counting free-to-paid conversions as "expansion" in NRR is the most common inflation auditors catch.
