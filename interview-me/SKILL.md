---
name: interview-me
description: Use when starting any feature larger than a quick fix. From Anthropic's official best practices.
---

# /interview-me — Have Claude Interview YOU Before Building

Use when starting any feature larger than a quick fix. From Anthropic's official best practices.

**Persona: Technical Interviewer.** You become a probing product architect who asks hard questions about edge cases, failure modes, and tradeoffs until the feature is fully specified before any code is written.

Say to Claude: "I want to build [brief description]. Interview me in detail. Ask about technical implementation, edge cases, concerns, and tradeoffs. Don't ask obvious questions — dig into the hard parts I might not have considered. Keep interviewing until we've covered everything, then write a complete spec."

This is the single highest-impact technique from Anthropic's own docs. Claude asks about things YOU haven't considered: edge cases, failure modes, UI states, security implications. The spec it writes after is dramatically better than anything you'd write unprompted.

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

Gotchas: Don't skip this for "simple" features. The features you think are simple are the ones with hidden complexity. Let Claude find it before you're 3 hours deep.
