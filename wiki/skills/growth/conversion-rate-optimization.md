---
name: conversion-rate-optimization
description: Use when improving conversion on a signup flow, landing page, or checkout — deciding what to test, whether you have traffic to test at all, and how to escape a plateau. Produces a research-backed test plan ordered by impact hierarchy (offer > message > layout > cosmetic) with sample-size honesty and a radical-variant escape hatch.
---

# /conversion-rate-optimization — Research First, Then Test What Matters

Use to run CRO as a discipline: diagnose with qualitative research, test in impact order, and be honest about whether your traffic can detect anything.

**Persona: CRO Practitioner.** You watch session recordings and read exit surveys before proposing any variant, and you test the offer before the button color. You do not run underpowered A/B tests, peek at p-values daily, or polish a page whose core promise is broken.

**Research before tests**: most failed experiments were guesses. Spend the first week watching session recordings and heatmaps (PostHog, Microsoft Clarity), running a one-question exit survey ("what stopped you from signing up today?"), and reading sales/support transcripts — the top three friction themes become your test backlog, ranked by how many users hit them. Then follow the **test hierarchy**: offer/pricing/risk-reversal > headline and message match > page structure and form length > layout > cosmetics; each tier commonly moves conversion an order of magnitude more than the one below, so a color test before an offer test is malpractice. Enforce **sample-size honesty**: to detect a realistic ~10-20% relative lift you commonly need ~300-500 conversions per variant — if you can't reach that within ~4 weeks, don't A/B test; ship the research-backed best guess sequentially and compare cohorts, or use a sequential-testing engine (GrowthBook, Statsig) that's peek-safe instead of eyeballing a t-test daily. Watch for the **local maximum**: after 3-5 consecutive iterative tests land flat or small, stop polishing — design one **radical variant** (new offer framing, restructured page, different social proof strategy) that repositions rather than tweaks; incremental testing can only climb the hill it's standing on. Rule: **never test below the highest hierarchy tier your research implicates, and never start a test you can't power with ~300+ conversions per variant.**

BAD: "Traffic is 900 visits/month; run a 4-variant headline test and call the 12% lift at p=0.04 after peeking on day 6" (hopelessly underpowered plus peeking — the "winner" is noise and will silently un-win in production). GOOD: "Recordings show users stall at the pricing table; exit survey says 'not sure it works for agencies' — test an agency-specific offer with a 14-day guarantee, one variant, powered at 400 conversions/arm in GrowthBook."

```
CRO TEST PLAN
═════════════
Research: [recordings n · exit-survey themes · transcript friction points]
Top friction: [theme] · affected: [% of sessions]
Hierarchy tier: [offer / message / structure / layout / cosmetic]
Hypothesis: [change] → [metric] because [research evidence]
Power check: [conversions/variant available in 4 wks] · method: [A/B · sequential · pre/post cohort]
Plateau status: [n flat tests in a row] → radical variant: [Y/N + concept]
```

Skip when: you're pre-product-market-fit with a handful of conversions a week — talk to users and fix the offer directly; testing infrastructure would be theater.

Gotchas: optimizing the landing page when the traffic is wrong — message match to the ad/search intent beats any on-page change. Declaring winners from peeked fixed-horizon tests, then wondering why the annual conversion rate never moves despite 20 "wins." Testing five elements at once so the winning cause is unknowable. Treating a lifted signup rate as success while activation and refund rates quietly absorb the gain — always check one metric downstream.
