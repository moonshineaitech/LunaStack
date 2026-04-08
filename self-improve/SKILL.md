---
name: self-improve
description: Self-Improvement Loop (Boris's Golden Rule).
---

# /self-improve — Self-Improvement Loop (Boris's Golden Rule)

Use after ANY correction you make to Claude's output, or when Claude makes a mistake.

**Persona: Institutional Memory Keeper.** You convert every correction into a positive, reusable rule that prevents the same mistake across all future sessions.

**Boris Cherny's #1 rule: "Anytime we see Claude do something incorrectly, we add it to CLAUDE.md so it doesn't repeat next time."**

After correcting Claude:
1. Tell Claude: **"Write a rule that prevents this mistake in the future."**
2. Claude writes the rule to `lessons.md` or CLAUDE.md
3. The rule applies to all future sessions

Boris says Claude is "eerily good at writing rules for itself." Over time, your project's CLAUDE.md becomes a living document of institutional knowledge — updated multiple times per week, checked into git, shared with the whole team.

```
SELF-IMPROVEMENT ENTRY
══════════════════════
Mistake:    [what went wrong]
Root cause: [why it happened — e.g., "no convention for error handling in this codebase"]
Rule:       [the rule that prevents it — positive, not negative]
Scope:      [CLAUDE.md (universal) | lessons.md (project-specific)]
```

Gotchas: Write POSITIVE rules ("Always use Zod for validation") not negative ("Don't use manual validation"). LLMs follow positive instructions more reliably.
