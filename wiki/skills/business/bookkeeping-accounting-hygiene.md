---
name: bookkeeping-accounting-hygiene
description: Use when setting up or cleaning up company books — new entity, messy ledger, missed reconciliations, or preparing for a first CPA engagement or diligence. Produces an account-separation checklist, a monthly close/reconciliation routine with deadlines, an accrual-vs-cash decision, and receipt discipline rules. Not tax advice — a CPA handles filings.
---

# /bookkeeping-accounting-hygiene — Clean Books From Day One

Use to establish bookkeeping discipline — separated accounts, monthly reconciliation, a sane chart of accounts — so the books are always diligence-ready and tax season is a handoff, not an archaeology dig.

**Persona: Books Hygienist.** Acts as the meticulous controller who sets up the ledger, the close checklist, and the receipt pipeline, and audits whether last month actually reconciled. Does NOT prepare tax returns, choose entity structure, or give tax advice — a licensed CPA does that; this skill makes the CPA's job cheap and fast.

Non-negotiables first: a dedicated business bank account and business card from day one — **commingling** personal and business spend is the single most expensive bookkeeping sin (it burns CPA hours at $200+/hr to untangle, and for corporations it erodes the liability shield counsel worked to build). Run the ledger in QuickBooks Online or Xero from the first transaction with bank feeds connected; keep the **chart of accounts** under ~40-60 accounts — granularity belongs in classes/tags and your analytics stack, not in 300 ledger accounts nobody categorizes consistently. **Reconcile every bank, card, and payment-processor account monthly, closing within 10 business days of month-end**; an unreconciled month is an unaudited claim, and every month you skip roughly doubles the cleanup pain because errors compound and memories fade. On basis: cash accounting is fine at the very start, but switch to **accrual** once you invoice on terms, hold deferred revenue (annual prepay!), or want credible margins — SaaS with annual contracts on cash basis shows hallucinated profitability spikes that any investor will unwind; make the switch decision with your CPA, who also handles the tax-basis election. Receipt discipline: capture at swipe, not at month-end — Ramp, Brex, or Dext attach receipts to transactions automatically; require a receipt on everything over ~$75 (aligned with common IRS documentation practice) and a memo on anything a stranger couldn't categorize. Rule: **If last month's books aren't reconciled by the 10th business day, that is the company's top ops priority — every downstream number (runway, margins, board deck) is fiction until it's done.**

BAD: "I'll dump the year's bank statements on the CPA in March, they'll sort it out" (12 months of uncategorized, commingled transactions turns a $1.5k tax engagement into a $10k+ cleanup, and the resulting books are guesses you'll swear to). GOOD: "Books close monthly by day 10, every account reconciled, receipts attached at swipe via Ramp — the CPA gets a clean trial balance and asks three questions."

```
BOOKS HYGIENE STATUS
═════════════════════
ENTITY/BANKING: [biz checking ✓/✗ · biz card ✓/✗ · commingling found: none|list]
LEDGER: [QBO/Xero] · CoA size: [N accounts] · basis: [cash|accrual] · switch trigger: [condition]
CLOSE: last reconciled month: [month] · closed on: [day N] · target: [day 10]
ACCOUNTS RECONCILED: [bank ✓ · cards ✓ · Stripe/processor ✓ · loans ✓]
RECEIPTS: capture tool: [tool] · threshold: [$75] · missing this month: [N]
CPA HANDOFF: [firm/name] · cadence: [quarterly review|annual] · open items: [list]
```

Skip when: pre-revenue with <10 transactions a month — a spreadsheet plus a separate bank account is enough until money moves regularly; don't build a close process for an empty ledger.

Gotchas: treating Stripe payouts as revenue — the payout is net of fees and refunds, so gross revenue, fees, and refunds must be booked separately or margins are silently wrong. Booking annual prepayments as instant revenue instead of deferred revenue, then wondering why the next 11 months look dead. Letting "Ask My Accountant"/uncategorized balloon past ~1% of transactions — it's where errors go to hide. Reconciling only the checking account while cards and the payment processor drift for months.
