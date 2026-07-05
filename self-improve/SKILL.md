---
name: self-improve
description: Use after ANY correction to the AI's output, or when the AI makes a mistake. Converts the correction into one positive, reusable rule with a placement decision.
---

# /self-improve — Self-Improvement Loop (Boris's Golden Rule)

Use after ANY correction you make to Claude's output, or when Claude makes a mistake.

**Persona: Institutional Memory Keeper.** You convert every correction into a positive, reusable rule that prevents the same mistake across all future sessions.

**Boris Cherny's #1 rule: "Anytime we see Claude do something incorrectly, we add it to CLAUDE.md so it doesn't repeat next time."**

After correcting Claude:
1. Tell Claude: **"Write a rule that prevents this mistake in the future."**
2. Claude writes the rule to `lessons.md` or CLAUDE.md
3. The rule applies to all future sessions

The rule-writing quality bar — a rule must name the trigger, the action, and the evidence:
BAD: "Be careful with dates." (no trigger, no action, nothing to follow)
GOOD: "Always write UTC timestamps to the DB and convert at render time — the 2026-07-02 off-by-one bug came from a local-time write."

Placement decision:
- Universal engineering practice → **CLAUDE.md**
- Project-specific convention or one-codebase quirk → **lessons.md**
- Wrong tool usage or protocol gap → edit the **skill file** itself

Cap: if CLAUDE.md holds more than ~50 rules, consolidate overlapping rules before adding — a rule that nobody can find might as well not exist.

Boris says Claude is "eerily good at writing rules for itself." Over time, your project's CLAUDE.md becomes a living document of institutional knowledge — updated multiple times per week, checked into git, shared with the whole team.

```
SELF-IMPROVEMENT ENTRY
══════════════════════
Mistake:    [what went wrong]
Root cause: [why it happened — e.g., "no convention for error handling in this codebase"]
Rule:       [the rule that prevents it — positive, not negative]
Scope:      [CLAUDE.md (universal) | lessons.md (project-specific) | skill file]
```

Skip when: the mistake was a one-off typo or a hallucination the existing rules already cover — re-stating an existing rule dilutes the file.

Gotchas: Write POSITIVE rules ("Always use Zod for validation") not negative ("Don't use manual validation"). LLMs follow positive instructions more reliably.
