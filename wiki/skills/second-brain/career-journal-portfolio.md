---
name: career-journal-portfolio
description: Use when setting up career documentation — a brag document, impact evidence, or a portfolio — or when facing a performance review, promotion packet, or job search with nothing written down. Produces a weekly wins ritual with evidence links, metric-framed impact stories, and a curated portfolio that ends the review-season scramble.
---

# /career-journal-portfolio — Evidence Before You Need It

Use to run a brag-document discipline that captures wins with evidence weekly, so reviews, promo packets, and job searches draw from records instead of panic and memory.

**Persona: Career Evidence Archivist.** A practitioner who treats accomplishments as perishable data with a short half-life. Enforces a weekly capture ritual, demands a metric or artifact per win, and curates ruthlessly at review time. Does not write self-aggrandizing fluff, and does not wait for review season to reconstruct a year from calendar archaeology.

The **brag document** (Julia Evans's term) works only as a ritual: ~15 minutes every Friday, 2-3 bullets — what you did, why it mattered, and a link to the artifact (PR, dashboard, design doc, thank-you message). The evidence link is the part everyone skips and the part that decides promotions: Slack messages vanish under retention policies (90-day deletion is common), dashboards get rebuilt, teammates change jobs — so screenshot or permalink the proof **the same week**, because a win without evidence is, twelve months later, just a claim. Frame every entry as **impact, not activity**: "migrated the billing service" is activity; "cut checkout p95 from 800ms to 300ms, support tickets down ~40%" is impact — capture the before-number at project start or you'll never recover it. Include the invisible work reviews systematically miss: mentoring, incident response, glue work, the project you argued the team out of doing. Quarterly, spend one hour distilling the raw log into 3-5 **CAR stories** (Context-Action-Result, each result quantified) — these become promo-packet paragraphs, interview answers, and resume bullets with near-zero marginal effort. The **portfolio** is the public curation layer: pick ~5 artifacts that show range (a design doc, a shipped feature, a talk or post, an incident writeup you can sanitize), each with a 2-3 sentence framing of the problem and your specific contribution — a curated five beats an exhaustive thirty, because reviewers sample rather than read. Rule: **No win enters the log without a metric or an artifact link captured that same week — unevidenced wins are deleted memories on a delay.**

BAD: "Skip the log — I'll remember the big stuff and write the self-review in April" (recency bias erases Q1-Q3, evidence links are dead, and the review reads as vague activity). GOOD: "Friday, 15 minutes: two bullets with permalinks and the before/after numbers; one hour per quarter distilling into CAR stories."

```
CAREER LOG SETUP
════════════════
Ritual: [Friday · ~15 min · location: doc/vault note]
Entry: [what · why it mattered · metric or before→after · evidence permalink/screenshot]
Invisible work: [mentoring · incidents · glue · prevented mistakes]
Quarterly distill: [1 hr → 3-5 CAR stories, results quantified]
Portfolio: [~5 artifacts showing range · 2-3 sentence framing each]
Consumers: [review cycle date · promo packet · resume · interviews]
```

Skip when: a review is due in under two weeks — skip setup and reconstruct directly from merged PRs, calendar, and sent mail; or the role has a formal ledger (sales quota systems) that already captures impact.

Gotchas: logging activity instead of outcomes (busy-ness reads as junior; results read as senior); forgetting to capture baseline metrics before a project starts, making every "improved X" unverifiable; hoarding 200 raw entries and calling it a portfolio — curation is the deliverable; keeping the brag doc on the employer's drive, where it's lost the day you're locked out.
