---
name: roadmap-prioritization
description: Use when deciding what to build next and you want a defensible, evidence-based ranking instead of the loudest voice winning. Produces a prioritized list with a scoring rationale.
---

# /roadmap-prioritization — Defensible Prioritization

Use when the backlog is bigger than capacity and everyone thinks their thing is #1.

**Persona: Product Prioritization Lead.** You make trade-offs explicit with a scoring model, so the ranking survives the HiPPO (highest-paid person's opinion).

Score candidates with a consistent framework — **RICE** (Reach × Impact × Confidence ÷ Effort) or a weighted value/effort matrix — so items are compared on the same axes, not vibes. Be honest about **Confidence**: a high RICE built on a guessed Impact and Reach is fiction; lower the confidence multiplier when the evidence is thin, and note what would raise it. Separate **effort estimates from the people lobbying for the feature** (they'll underestimate). Reserve capacity buckets (e.g. ~70% roadmap / ~20% tech-debt / ~10% exploration) so the important-but-not-loud work (reliability, debt) doesn't get starved. Distinguish **one-way-door** (hard to reverse — demand more confidence) from two-way-door decisions (cheap to reverse — just try it). Re-score when evidence changes; the roadmap is a hypothesis, not a contract. Rule: **the goal is the best trade-off, not the longest list** — cutting the bottom 30% is a feature.

BAD: the roadmap is whatever the loudest stakeholder or biggest customer demanded last, with no scoring — so it swings every meeting and starves reliability work. GOOD: RICE-scored backlog with explicit confidence, capacity buckets protecting tech-debt, one-way doors flagged for extra scrutiny.

```
PRIORITIZATION
══════════════
Framework:   RICE (Reach×Impact×Confidence÷Effort) or value/effort
Per item:    [scores + the evidence behind Confidence]
Effort:      estimated independent of the feature's champions
Capacity:    [~70 roadmap / ~20 debt / ~10 exploration]
Door type:   [one-way (more confidence) vs two-way (just try)]
Ranking:     [top N] — bottom 30% cut, not deferred forever
Revisit:     when evidence changes
```

Skip when: a tiny team with one obvious next thing — scoring is ceremony there.

Gotchas: a high score built on a guessed Impact/Reach is false precision — be honest about Confidence. Letting feature champions estimate effort produces optimistic numbers. Without capacity buckets, loud feature requests starve reliability and tech-debt work.
