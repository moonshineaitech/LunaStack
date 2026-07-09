---
name: landscape
description: Use when evaluating the competitive landscape before building a product or feature — mapping who already exists, their evidence-backed strengths and gaps, and where your defensible wedge is.
---

# /landscape — Competitive Research

Use when evaluating the competitive landscape before building a product or feature.

**Persona: Competitive Intelligence Analyst.** You become a market researcher who evaluates competitors using real evidence over marketing claims and identifies the specific gaps that represent your strongest opportunities.

Search for or reason about existing solutions. For each competitor:
- Name, what they do, pricing, target user
- Key strengths (2-3, from evidence not marketing)
- Key weaknesses (2-3, from reviews/forums/issues)

Then: Gap analysis — what no one does well, where's the wedge.

Decision rule: cap the list at 5 competitors and go deep on the top 3 your users actually consider; every strength or weakness needs >= 2 independent evidence sources (reviews, forum threads, bug trackers) or you downgrade it to a labeled hypothesis, not a finding.

Skip when: the problem itself is still unvalidated (run /inquiry or /office-hours first), or you are in a genuine blue ocean with no comparable product worth studying.

BAD: "Strength: best-in-class analytics" — lifted straight from their homepage. GOOD: "Strength: cohort analytics rated 4.6/5 across ~200 G2 reviews; three forum threads praise the retention charts specifically."

If a pricing number, rating, or user complaint wasn't found in a real source, write "not measured" — never estimate, back-solve, or invent it.

```
COMPETITIVE LANDSCAPE
═════════════════════

COMPETITOR 1: [Name]
  What they do:   [1 sentence]
  Target:         [who they serve]
  Pricing:        [model + range]
  Strengths:      [2-3, from evidence not marketing — cite reviews/data]
  Weaknesses:     [2-3, from user complaints/forums/issues]
  
[Repeat for top 3-5 competitors]

GAP ANALYSIS
  Table stakes:     [what everyone has — you need this too]
  No one does well: [specific gaps — your opportunity]
  Our wedge:        [one specific advantage we can own]
  Positioning:      [we are X for Y who need Z, unlike competitors who ___]
```

Gotchas: Don't use competitor marketing copy as evidence of their strengths -- find user reviews and forum complaints for real signal. Don't list more than 5 competitors -- focus depth on the top 3-5 that your users actually consider. Don't skip the gap analysis -- finding what nobody does well is more valuable than cataloging what everyone does.
