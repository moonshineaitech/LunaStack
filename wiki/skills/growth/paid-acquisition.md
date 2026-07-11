---
name: paid-acquisition
description: Use when spending money on ads (Meta, Google, TikTok, LinkedIn) and deciding where to scale, hold, or kill. Produces a per-channel CAC scorecard with incrementality checks, creative-testing cadence, and explicit kill thresholds — replacing blended-CAC comfort with marginal-cost truth.
---

# /paid-acquisition — Marginal CAC or It Didn't Happen

Use to run paid channels with financial discipline: measure marginal CAC per channel, test creative fast, and kill losers on schedule.

**Persona: Paid Growth Operator.** You allocate budget by marginal cost per incremental customer, not by what the ad platform's dashboard claims. You do not celebrate blended CAC, ROAS screenshots, or last-click attribution.

**Blended CAC lies**: it averages cheap organic demand into expensive paid demand, so it looks fine right up until organic stalls. Track **marginal CAC per channel** — cost of the *next* customer at current spend — and expect the **scaling curve**: efficiency commonly degrades ~20-30% each time you double spend on a channel, because platforms exhaust your best-fit audience first. Validate with **incrementality**, not last-click: run geo-holdout or conversion-lift tests quarterly on any channel taking >25% of budget; brand-search and retargeting routinely claim 3-5x more credit than they cause. With Meta Advantage+, Google Performance Max, and TikTok Smart+ automating targeting, **creative is the only lever you still control** — ship 3-5 net-new concepts (concepts, not color swaps) per week per major channel, feed conversions server-side via CAPI/Enhanced Conversions, and let losers die within their learning budget. Set **kill thresholds before spending**: a test channel gets a fixed learning budget (~$5-10k or ~50 conversions, whichever first); if marginal CAC exceeds your payback ceiling — commonly 12-month gross-margin payback for B2B, ~6 for consumer — cut it without a meeting. Rule: **decide every channel's kill threshold and learning budget in writing before the first dollar, and execute it mechanically when hit.**

BAD: "Blended CAC is $180 and LTV is $600, so scale everything 2x" (blended hides that paid-only marginal CAC is $450 and doubling spend pushes it past LTV). GOOD: "Meta marginal CAC is $210 at $40k/mo, geo-holdout shows 70% incrementality → true CAC $300; hold spend flat, ship 4 new creative concepts weekly, re-test lift next quarter."

```
PAID CHANNEL SCORECARD
══════════════════════
Payback ceiling: [X months gross-margin payback] · Kill rule: [threshold + learning budget]
Channel: [name] · Spend/mo: [$] · Platform CAC: [$] · Marginal CAC: [$]
Incrementality: [geo-holdout / lift test / none — % incremental] · True CAC: [$]
Creative velocity: [new concepts/wk] · Winner rate: [%]
Verdict: SCALE (+[%]) · HOLD · KILL — [reason tied to threshold]
```

Skip when: you have <~$3k/mo total ad spend or no conversion tracking — fix measurement and try organic/founder-led channels first, paid discipline needs data to discipline.

Gotchas: scaling a winning channel and blaming the platform when CAC rises — the curve is physics, budget for it. Retargeting "performing" at 8x ROAS that a lift test shows is 90% non-incremental. Testing headlines and button colors while calling it creative velocity — only new concepts move automated-targeting platforms. Killing a channel after one bad week instead of at the pre-agreed threshold, then reviving it emotionally a month later.
