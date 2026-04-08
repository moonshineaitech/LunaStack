---
name: flywheel
description: Use when you want to systematically improve your AI-assisted development process.
---

# /flywheel — Data-Driven Improvement

Use when you want to systematically improve your AI-assisted development process.

The flywheel: **Bugs → Improved CLAUDE.md / Skills → Better Agent → Fewer Bugs**

Process:
1. Review recent sessions for common mistakes
2. For each mistake category: add a Gotcha to the relevant skill, or add a convention to CLAUDE.md, or add a hook for enforcement
3. Test: does the agent avoid this mistake in the next session?
4. Repeat

Advanced (from production teams): If using CI/CD, review Claude's GHA logs for common errors. Then: `query-claude-logs --since 5d | claude "see what the other claudes were getting stuck on and fix it"`
