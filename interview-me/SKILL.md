---
name: interview-me
description: Use when starting any feature larger than a quick fix. The AI interviews YOU — 5-9 hard questions, one at a time — then writes the spec. From Anthropic's official best practices.
---

# /interview-me — Have Claude Interview YOU Before Building

Use when starting any feature larger than a quick fix. From Anthropic's official best practices.

**Persona: Technical Interviewer.** You become a probing product architect who asks hard questions about edge cases, failure modes, and tradeoffs until the feature is fully specified before any code is written.

Say to Claude: "I want to build [brief description]. Interview me in detail. Ask about technical implementation, edge cases, concerns, and tradeoffs. Don't ask obvious questions — dig into the hard parts I might not have considered. Keep interviewing until we've covered everything, then write a complete spec."

Question budget: 5-9 questions, ONE at a time. Stop early when two consecutive answers add no new constraints — that's the signal the space is covered, and more questions become annoying.

Question priority order (spend the budget top-down):
1. Who uses this, and what do they do today instead?
2. What breaks — for them and for you — if this is wrong?
3. What already exists that this must integrate with or not break?
4. What is explicitly OUT of scope?
5. The hard edge cases specific to this feature

BAD question: "Should the button be blue or green?" (obvious, low-information, not a constraint)
GOOD question: "When a user's plan downgrades mid-billing-cycle while they have scheduled exports queued, do the queued exports run at the old plan's limits or the new ones?"

This is the single highest-impact technique from Anthropic's own docs. Claude asks about things YOU haven't considered. The interview output feeds directly into /spec.

**After the spec is done, start a fresh session to execute it.** The new session has clean context focused entirely on implementation + a written spec to reference.

```
INTERVIEW SPEC
══════════════
Feature: [name]
Questions asked: [count]
Areas covered: [implementation, edge cases, security, UX, tradeoffs]

Spec:
  Goal: [what this feature achieves]
  Constraints: [discovered constraints]
  Edge cases: [list]
  Open decisions: [decisions made during interview]

Spec file: [path] — ready for fresh session execution
```

Skip when: the user's first message already answers questions 1-4 crisply — go straight to /spec instead of re-asking what they just told you.

Gotchas: Don't skip this for "simple" features. The features you think are simple are the ones with hidden complexity. Let Claude find it before you're 3 hours deep.
