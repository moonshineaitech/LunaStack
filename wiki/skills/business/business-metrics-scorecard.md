---
name: business-metrics-scorecard
description: Use when building or fixing the weekly company scorecard — dashboards nobody reads, 30-metric reports, or metrics without owners or targets. Produces a one-page weekly scorecard: 5-8 metrics max, leading/lagging pairs, a target and named owner per metric, and a variance-commentary discipline that forces explanation over narration.
---

# /business-metrics-scorecard — The Weekly One-Pager

Use to build the single page the company runs on: 5-8 metrics with targets and owners, paired leading and lagging indicators, and variance commentary that explains rather than narrates.

**Persona: Scorecard Editor.** Acts as the ruthless editor of the company's weekly page — cuts metrics, pairs leading with lagging, assigns owners, and rejects commentary that describes the number instead of explaining it. Does NOT set strategy or define metric formulas from scratch (definitions live with finance/data) — it curates what gets weekly attention.

The scorecard's power is its constraint: **5-8 metrics maximum**, because attention divides by the count — a 25-metric dashboard is a place numbers go to be unaccountable, and the cut-down fight over what makes the page IS the strategic alignment work. Build in **leading/lagging pairs**: every lagging outcome (revenue, churn, NRR) gets a leading input you can act on this week (qualified pipeline created, activation rate, at-risk accounts contacted) — a scorecard of only lagging metrics is a rearview mirror, only leading metrics is a speedometer with no destination; the pair also tests your causal model, because when the leading metric moves and the lagging one doesn't for a quarter, your theory of the business is wrong and that's the most valuable thing a scorecard can tell you. Every row carries a **numeric weekly target and exactly one named owner** — a human, never a team; shared ownership is unowned. The weekly review (see /business-operations-cadence for where it sits in the rhythm) runs on **variance commentary discipline**: any metric off target beyond a pre-set threshold (commonly ~10%, or outside its normal week-to-week noise band) gets a written line BEFORE the meeting in the fixed grammar — "expected X, got Y, because Z, therefore we will W" — where Z must be a cause you verified, not a restatement ("churn was high because more customers left" is narration, not explanation), and W is an action with a date or an explicit "watching one more week." Keep the page stable: metrics rotate off only at quarter boundaries with a stated reason, because a scorecard that changes monthly can never show a trend, and trends — not levels — are what a weekly page exists to surface. Rule: **Every metric on the page must have one owner, one numeric target, and a leading or lagging partner — any metric missing one of the three gets cut, no matter how interesting it is.**

BAD: "Add all fifteen KPIs the leadership team suggested so everyone feels represented, and we'll discuss whatever looks off" (fifteen unowned metrics produce a 60-minute status readout where nothing off-target gets a verified cause or an action — representation isn't focus). GOOD: "Fight it down to seven: 3 lagging outcomes each paired with a leading input, plus cash; each with a weekly target, one owner, and written expected/got/because/therefore lines due before Monday's 30 minutes."

```
WEEKLY SCORECARD — WK [N]
══════════════════════════
[metric] · type: [leading↔lagging pair id] · owner: [name] · target: [X] · actual: [Y] · Δ: [±%] · trend: [6-wk arrow]
  variance (if |Δ|>~10%): expected [X], got [Y], because [verified cause], therefore [action + date | watch 1 wk]
PAGE RULES: metrics: [N ≤8] · unpaired: [none] · unowned: [none]
CHANGES THIS QUARTER: [metric added/dropped → reason] (mid-quarter changes: none)
```

Skip when: pre-launch with no repeatable activity to measure — track the 2-3 inputs of your current milestone (interviews done, prototypes tested) and skip the apparatus. For metric formula definitions and diligence-grade rigor, use /saas-metrics.

Gotchas: green-shading everything by setting targets the team already hits — a scorecard where nothing is ever red is measuring aspiration, not operation. Variance commentary written live in the meeting, which produces improvisation, not investigation — it's due in writing before. Swapping metrics whenever one turns embarrassing, destroying the trend line that was the point. Averages that hide the story — pair any mean with its distribution cut (median deal size, top-10-customer concentration) or one whale will steer the company for a month.
