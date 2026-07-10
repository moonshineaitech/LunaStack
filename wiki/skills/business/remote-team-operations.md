---
name: remote-team-operations
description: Use when running or fixing a distributed team — decisions dying in Slack threads, meetings at brutal hours for one region, or onboarding that only works in person. Produces async-first defaults: a written-decision protocol, an overlap-hours contract (~4h), documentation-as-management practices, and a timezone-fair meeting rotation.
---

# /remote-team-operations — Async-First or Silently Broken

Use to install the operating defaults that make a distributed team work: decisions in writing, explicit overlap contracts, documentation as the management layer, and meeting pain shared fairly across timezones.

**Persona: Distributed-Work Systems Designer.** Acts as the remote-ops lead who sets the async defaults, drafts the overlap and communication contracts, and audits where synchronous habits are silently taxing one region. Does NOT manage individuals or set business strategy — it designs the collaboration system.

Remote teams don't fail from distance; they fail from importing office defaults — decisions made in calls and DMs that half the team never sees. The fix is a **written-decision protocol**: any decision affecting more than one person gets a short doc (context, options, recommendation, deadline for objections — the async-RFC pattern GitLab and Linear-style teams standardized) posted where the team works (Notion, Linear, a decisions channel), with a default-approve deadline of ~48 hours so async never means slow; decisions made in a call still get written up within 24 hours or they didn't happen. Second, the **overlap contract**: hire into an explicit ~4-hour shared window (the durable heuristic — enough for pairing and real-time escalation, small enough to hire across ~8 timezones); a team scattered without any common window isn't async-first, it's a relay race with 24-hour baton drops, so treat overlap as a hiring constraint, not an aspiration. Third, **documentation as management**: the handbook-first rule — if a process, decision, or expectation isn't written where a new hire can find it, it doesn't exist; every "let me explain how we do X" call is a missing page, and onboarding quality is your documentation test suite (a new hire who needs >3 synchronous explainers in week one has found three doc gaps — file them like bugs). Fourth, **timezone fairness**: for meetings that must be synchronous (keep them few — all-hands, planning), rotate the painful slot on a published schedule and record everything (Zoom AI summaries, Granola, tl;dv make the recording searchable); a standing 6 a.m. slot for Singapore "because it's always worked" is a quiet attrition machine. Rule: **If a decision isn't written down where the whole team can find it within 24 hours, it isn't made — meetings may discuss, only documents decide.**

BAD: "We hashed it out on the Zoom with whoever could make it — US folks aligned, we're going with option B" (the APAC engineers wake up to a fait accompli, relitigate it in comments, and learn that influence requires attending calls at 5 a.m. — the async culture dies right there). GOOD: "Post the one-page decision doc with options and a 48-hour objection deadline in #decisions; the call, if needed, happens inside the overlap window and its outcome goes back into the doc."

```
REMOTE OPS DEFAULTS
════════════════════
OVERLAP CONTRACT: [window, e.g. 14:00-18:00 UTC] · applies to: [teams] · hiring constraint: [y]
DECISION PROTOCOL: [doc template link] · objection window: [~48h] · decisions log: [location]
DOCS-AS-MGMT: handbook: [location] · gap rule: [sync explainer → doc it] · onboarding sync-call count: [target ≤3 wk1]
MEETINGS: sync-worthy list: [all-hands, planning, ...] · rotation schedule: [published link] · recording/notes: [tool]
HEALTH CHECKS: [decision latency · after-hours message rate by region · doc staleness]
```

Skip when: a co-located team with everyone in one office and timezone — written decisions still pay, but overlap contracts and rotation are solving a problem you don't have.

Gotchas: declaring "async-first" while leadership keeps making real decisions in DMs and hallway calls — the team follows the behavior, not the policy. Compensating for async with message overload — presence-signaling in Slack recreates the office's worst habit; measure response expectations in hours, not minutes. Documentation that's written once and never gardened — stale docs are worse than none because they're confidently wrong. Rotating meeting times without recording them, which just distributes the ignorance evenly.
