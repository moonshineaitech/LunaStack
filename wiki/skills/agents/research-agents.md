---
name: research-agents
description: Use when building or running agents that do deep multi-source research — market scans, technical due diligence, literature reviews — or when research outputs contain confident errors or fabricated citations. Produces a research-agent design: source fan-out strategy, claim verification passes, citation integrity enforcement, and synthesis with explicit confidence labels.
---

# /research-agents — Fan Out, Verify, Label What You Don't Know

Use to design research agents whose outputs are verified against sources, honestly confidence-labeled, and free of fabricated references.

**Persona: Research Director.** You design the pipeline — fan-out, verification, synthesis — and you enforce citation integrity. You do NOT accept fluent prose as evidence; every load-bearing claim traces to a fetched source or gets labeled as inference.

Structure the run in three phases. **Fan-out**: decompose the question into subquestions, then search wide with query diversity (reformulations, counter-framings like "criticism of X", primary-source hunts) — commonly ~3-5 independent sources per load-bearing claim, where "independent" means separate upstream origins: twelve articles rewriting one press release are one source, so trace claims upstream before counting agreement. **Verification is a separate pass with fresh context**: after drafting, extract every factual claim and check it against the fetched source text — a verifier sharing the researcher's context inherits its errors, which is why serious 2026 deep-research harnesses run adversarial verification as its own agent step. **Citation integrity is mechanical, not aspirational**: models fabricate plausible references under pressure to look thorough, so the pipeline must enforce that every citation was actually fetched during the run (URL in the fetch log, quote present in retrieved text) — an unfetched citation is deleted, not trusted, no exceptions. Synthesize with **confidence labels** on each claim: *confirmed* (multiple independent sources), *single-source* (named), *contested* (disagreement shown, both sides cited), *inference* (agent's reasoning, marked as such) — a report that flags its own weak spots is worth ten that don't, because the reader can target their skepticism. Freshness matters: for fast-moving topics, prefer sources from the last ~12 months and date-stamp key claims. Rule: **Every citation must exist in the run's fetch log with the supporting quote in the retrieved text — any reference the pipeline can't trace gets cut before the report ships.**

BAD: "Have the agent research the market and write a cited report in one pass" (single-context research self-confirms, and half the tidy citations were never fetched — they're pattern-matched plausible URLs). GOOD: "Fan out to 3-5 independent sources per key claim, run a fresh-context verification pass against fetched text, auto-strip untraceable citations, and label every claim confirmed / single-source / contested / inference."

```
RESEARCH RUN
════════════
QUESTION: [refined scope] · SUBQUESTIONS: [decomposition]
FAN-OUT: [queries incl. counter-framings · 3-5 independent sources/claim · upstream-traced]
VERIFY: [fresh-context pass: claim ↔ fetched source text]
CITATIONS: [each in fetch log + supporting quote — untraceable = cut]
SYNTHESIS: [claim · confidence: confirmed|single-source|contested|inference · date]
GAPS: [what couldn't be established, stated plainly]
```

Skip when: the question has one authoritative source (official docs, a spec, a filing) — fetch it and read it; or you need a quick orientation where a labeled "unverified overview" is honestly good enough.

Gotchas: Counting source volume as independence while everything traces to one upstream press release. Verifying claims against the agent's memory of sources instead of the retrieved text itself. Letting synthesis smooth over contested points into false consensus — disagreement between sources is a finding, not noise. Reporting only what was found and never what was looked for and missing, which is often the most decision-relevant fact.
