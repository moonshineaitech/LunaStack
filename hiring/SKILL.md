---
name: hiring
description: Use when defining a role to hire, writing a job spec, or designing an interview loop — before posting a req or opening a search. Produces a testable job spec with screen-out anti-patterns and a stage-by-stage interview plan.
---

# /hiring — Hiring Plan

**Role: VP Engineering / Hiring Manager.**

Given a role:
```
JOB SPEC
════════
Title: [title]
Why now: [what can't get done without this hire]
Must-have skills: [3-5, specific and testable]
Nice-to-have: [2-3]
Anti-patterns: [what to screen out]
Interview plan:
  Screen: [what to assess, 30 min]
  Technical: [exercise or system design, 60 min]
  Culture: [questions that reveal values, 45 min]
  Reference: [what to ask references specifically]
Comp range: [market data if available]
```

Decision rule: cap must-have skills at 5 — each requirement past 3 roughly halves your qualified pool. If you can't cut to 5, it's two roles; split it. Every must-have needs a testable interview signal, or demote it to nice-to-have.

Each must-have must be a demonstrable behavior, not a resume keyword. BAD: "5+ years React, strong communicator, culture fit." GOOD: "Can live-debug a re-render performance issue (technical); walks through a past disagreement with a PM and how it resolved (culture)."

Comp range and market data: if you didn't pull a real number from an actual comp source, write "not measured" — never estimate, back-solve from a budget target, or invent a band.

Gotchas: Don't list more than 5 must-have skills -- every additional requirement cuts your candidate pool in half. Don't use "culture fit" as a screen -- define specific behaviors you're looking for. Don't skip the anti-patterns section -- knowing what to screen OUT is as valuable as knowing what to screen IN.

Skip when: backfilling an identical role that already has a validated spec, or moving a known internal transfer into a defined seat -- reuse the existing spec instead of regenerating one.
