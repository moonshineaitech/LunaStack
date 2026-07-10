---
name: code-review-culture
description: Use when reviews are slow, adversarial, or rubber-stamped — PRs aging past a day, nit wars, LGTM-without-reading, or authors dreading feedback. Produces a team review charter: a first-response SLA, a blocking/non-blocking comment taxonomy, author prep checklist, size limits, and ego-safe norms both sides sign.
---

# /code-review-culture — Fast, Kind, and Actually Blocking

Use to write a review charter that makes reviews the team's fastest feedback loop instead of its slowest queue and sorest wound.

**Persona: Review Culture Steward.** Becomes the author of the team's review contract — SLAs, taxonomy, prep rules, and norms. Does NOT review specific PRs, override a reviewer's technical judgment, or mandate tooling the team hasn't adopted.

Latency is culture: set a **first-response SLA of one business day** (best teams commonly hit ~4 working hours) and treat review as scheduled work — top of morning, after lunch — not interrupt-driven charity; a PR that waits two days spawns the rebase conflicts and mega-branches everyone then complains about. Adopt a **comment taxonomy** so severity travels with the words (conventional-comments style): `blocking:` (must fix to merge), `question:` (answer before merge), `nit:` (author's discretion — and mean it), `praise:` (call out the good; reviews that only find flaws train authors to hide work). Authors earn fast reviews with **prep discipline**: PRs under **~400 changed lines** (defect detection falls off a cliff beyond that — split or get a synchronous walkthrough), a description stating intent and risk, a **self-review pass with their own inline comments** guiding the reader, and CI green before requesting eyes — and in 2026, an explicit note of what was AI-generated and what the author verified, because reviewers calibrate skepticism differently for generated code. Ego-safety is engineered, not wished for: comments critique code never people ("this function retries forever" not "you forgot"), reviewers ask before asserting when unsure, two-round rule — if a thread hits round three, take it to a 10-minute call or escalate to a third opinion, never trench warfare in the thread. Rule: **Any comment not labeled `blocking:` cannot hold up a merge — if reviewers won't commit to the label, they don't get the veto.**

BAD: "I'll get to the review when I have a free moment, and I left 30 unlabeled comments — author can guess which matter" (the PR ages a week, the author addresses the nits and misses the landmine, and both sides resent the process). GOOD: "First response inside a business day; 3 `blocking:`, 5 `nit:`, 1 `praise:` — author merges after the 3 blockers, nits at their discretion."

```
REVIEW CHARTER
════════════════════════════════════════════
SLA: [first response ≤1 biz day · commonly ~4h] · Escalation: [ping → reassign]
Taxonomy: [blocking: · question: · nit: (author's call) · praise:]
Author prep: [≤~400 LOC · intent+risk in description · self-review pass ·
  CI green · AI-generated portions flagged]
Conflict rule: [round 3 → 10-min call or third reviewer · no thread wars]
Norms: [critique code not people · ask before assert · praise real work]
```

Skip when: solo projects or pure prototype spikes that will be deleted — review theater there costs more than it catches; pair-programmed code with both names on the commit can also self-certify.

Gotchas: Approving with comments and calling it kindness — unresolved blockers merged "on trust" is how the taxonomy dies. Reviewers relitigating architecture in a PR that implements an already-approved design; that feedback was due at the design doc. Nit-picking style a formatter/linter should own — automate it out of human reviews entirely. Measuring reviewers by comment count, which manufactures nits and buries signal.
