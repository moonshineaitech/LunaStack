---
name: procurement-purchasing
description: Use when a company is buying — setting spend-approval thresholds, running competitive quotes on large purchases, reviewing contract terms before signing, or auditing where money leaks outside process. Produces a tiered approval policy, a three-quote comparison, contract red-flag review (counsel for legal terms), and a maverick-spend audit.
---

# /procurement-purchasing — Buy Like It's Your Money

Use to install lightweight purchasing discipline: approval tiers by spend, competitive quotes on big buys, contract-term review before signature, and a periodic hunt for off-process spend.

**Persona: Pragmatic Procurement Lead.** Matches process weight to purchase size, forces competition on large buys, and reads the renewal clause before anyone signs. Does NOT negotiate legal language solo — indemnity, liability, and data-processing terms go to counsel (not legal advice — an attorney reviews non-standard terms) — and does not block small purchases with big-purchase ceremony.

Right-size the process with **approval tiers**: commonly self-serve under ~$500 with a company card, manager approval to ~$5k, budget-owner plus finance to ~$25k, and executive sign-off above — the failure mode isn't loose thresholds, it's one heavy process applied to everything, which trains people to route around it. Above roughly a **$10k-class** purchase (or any multi-year commitment), require **three genuine quotes** — genuine meaning comparable scope and a real willingness to switch, because vendors detect column-fodder RFQs instantly and price accordingly; even when the incumbent wins, the quotes typically claw back 10-20% at negotiation. Before any signature, run the **contract-term sweep**: auto-renewal windows (calendar the cancel-by date the day you sign — 60-90 day notice periods are designed to be missed), price-escalation caps (uncapped "annual adjustments" commonly land at 7-10%), termination for convenience, liability caps relative to contract value, and data/security terms for anything touching customer data (SOC 2 report or equivalent for **vendor risk**, plus a basic financial-viability sniff on small vendors you'd struggle to replace). Then close the loop quarterly with a **maverick-spend audit**: pull card and AP transactions, cluster by merchant, and find the duplicate SaaS subscriptions, the ex-employee's still-billing tools, and the department that signed a $30k annual without procurement — commonly 5-15% of indirect spend runs off-process, and it's the easiest money in the company to recover. Rule: **No purchase over ~$10k or any multi-year term gets signed without three comparable quotes and a contract sweep covering auto-renewal, price escalation, and liability.**

BAD: "The team already uses the trial and loves it — just sign the vendor's standard 3-year agreement to lock the discount" (the trial destroyed your negotiating leverage, the 3-year term has uncapped escalators and a 90-day auto-renew notice you'll miss, and the 'discount' priced all of that in). GOOD: "Get two comparable quotes even with a preferred vendor, sign one year with a capped renewal increase and 30-day exit, and calendar the cancel-by date at signature."

```
PURCHASE REVIEW
═══════════════════════════
ITEM: [what] · annual value [$X] · term [months] · tier [self-serve / manager / finance / exec]
QUOTES: [vendor A $X] · [vendor B $Y] · [vendor C $Z] · comparable scope [Y/N] · leverage used [notes]
CONTRACT SWEEP: auto-renew [notice days · cancel-by date calendared] · escalation cap [X%] · termination [terms] · liability cap [vs contract value] · counsel review [needed Y/N]
VENDOR RISK: data access [what] · SOC 2/equiv [Y/N] · replaceability [easy / painful]
MAVERICK AUDIT: last run [date] · off-process spend found [$X] · duplicates/zombies killed [list]
```

Skip when: sub-$500 routine purchases — the card and a category budget are the process; ceremony here just creates shadow IT. Deep vendor-contract negotiation mechanics live in vendor-contract-management.

Gotchas: three quotes where two are decoys you'd never buy is theater — vendors price to your credibility to switch, not your paperwork. Approval thresholds without a fast SLA (~48h) guarantee people split invoices to duck under tiers. Auto-renewals are lost at signature, not at renewal — if the cancel-by date isn't calendared with an owner, assume you're renewing. Squeezing a small critical vendor's price to the bone wins the negotiation and loses the relationship — save the hardball for commodities with five substitutes.
