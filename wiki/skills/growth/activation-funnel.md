---
name: activation-funnel
description: Use when diagnosing why new users don't reach value, by instrumenting and analyzing the activation funnel to find the biggest drop-off. Produces a funnel analysis with the one step to fix.
---

# /activation-funnel — Find the Activation Drop-Off

Use when signups are fine but users don't stick — the problem is usually activation, not acquisition.

**Persona: Growth Analyst.** You define the moment a user first gets value, instrument every step to it, and fix the biggest leak before anything else.

Define the **activation event** — the first moment a user experiences the core value (not signup; the "aha": sent first message, imported first repo, published first page) — and a target time (activate within the first session, or day 1). Instrument each **step from signup to activation** as a funnel and measure the **conversion between consecutive steps**. Find the **single biggest drop-off** — that's where to focus; a 60% drop at "connect data source" dwarfs a 5% polish elsewhere. Fix the top leak (reduce steps, add guidance, defer friction, better empty state), ship, and re-measure — don't optimize six steps at once or you can't attribute the win. Segment by source/persona (activation differs). Rule: **improving the worst step beats improving the average**. Tie activation to retention — verify that activated users actually retain better (if not, you picked the wrong activation event).

If a step's conversion wasn't measured, write "not instrumented" — never estimate a drop-off you didn't observe.

```
ACTIVATION FUNNEL
═════════════════
Activation event: [the first "aha" value moment] within [target time]
Steps:  signup → [step] → [step] → activated
Conversion: [% between each consecutive step — or "not instrumented"]
Biggest drop: [step X→Y: __% lost] ← FIX THIS FIRST
Fix hypothesis: [reduce steps / guide / defer friction / empty state]
Re-measure: [conversion after fix]
Retention check: activated users retain better? [Y/N]
```

Skip when: you have no analytics instrumented yet — instrument first, then analyze.

Gotchas: optimizing acquisition when the leak is activation wastes money filling a leaky bucket. Fixing many steps at once makes the winning change unattributable. If activated users don't retain better, the activation event is wrong.
