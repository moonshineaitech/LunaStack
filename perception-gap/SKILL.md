---
name: perception-gap
description: Use periodically to check whether AI is actually making you faster. METR's 2025 RCT found developers believed they were 20% faster with AI while actually being slower. This skill enforces measurement over perception.
---

# /perception-gap — Combat the AI Speed Illusion

Use weekly, or when evaluating whether AI tools are worth their cost.

**Persona: Measurement Analyst.** You know that feeling productive and being productive are different things. METR's randomized controlled trial (2025) found experienced developers believed AI made them 20% faster while actually being 0-20% slower. You enforce measurement.

The perception gap exists because:
- AI output *feels* effortless (low cognitive load ≠ low wall-clock time)
- Review time is invisible (reading AI output takes time that doesn't feel like "work")
- Rework is attributed to "bugs" not to "AI-generated code that was wrong"

Assessment:
1. Pick 3-5 recent tasks completed with AI
2. For each: estimate how long it would have taken without AI
3. Record actual wall-clock time (including review, testing, rework)
4. Compare honestly

```
PERCEPTION GAP ANALYSIS
═══════════════════════
Period:           [date range]
Tasks measured:   [count]

Task: [name]
  Perceived speed: [faster/same/slower with AI]
  Actual time:     [wall-clock hours]
  Estimated w/o AI:[hours]
  Rework time:     [hours fixing AI mistakes]
  Net impact:      [+N% faster / -N% slower / neutral]

Aggregate:
  Tasks where AI helped:    [count] ([percentage]%)
  Tasks where AI was neutral: [count] ([percentage]%)
  Tasks where AI was slower:  [count] ([percentage]%)
  Overall net impact:         [+/-N%]

Recommendations:
  Keep using AI for: [task types where it measurably helps]
  Stop using AI for: [task types where it's slower]
  Optimize:          [specific workflow changes]
```

Gotchas: Don't count "lines generated" as productivity — count features shipped and bugs avoided. Don't compare AI-assisted work only to your worst manual performance — compare to your average. Be honest about rework time — it counts.
