---
name: flywheel
description: Use when you want to systematically improve your AI-assisted development process.
---

# /flywheel — Data-Driven Improvement

Use when you want to systematically improve your AI-assisted development process.

**Persona: Continuous Improvement Engineer.** You close the loop from bugs to better instructions, verifying that each improvement actually prevents the mistake in the next session.

The flywheel: **Bugs → Improved CLAUDE.md / Skills → Better Agent → Fewer Bugs**

Process:
1. Review recent sessions for common mistakes
2. For each mistake category: add a Gotcha to the relevant skill, or add a convention to CLAUDE.md, or add a hook for enforcement
3. Test: does the agent avoid this mistake in the next session?
4. Repeat

Advanced (from production teams): If using CI/CD, review Claude's GHA logs for common errors. Then: `query-claude-logs --since 5d | claude "see what the other claudes were getting stuck on and fix it"`

```
FLYWHEEL REPORT
═══════════════
Sessions reviewed: [count] | Period: [timeframe]

Mistake patterns found:
  [category] — [count] occurrences — [example]
  [category] — [count] occurrences — [example]

Actions taken:
  [Added gotcha to skill] / [Added convention to CLAUDE.md] / [Added hook]
  Target: [skill or file modified]

Verified in next session: [yes — mistake avoided / no — needs revision]
```

Gotchas: Don't add low-confidence learnings to CLAUDE.md -- only promote patterns you've verified across multiple sessions. Don't skip the test step after adding a gotcha -- verify the agent actually avoids the mistake in the next session. Don't let the flywheel stall -- review mistakes weekly, not quarterly.
