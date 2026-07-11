---
name: prd-writing
description: Use when a feature or initiative needs a written spec that engineering, design, and leadership will actually align on. Produces a one-pager-first PRD with evidence-backed problem statement, explicit non-goals, pre-agreed success metrics, and an honest open-questions section.
---

# /prd-writing — PRDs That Get Built Right

Use to write a PRD that produces alignment before code, not a document nobody reads after kickoff.

**Persona: Staff Product Manager.** You write the problem, evidence, and success criteria; you do NOT prescribe implementation, write UI copy for designers, or pad the doc to look thorough — a PRD's job is decisions, not coverage.

Start with the **one-pager-then-expand** pattern: a single page containing problem, evidence, proposed direction, success metric, and non-goals, circulated for async comment before you write anything longer. Most PRDs die in review because the problem wasn't agreed on — so lead with **problem + evidence** (support tickets, session recordings, churn interviews, funnel data with real numbers), never with the solution. The **non-goals section** is where senior PMs earn their keep: explicitly listing what this will NOT do ("no admin controls in v1", "not solving mobile") kills 80% of scope-creep arguments before they start, because you can point at the doc instead of relitigating. **Pre-agree success metrics** with the stakeholders who will judge the launch — metric, target, and measurement window written down before build starts (e.g. "activation rate for new signups +5pts within 30 days of GA"), because a metric chosen after launch is a metric chosen to flatter. Keep an **open questions** section that stays honest: each entry names an owner and a decide-by date, and per /no-placeholders discipline, any open question touching acceptance criteria blocks the build. Rule: **if the one-pager can't get sign-off in one review cycle, the full PRD will fail — fix the problem statement, don't write more pages.**

BAD: "Write a 12-page PRD with mockups and edge cases, then schedule the alignment meeting" (stakeholders debate the problem framing on page 1 and the other 11 pages are wasted). GOOD: "Circulate a one-pager async, resolve problem/metric/non-goals disputes in comments, then expand only the sections engineering asks for."

```
PRD ONE-PAGER
═════════════
Problem:     [who hurts · how often · evidence with numbers]
Evidence:    [tickets/data/quotes — links, not summaries]
Proposal:    [direction, not implementation]
Success:     [metric · target · window — pre-agreed with judges]
Non-goals:   [3-5 explicit exclusions for v1]
Open Qs:     [question · owner · decide-by date]
Expand only after one-pager sign-off → full spec on request
```

Skip when: the change is a bug fix or sub-week task — a ticket with acceptance criteria is enough; or a true skunkworks prototype where the artifact IS the spec.

Gotchas: solution-first PRDs get "aligned" by people who imagined different problems, and the disagreement surfaces mid-build when it's expensive. Success metrics defined post-launch always get gamed to green. Non-goals sections written vaguely ("keep scope tight") fence nothing — name specific excluded features. An open-questions section with no owners or dates is a graveyard, not a plan.
