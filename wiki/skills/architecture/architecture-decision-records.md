---
name: architecture-decision-records
description: Use when making any architecturally significant decision — one that is expensive to reverse, constrains future work, or will be questioned later. Produces a short immutable ADR (context, decision, consequences, alternatives) written in under 30 minutes and stored in-repo next to the code it governs.
---

# /architecture-decision-records — Decide Once, On the Record

Use to capture why an architectural choice was made so future engineers argue with the reasoning, not the ghost of it.

**Persona: Decision Historian.** Becomes the scribe who records context, decision, and consequences at the moment of choice — including the honest downsides. Writes and supersedes ADRs; does NOT turn them into design docs, seek committee sign-off, or retroactively sanitize a decision that aged badly.

The discipline that makes ADRs work is the **30-minute ADR**: one page, written the same day the decision lands, in the repo (`docs/adr/NNNN-title.md`, managed with **adr-tools**, **log4brains**, or plain Markdown — MADR is the current common template). Structure: *Context* (the forces — actual constraints, team skills, deadlines, not marketing prose), *Decision* (one sentence, active voice: "We will use Postgres logical replication for..."), *Consequences* (what gets harder, not just easier — an ADR listing zero downsides is a sales pitch), plus 2-3 *alternatives considered* with the real reason each lost. ADRs are **immutable**: never edit an accepted ADR to reflect new thinking — write a new one with status `supersedes ADR-0012`, so the trail shows how understanding evolved; the old record's wrongness is its value. Trigger test for "architecturally significant": would reversing this cost more than ~a week, or will a new hire ask "why on earth is it like this?" within a year — datastore choices, sync-vs-async seams, build-vs-buy, auth model, multi-tenancy strategy all qualify; naming conventions and library minutiae do not. A healthy team commonly produces 1-3 ADRs per month; zero for a quarter means decisions are happening in Slack and evaporating. Review the ADR in the same PR as the change it governs. Rule: **If a decision would take more than ~30 minutes to write up, you are writing a design doc, not an ADR — cut scope until context, decision, and consequences fit one page.**

BAD: "We'll document the architecture properly once things settle down" (context evaporates in weeks; a year later the team reverses a load-bearing decision because nobody remembers the constraint that forced it). GOOD: "ADR-0031 written in the PR that introduces the outbox pattern: context is the dual-write bug from incident #442, decision, consequences, two rejected alternatives."

```
ADR-[NNNN]: [TITLE]
═══════════════════
Status: [proposed/accepted/superseded by ADR-NNNN] · Date: [YYYY-MM-DD] · Deciders: [names]
Context: [forces, constraints, incident/requirement that triggered this]
Decision: We will [active-voice choice].
Consequences: [good] · [bad/harder] · [neutral/watch]
Alternatives: [option — why rejected] · [option — why rejected]
```

Skip when: the decision is trivially reversible (a flag flip, a refactor with tests) — record it in the commit message; or an RFC/design-doc process already captured the same content, in which case the ADR is a one-line pointer.

Gotchas: writing ADRs weeks after the fact produces justification fiction, not history; editing accepted ADRs in place destroys the audit trail — supersede instead; consequences sections that list only upsides signal the alternatives were never seriously weighed; storing ADRs in Confluence/Notion instead of the repo divorces them from code review and guarantees drift; numbering by team-of-origin instead of one global sequence makes supersession chains unfollowable.
