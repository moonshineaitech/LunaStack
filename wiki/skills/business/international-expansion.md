---
name: international-expansion
description: Use when a company is considering entering a new country or region — validating demand signal, choosing entity vs EOR for hiring, localizing pricing, planning support coverage, and scoping per-market compliance. Produces a market-entry sequence ranked by organic pull, an entity/EOR decision, localization plan, and a compliance checklist for local counsel.
---

# /international-expansion — Follow the Pull, Not the Map

Use to sequence international expansion by evidence of demand, pick the cheapest-reversible operating structure per market, and localize pricing and support without building embassies.

**Persona: International Expansion Operator.** Ranks markets by observed organic traction, prefers reversible structures, and treats each jurisdiction's rules as a checklist owned by local counsel. Does NOT pick markets from TAM slides, set up legal entities on intuition, or give legal/tax advice — entity formation, employment law, and data-residency questions go to licensed local counsel and tax advisors per jurisdiction.

Expand where the market is already pulling, not where the map looks big: rank countries by **organic signal** — existing signups, revenue, inbound requests, and support tickets by geography — and enter seriously only where a market already contributes ~5-10% of signups or revenue with zero targeted effort; unprompted willingness to pay in a market you've ignored beats any consultant's TAM model. Structure follows commitment: use an **EOR** (Deel, Remote, Rippling-class) for the first hires — live in days, fully reversible, worth the ~$500-700/employee/month premium — and only form an **entity** when you cross roughly 5-10 employees in-country or hit a hard trigger (enterprise customers requiring a local contracting party, regulated-industry licensing, or EOR cost exceeding entity overhead); entities take months to open, longer to close, and each one is a permanent tax-filing obligation, so counsel and a tax advisor scope every formation (not legal advice). **Price in local terms**, not converted dollars: local currency and local payment rails (SEPA, iDEAL, UPI, Pix — Stripe and Adyen cover most) are table stakes, and purchasing-power-adjusted pricing can be right for self-serve — but geo-discount without fencing and your home-market customers will buy through a VPN, so cheaper regional plans need enforcement or feature differences. **Support-hours coverage** is the quiet churn driver: once a region passes ~15-20% of customers, same-business-day response in their timezone stops being optional — solve with a regional hire or follow-the-sun shift before the NPS gap shows up in renewals. Compliance is per-market and non-transferable: GDPR/UK GDPR, data-residency expectations, consumer-protection and withdrawal rights, VAT/GST registration — checklist it per country with local counsel, because compliance in one EU state is not compliance in all of them for employment and consumer law. Rule: **Enter a market seriously only after it shows ~5-10% organic traction unprompted, and start with an EOR — form an entity only past ~5-10 in-country employees or a hard legal trigger.**

BAD: "Germany is Europe's biggest economy — let's open a GmbH, hire a country manager, and launch" (no demand signal, an entity that takes months and notary visits to open and longer to unwind, and a country manager with nothing to manage; you've bought fixed cost where you needed an experiment). GOOD: "France is 8% of signups with zero marketing — hire one French-speaking AE via EOR, localize pricing to EUR with local rails, and revisit entity formation with counsel at 5+ French employees or the first enterprise deal requiring a local entity."

```
MARKET ENTRY PLAN
═══════════════════════════
SIGNAL: [country] · organic share [X% signups / $Y revenue] · inbound evidence [notes] · rank [1..N]
STRUCTURE: [EOR vendor / entity] · trigger check [headcount ~5-10 · enterprise/regulatory need] · counsel engaged [Y/N]
PRICING: currency [local] · rails [SEPA/UPI/Pix/...] · PPP adjustment [Y/N + fencing]
SUPPORT: region share [X%] · coverage [timezone plan] · hire trigger [~15-20% of customers]
COMPLIANCE: [GDPR / data residency / consumer law / VAT-GST] · owner [local counsel — not legal advice]
```

Skip when: home market is still wide open and growth-constrained by execution, not demand — international is a multiplier on a working machine, not a fix for a stalled one. Digital-product sales into a market (via a merchant of record handling VAT) usually need none of this ceremony.

Gotchas: translating the website is not localization — payment methods, invoicing norms (many EU buyers won't pay without a compliant VAT invoice), and sales culture matter more than copy. EOR feels permanent-safe but misclassifying actual contractors as EOR-alternatives, or EOR-ing a country director with signing authority, can create permanent-establishment tax exposure — tax advisor first. Launching three markets at once triples every overhead and masters none; sequence one market per ~2 quarters. Ignoring the support-hours gap because "they can email" shows up 9-12 months later as a regional churn cohort nobody can explain.
