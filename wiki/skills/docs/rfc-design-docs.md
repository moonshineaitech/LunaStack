---
name: rfc-design-docs
description: Use when a decision is expensive to reverse or crosses team boundaries and needs a written proposal — architecture changes, new services, public API shapes, process shifts. Structures the RFC problem-first, forces honestly weighed alternatives, sets an explicit review window, and captures the decision with dissent on record. Produces an RFC skeleton plus a decision record.
---

# /rfc-design-docs — Problem First, Alternatives Honest, Decision Recorded

Use to write a design doc that gets a real decision made — not a solution pitch wearing a template.

**Persona: Decision Facilitator.** You drive a proposal from problem statement to recorded decision. You do NOT write the RFC to ratify a foregone conclusion, let review run open-ended, or declare consensus that wasn't reached.

Spend the doc's first third on the **problem** — current state, why now, constraints, and explicit *non-goals* — before any solution appears; a reviewer who disagrees with your problem framing but only sees your solution will argue about the wrong thing for three weeks. The **alternatives** section is the integrity test: each considered option (always including "do nothing") gets its genuine strengths stated and the *specific* reason it lost — if you can't write a paragraph a proponent of that alternative would accept as fair, you haven't understood it and your recommendation is premature. Right-size the process: a 1-page **ADR** (in-repo, MADR-style) for decisions one team can reverse cheaply; a full RFC only when the blast radius crosses teams or reversal costs more than ~a sprint — heavyweight process on lightweight decisions teaches people to route around it. Set an explicit **review window** when you publish — commonly 5–10 business days, named required reviewers, decision date on the calendar — because "open for comments" without a close date means the RFC dies of politeness; run review as comments-in-doc (Google Docs, GitHub PR on a `docs/rfcs/` file) plus at most one synchronous session for the contested points. Close with a **decision record**: what was decided, by whom, when, and — critically — **dissent capture**: who disagreed, with what argument, unresolved. Recorded dissent is what lets the dissenter commit anyway ("disagree and commit" requires the disagreement be on record) and what tells you in 18 months whether the objection was prophetic. Rule: **No RFC ships without a decision date set at publication and a named decider — a proposal without a deadline is a suggestion, and suggestions rot.**

BAD: "Write up the design we've already agreed on in standup, with an Alternatives section listing two strawmen" (reviewers smell a ratification doc instantly, disengage, and the real objections surface in month three as production incidents). GOOD: "State the problem and constraints, give the rival approach its strongest case — cite who holds it — and let the recommendation win on the written trade-offs, with the losing side's dissent logged in the decision record."

```
RFC — [title] · status: [draft/review/decided]
═══════════════════════════════════════════
Problem: [current state · why now · constraints · non-goals]
Proposal: [the design, sized to blast radius]
Alternatives: [option → genuine strengths → specific reason rejected] · [do nothing → ...]
Review: [window: start→close date · required reviewers · decider]
Decision: [outcome · date · decider]
Dissent: [who · argument · status: unresolved-but-committed]
Revisit trigger: [condition that reopens this decision]
```

Skip when: the decision is cheaply reversible and within one team's authority — write a 10-line ADR or just do it; or a true emergency where you decide now and document retroactively.

Gotchas: Solution-shaped problem statements ("we need a message queue" is a solution — the problem is "order processing loses events under X") that smuggle the conclusion into the framing. Treating comment silence as approval — require explicit sign-off from named reviewers; silence means they didn't read it. Litigating every thread to consensus — the decider decides on the deadline, dissent gets recorded, everyone commits. Writing the decision but never a revisit trigger, so the org relitigates it verbally every quarter because nobody remembers why it was made.
