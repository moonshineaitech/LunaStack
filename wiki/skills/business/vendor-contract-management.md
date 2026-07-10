---
name: vendor-contract-management
description: Use when vendor spend is unmanaged — surprise auto-renewals, unknown contract end dates, duplicate tools, or a renewal negotiation coming up. Produces a vendor register with a renewal calendar (60-90 day alerts), an auto-renew audit, negotiation prep per renewal, and a consolidation review that ranks overlap by savings.
---

# /vendor-contract-management — Never Surprised by a Renewal

Use to build a vendor register and renewal calendar so every contract gets renegotiated on your timeline, not auto-renewed on the vendor's.

**Persona: Vendor Portfolio Manager.** Acts as the procurement-minded operator who inventories every contract, calendars every renewal and notice window, and preps each negotiation with usage data. Does NOT redline legal terms — counsel handles liability, indemnity, and DPA language; this skill owns money, dates, and leverage.

Start with the register: every vendor, annual cost, contract end date, **auto-renewal clause and notice window**, and the internal owner — pull from the ledger and card statements (Ramp/Brex vendor views surface shadow SaaS nobody admitted to buying). The killer field is the notice window: most B2B contracts auto-renew unless cancelled 30-60 days before term end, so the real decision date is end-date minus notice period. Calendar alerts at 90 and 60 days before THAT date; at 90 days you pull usage (seats provisioned vs. seats active — ~20-30% dead seats is commonly what a first audit finds), decide renew/renegotiate/kill, and open the conversation while you still have the walk-away option. Negotiation basics that reliably work: never accept the first renewal quote on anything over ~$10k/year — a benchmark ask (Vendr and NPI publish price data; peers talk) plus a credible alternative typically moves SaaS renewals 10-20%; trade term length for price only when the tool is proven core (multi-year discounts of ~15-30% are real, but a 3-year lock on a tool you adopted 6 months ago sells your flexibility cheap); ask for the **price-increase cap** (~5-7%/year) at signing, when you have leverage, not at renewal, when you don't. Run a consolidation review twice a year: cluster tools by job (analytics, monitoring, project management), and where two tools overlap >70% in function, kill one — every retained vendor costs admin, security review, and integration surface beyond its invoice. Rule: **Any contract over ~$5k/year without a calendared alert at least 60 days before its cancellation deadline is an unmanaged liability — register it today or expect to pay for an unwanted year.**

BAD: "Legal has the contracts folder somewhere; we'll deal with renewals as the invoices arrive" (the invoice arrives AFTER the 60-day notice window closed — you've bought another year of the tool three teams stopped using in March). GOOD: "Register rebuilt from the GL, every contract's cancel-by date calendared at T-90/T-60, and the $48k analytics renewal opens next week with seat-usage data showing 40% dead seats."

```
VENDOR REGISTER & RENEWAL CALENDAR
═══════════════════════════════════
VENDOR: [name] · owner: [person] · cost: [$X/yr] · term ends: [date] · notice: [N days] → CANCEL-BY: [date]
ALERTS: [T-90 usage review · T-60 decision · T-30 escalate] · auto-renew: [y/n, clause ref]
NEXT 90 DAYS: [renewals due, $ at stake, decision status per vendor]
NEGOTIATION PREP: [usage: N/N seats active · benchmark: $X · alternative: tool · ask: X% / cap 5-7%]
CONSOLIDATION: [overlapping pair → keep/kill → annual savings $X]
```

Skip when: total vendor spend under ~$2k/month across a handful of monthly-billed tools — a shared sheet reviewed quarterly beats process overhead; monthly terms carry no renewal trap.

Gotchas: calendaring the contract END date instead of the cancellation NOTICE date — the only date that matters is cancel-by. Negotiating price but ignoring the uncapped uplift clause that claws back the discount over two renewals. Killing a "redundant" tool before checking which workflows and integrations quietly depend on it. Letting each team own its own renewals — leverage comes from one person seeing total spend with that vendor.
