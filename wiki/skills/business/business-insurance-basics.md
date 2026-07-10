---
name: business-insurance-basics
description: Use when deciding what business insurance a company needs at its stage — first customers, first employees, first enterprise contract, or first institutional investors. Produces a coverage ladder mapped to stage triggers, limit starting points, and a broker briefing sheet. A licensed broker places coverage — not insurance advice.
---

# /business-insurance-basics — The Coverage Ladder

Use to map which insurance coverages a company actually needs at each stage, so you buy protection when a trigger event demands it — not a bundle of premiums a checklist suggested.

**Persona: Risk Coverage Mapper.** Acts as the operator who translates business events (first hire, first enterprise deal, first VC check) into a coverage shopping list and a clean briefing for the broker. Does NOT recommend specific carriers, set final limits, or interpret policy language — a licensed commercial broker places coverage and reads the exclusions. Not insurance advice.

Buy insurance by **trigger, not by fear**. Rung 1, operating at all: **general liability** (~$1M/$2M limits is the standard ask; often bundled with property as a BOP) — landlords and customers will demand the certificate before you feel the risk. Rung 2, first employee: **workers' comp** (legally required in most states from employee #1) and usually employer's liability alongside. Rung 3, selling a product or advice: **E&O/professional liability** — and for software companies in 2026 this means a combined **tech E&O + cyber** form, because a bad deploy that leaks data is one incident that pure-play policies argue about; $1M cyber is the common floor, and enterprise MSAs increasingly stipulate $2-5M — read your customers' insurance clauses BEFORE quoting, since the premium belongs in your pricing. Note cyber carriers now effectively underwrite your security posture: no MFA, no EDR, no tested backups commonly means declined or exclusion-riddled coverage, so fix controls before applying. Rung 4, institutional investors or a real board: **D&O** — most term sheets require it at close, ~$1M per $10-15M raised is a common early scaling heuristic, and no serious outside board member joins without it. Add **EPLI** (employment practices) around ~10-15 employees, when HR-claim probability stops being negligible, and **key person** life only if a lender or lead investor requires it. Digital-first brokers (Vouch, Embroker, Founder Shield) quote startup stacks in days; an independent commercial broker earns their fee once limits pass ~$5M or the business is unusual. Rule: **Buy each coverage at its trigger event — contract requirement, first hire, first institutional check — and never sign an MSA whose insurance clause exceeds coverage you currently hold.**

BAD: "We're pre-revenue, so we grabbed a cheap GL policy and we'll call ourselves covered for the SaaS pilot" (GL covers slip-and-fall and property damage, not the data breach or the algorithm that corrupts a customer's records — the pilot's real exposures are tech E&O and cyber, which GL explicitly excludes). GOOD: "The pilot MSA requires $2M tech E&O and $2M cyber — get Vouch and one independent broker quoting that this week, and confirm MFA/EDR/backup answers before the application."

```
COVERAGE LADDER
════════════════
STAGE TRIGGERS HIT: [operating · first hire · first customer contract · first raise]
IN FORCE: [coverage → limit → carrier → renewal date]
GAPS: [trigger met, coverage missing → GL $1M/$2M · WC · tech E&O+cyber $1-2M · D&O · EPLI]
CONTRACT REQUIREMENTS: [customer/lease → clause → limit demanded vs held]
BROKER BRIEF: [headcount · revenue · data types held · security controls (MFA/EDR/backups) · raise status]
NEXT REVIEW: [renewal date | next trigger event]
```

Skip when: pre-incorporation side project with no customers, employees, or contracts — there's no insurable business yet; revisit at the first of those.

Gotchas: buying limits to feel safe instead of reading what customer contracts actually require — the MSA's insurance clause is the real spec. Letting coverage lapse mid-contract because renewal wasn't calendared; certificates of insurance get audited at the worst time. Answering the cyber application optimistically ("yes, MFA everywhere") — misstatements on the application are the classic grounds for denied claims. Assuming D&O can wait until the Series A closes, when the term sheet requires it in force AT close.
