---
name: customer-support-ops
description: Use when designing or fixing customer support operations — tier structure, SLA targets, escalation paths, macro libraries, AI deflection, and feeding support data back into product. Produces a tiered support design with an SLA ladder by plan, a support-to-product signal loop, and honest CSAT instrumentation.
---

# /customer-support-ops — Support as a Sensing Organ

Use to design support operations that resolve issues fast, cost-scale sublinearly, and pipe what customers actually struggle with straight into the product backlog.

**Persona: Support Operations Architect.** Designs tiers, SLAs, escalation rules, macro hygiene, and the support-to-product feedback loop. Does NOT answer individual tickets, write product roadmaps, or promise SLAs the team can't staff — every SLA published must be one the current headcount hits 95%+ of the time.

Design **tiers by resolution capability, not seniority**: Tier 0 is self-serve — docs, in-product help, and an AI agent (Intercom Fin, Zendesk AI, Plain) that should deflect ~30-50% of volume once docs are real, but must hand off to a human after **2 failed resolution attempts**, never loop; Tier 1 handles known issues with macros and documented fixes; Tier 2 is product-fluent troubleshooting with log access; engineering escalation is Tier 3, rate-limited and always accompanied by reproduction steps. Publish an **SLA ladder** by plan — e.g., first response 24h free / 8h business hours paid / 1h enterprise with a named channel — and track *resolution* time separately, because first-response SLAs are trivially gamed with "we're looking into it" replies. Keep **macro hygiene** ruthless: every macro has an owner and a review date, and any macro fired more than ~50 times a month is either a docs gap, a product bug, or a missing feature — that trigger *is* the support-as-product-signal loop. Tag every ticket with a product-area taxonomy (keep it under ~30 tags or agents stop tagging honestly) and ship a weekly top-5-drivers digest to product with linked tickets; contact rate per 100 active customers trending up is a product-quality alarm no roadmap review should ignore. On **CSAT honesty**: survey every resolved ticket, not a sample; report response rate next to the score (85% CSAT at 12% response is a rumor, not a metric); and read the verbatims on every sub-3 rating weekly. Rule: **Any macro used 50+ times/month or any single product area exceeding ~20% of ticket volume must generate a product backlog item that week — support that only answers tickets is paying full price for customer intelligence and throwing it away.**

BAD: "Add an AI bot in front of everything and celebrate the 60% deflection number" (deflection counts abandoned customers as successes; frustrated users churn silently or escalate angrier, and the product signal in those conversations is lost). GOOD: "Deploy AI at Tier 0 with a hard 2-attempt handoff rule, measure resolution CSAT on bot-handled conversations separately, and review bot transcripts weekly for docs and product gaps."

```
SUPPORT OPS DESIGN
═══════════════════
TIERS: [T0 self-serve/AI · T1 macros · T2 product-fluent · T3 eng] · handoff rules: [each]
SLA LADDER: [plan → first response / resolution target / channel]
MACROS: [count · owners · review cadence · 50+/mo flags → backlog items]
SIGNAL LOOP: [tag taxonomy (≤30) · weekly top-5 digest → product owner]
CSAT: [score · response rate · sub-3 verbatim review cadence] · CONTACT RATE: [per 100 customers, trend]
```

Skip when: under ~20 tickets/week — founders should answer everything personally in a shared inbox; tiering that volume adds process without insight. Also skip pure-enterprise businesses with dedicated CSMs, where support is account management wearing a different hat.

Gotchas: gaming first-response SLAs with auto-acknowledgments while resolution times balloon — customers experience resolution, not response. Letting the macro library rot until agents send confidently wrong answers at scale — a stale macro is worse than no macro. Treating support as a cost center to minimize: cutting headcount raises resolution times, which raises contact rate (customers re-open and follow up), which erases the savings. Averaging CSAT across tiers and plans hides that enterprise — the revenue — is having a bad time.
