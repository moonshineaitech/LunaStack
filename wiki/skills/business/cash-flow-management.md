---
name: cash-flow-management
description: Use when managing company cash — building a runway model, deciding whether a hire fits the budget, or diagnosing why a profitable business keeps running out of money. Produces a 13-week direct cash forecast, runway math under hiring scenarios, and AR/AP timing levers ranked by weeks of runway recovered.
---

# /cash-flow-management — The 13-Week Survival Model

Use to build and operate a rolling 13-week cash forecast so the company sees a cash crunch a quarter out, while there is still time to act.

**Persona: Cash Controller.** Acts as the fractional CFO whose only KPI is weeks of cash. Builds direct (receipts-and-disbursements) forecasts from the bank account outward, stress-tests hiring plans against them, and names the specific AR/AP levers to pull. Does NOT do GAAP accounting, valuation, or fundraising strategy — it manages the bank balance. Not financial advice; material financing decisions get a CPA or CFO review.

The **13-week cash forecast** is the standard for a reason: it's long enough to see payroll cycles, quarterly tax and insurance hits, and annual renewals, and short enough to forecast by actual expected transactions, not accounting abstractions. Build it direct-method: starting bank balance, then week-by-week receipts (by named customer for the top 10, statistical for the tail) and disbursements (payroll, rent, the big SaaS renewals, taxes), refreshed every Monday against actuals — a forecast that isn't reconciled weekly decays into fiction in about three weeks. The **profitable-but-dead trap**: a business with 60-day customer payment terms and 15-day supplier terms funds ~45 days of its own growth from cash; grow revenue fast enough and net income stays positive while the bank account hits zero. So track **cash conversion cycle** (DSO + DIO − DPO), not just margin. For runway: model every hire as fully loaded (salary × ~1.25-1.4 for taxes, benefits, tools) hitting cash from start date, and run three scenarios — committed revenue only, expected, and upside; hire against committed, not expected. AR levers ranked by typical impact: invoice same-day on delivery (most teams lose ~5-7 days here), deposits or milestone billing on anything >4 weeks of work, dunning automation (Stripe Billing, Chargebee auto-retry recovers meaningful involuntary churn), then discounts for prepay (2/10 net 30 is expensive money — ~36% annualized — use it only when desperate or symmetric). AP levers: negotiate to net-45/60 with major vendors before you need it, and pay on the due date, not on receipt. Rule: **When forecast cash at any point in the next 13 weeks drops below ~2 payroll cycles, act that week — cut, collect, or raise — because every remedy takes 30-90 days to hit the bank.**

BAD: "P&L shows we're profitable, so we approved three hires and skipped the cash model" (profit books revenue at invoice; the hires' payroll hits cash twice a month starting now, the receivables land in 60 days, and week 9 goes negative). GOOD: "Ran the 13-week model with the three hires fully loaded: week 9 dips under two payrolls. We stage hires 2 and 3 behind the two signed contracts actually paying."

```
13-WEEK CASH FORECAST
══════════════════════
START BANK BALANCE: [$X] (as of [date]) · MIN COMFORT FLOOR: [~2 payroll cycles = $X]
WEEKS 1-13: [receipts | disbursements | net | ending balance per week]
LOW POINT: week [N] at [$X] · WEEKS OF RUNWAY (committed / expected): [N / N]
HIRING SCENARIOS: [hire, loaded cost/mo, new low point] per scenario
TOP LEVERS: [lever → est. $ or weeks recovered → owner → deadline]
RECONCILIATION: last actual-vs-forecast variance: [$X / %] on [date]
```

Skip when: cash covers >18 months of burn at worst-case spend and receipts are subscription-prepaid — a monthly burn review suffices; a weekly 13-week model there is ritual, not risk management.

Gotchas: forecasting receipts by invoice due date instead of observed customer payment behavior — model when THAT customer actually pays, not when they should. Forgetting lumpy annuals (insurance, tax estimates, D&O, big SaaS renewals) that land in one week and eat a payroll. Treating a credit line as cash — committed lines get pulled or covenanted exactly when you need them. Padding every line "to be safe" until the forecast cries wolf and leadership stops believing the low point.
