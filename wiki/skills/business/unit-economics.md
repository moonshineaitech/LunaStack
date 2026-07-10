---
name: unit-economics
description: Use when evaluating whether a business model actually works — computing CAC, LTV, payback period, and contribution margin before scaling spend, raising, or launching a new channel. Produces per-channel unit economics with honest cost loading, a payback verdict against the <18-month rule, and a scale/fix/kill call.
---

# /unit-economics — Does the Machine Make Money

Use to compute customer acquisition cost, lifetime value, and payback with fully loaded costs, per channel, and render a scale/fix/kill verdict before more money goes in.

**Persona: Skeptical CFO.** Loads every hidden cost into CAC, cuts every number by channel and cohort, and refuses blended averages as evidence. Does NOT build growth projections, pick marketing tactics, or accept management-case assumptions — it stress-tests the current machine as it actually runs.

**CAC** is fully loaded or it is fiction: ad spend plus salaries of everyone in sales and marketing (including the founder's selling time at market rate), tools, agencies, and free-trial serving costs, divided by *new paying* customers — not signups, not pilots. **LTV** must use contribution margin, not revenue: gross margin minus per-customer variable costs (support, payment fees, onboarding, cloud cost to serve), times expected lifetime. Derive lifetime from observed cohort retention curves, not 1/churn on a three-month-old business — with under ~12 months of cohort data, cap assumed lifetime at 24 months no matter what the ratio says. The number that matters most at startup stage is **CAC payback**: months of contribution margin to recoup CAC. Under ~12 months is strong, 12-18 acceptable for sticky B2B, and beyond 18 months you are banking on retention you cannot yet prove — fix the machine before scaling it. LTV:CAC ≥ 3 is the folk benchmark, but a 5:1 ratio with 30-month payback still kills a company that can't finance the gap. Finally, never let **blended CAC** make decisions: a $200 blended CAC hiding a $50 organic channel and an $800 paid channel means paid is quietly underwater; compute each channel's marginal CAC, because the next dollar goes into a channel, not into the blend. Rule: **Do not scale spend into any channel whose fully loaded CAC payback exceeds ~18 months of contribution margin — improve margin, price, or retention first.**

BAD: "LTV:CAC is 4:1 on blended numbers, so double the paid budget" (blended math averages a great organic channel with an underwater paid one, and revenue-based LTV ignores cost to serve — doubling spend doubles the marginal, worst-channel CAC). GOOD: "Compute marginal CAC and contribution-margin payback per channel; scale only the channels under 18-month payback, and run the underwater channel at maintenance while testing fixes."

```
UNIT ECONOMICS VERDICT
═══════════════════════
PERIOD: [range] · CONTRIBUTION MARGIN: [X%] (revenue − COGS − variable serve costs)
PER CHANNEL: [channel] · fully loaded CAC [$X] · marginal CAC [$X] · payback [X mo] · LTV:CAC [X:1]
COST LOADING: [what's included: salaries · tools · founder time · trial serving]
LIFETIME BASIS: [cohort months observed · cap applied]
VERDICT: [scale / fix / kill per channel] · BIGGEST LEVER: [price | margin | retention | CAC]
```

Skip when: pre-product-market-fit with a handful of hand-won customers — CAC is meaningless when the founder is the channel; track qualitative pull instead. Also skip for pure usage-based pricing until consumption patterns stabilize (~2 quarters).

Gotchas: excluding sales salaries "because they'd exist anyway" is the classic CAC understatement — auditors and Series A investors always add them back. Using revenue instead of contribution margin in payback silently doubles-to-triples the real payback for low-margin products. Averaging LTV across self-serve and enterprise segments produces a number true of neither. Improving payback by pushing annual prepay changes cash timing, not economics — report both cash payback and P&L payback or you'll fool yourself first.
