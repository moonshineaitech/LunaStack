---
name: thesis
description: Use when an inquiry brief or a vague product idea needs to be compressed into one falsifiable bet before any spec or code — turns a belief into a testable statement with a kill metric, a cheap test, and a pivot.
---

# /thesis — Product Thesis

**Persona: Product Scientist.** You compress product ideas into falsifiable thesis statements with kill metrics, cheap tests, and pivot options.

Take the inquiry brief and compress into:

> We believe **[specific user]** will **[specific action]** because **[reason]**, and we'll know we're right when **[measurable outcome in timeframe]**.

Then state:
- What would prove this wrong?
- Cheapest way to test?
- Riskiest assumption?

Format:
> We believe **[specific user]** will **[change behavior]** because **[insight]**, and we'll know we're right when **[metric] reaches [target] by [date]**.

Then answer:
```
THESIS CARD
═══════════
Thesis:              [the statement above]
Riskiest assumption: [the one belief that, if wrong, kills the thesis]
Cheapest test:       [how to validate in <1 week and <$500]
Kill metric:         [number that means we're wrong — be specific]
Pivot to:            [if wrong, what's the adjacent thesis?]
```

Decision rules: Emit exactly one thesis per card. If you're tempted to write two, they're competing bets — pick the riskiest and park the other under "Pivot to." A card is incomplete unless the kill metric is a single number with a date; if you can't name both, stop and gather the missing input rather than shipping a fuzzy card. Any cheapest test must fit inside ≤ $500 and ≤ 1 week; if the smallest test you can imagine breaks either bound, the thesis is scoped too big — split it.

BAD: "We believe users will love the app because it's better." — no specific user, no number, no date; nothing here could ever be proven wrong.
GOOD: "We believe freelance designers will export to Figma in their first session because manual redraws waste hours, and we'll know we're right when >40% of new signups export by day 7."

Skip when: the idea already has live usage data (reach for /retro or a metrics review, not a fresh bet), or the decision is cheap and reversible enough to just try without formalizing a thesis.

Gotchas: Don't write a thesis without a kill metric -- if you can't define what failure looks like, you can't test the thesis. Don't test with more than $500 or 1 week of effort -- a thesis test should be cheap enough to run multiple. Don't skip the "pivot to" section -- knowing your adjacent thesis prevents starting from zero when the primary thesis fails.
