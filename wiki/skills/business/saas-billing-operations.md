---
name: saas-billing-operations
description: Use when setting up or fixing SaaS billing — recovering failed payments, handling upgrades/proration, invoicing, sales-tax exposure, or reporting revenue honestly. Produces a dunning sequence design, proration rules, a tax-registration exposure checklist for CPA review, and revenue-recognition basics for clean reporting.
---

# /saas-billing-operations — The Revenue You Already Earned

Use to run SaaS billing as an operations discipline: dunning that recovers involuntary churn, clean proration paths, tax exposure tracking, and revenue numbers that mean what they say.

**Persona: Billing Operations Owner.** Treats failed payments as recoverable revenue, upgrade friction as a leak, and tax registration as a tracked liability. Does NOT set pricing strategy, close deals, or give tax advice — sales-tax and VAT registration decisions go to a CPA or tax advisor (not tax advice — a licensed professional reviews thresholds and filings).

**Involuntary churn** — failed cards, not unhappy customers — commonly accounts for a fifth to a third of all SaaS churn, and it's the cheapest churn to fix because nobody decided to leave. The stack: card-updater services (Stripe and Adyen run these automatically), **smart retries** on the processor's ML schedule rather than fixed intervals, then a **dunning email sequence** — commonly 4-6 touches over ~21-28 days (day 0 soft notice, then escalating with a one-click update-card link), downgrading or pausing rather than hard-cancelling at the end so recovery stays one click away; well-run dunning commonly recovers 30-60% of failed payments, which drops straight to net revenue retention. **Proration** should make upgrading frictionless and downgrading honest: charge the prorated difference immediately on upgrade (never make a customer wait to give you more money), credit forward on downgrade, and pick one proration behavior globally — per-invoice special cases are where billing bugs breed. On **tax**: US economic nexus commonly triggers around $100k of sales or 200 transactions per state, and EU/UK VAT on digital services applies from the first B2C sale — use Stripe Tax, Anrocket/Anrok, or a merchant-of-record (Paddle, Lemon Squeezy) to monitor exposure, but the register/file decision is your CPA's call, not the dashboard's. And keep reporting honest with basic **revenue recognition**: an annual prepay is cash today but revenue earned monthly over the term — report MRR/ARR from recognized revenue, never from cash collected, or every annual deal inflates the month it lands and lies about the ones after. Rule: **Run a card-updater + smart-retry + ~21-28-day dunning sequence before counting any failed payment as churn — involuntary churn is recovered revenue, not lost customers.**

BAD: "Card failed three retries, cancel the subscription and mark them churned" (a third of these customers never chose to leave — hard-cancelling converts a stale card into a re-acquisition cost and understates your product's real retention). GOOD: "Exhaust card-updater and smart retries, run the dunning email sequence with a one-click card-update link, pause access at day ~28, and only then count churn."

```
BILLING OPS DESIGN
═══════════════════════════
DUNNING: card updater [on] · smart retries [processor-managed] · emails [N touches / ~21-28d] · end-state [pause, not cancel] · recovery rate [X%]
PRORATION: upgrade [charge diff immediately] · downgrade [credit forward] · policy [one global rule]
INVOICING: terms [net-X] · overdue escalation [dunning at +7/+14d] · B2B tax IDs collected [Y/N]
TAX EXPOSURE: nexus watch [states near ~$100k/200 txn] · VAT/GST [markets] · owner [CPA reviews — not tax advice]
REV REC: ARR basis [recognized, not cash] · deferred revenue tracked [Y/N] · annual prepays spread [monthly]
```

Skip when: pre-revenue or under ~20 paying customers — handle failures manually and spend the time on product. A merchant of record also absorbs most of the tax section (but not the rev-rec honesty).

Gotchas: dunning emails from a no-reply address with no update link recover almost nothing — the one-click card-update link is the whole mechanism. Counting paused/past-due accounts in active MRR flatters retention until the write-off cliff. Grandfathering old plans forever turns your billing system into an archaeology site — migrate or sunset legacy plans on a schedule. Nexus thresholds are trailing obligations: by the time the dashboard shows you crossed one, you may already owe back taxes — have the CPA review exposure quarterly, not at year-end.
