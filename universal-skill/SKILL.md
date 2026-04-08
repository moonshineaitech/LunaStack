---
name: universal-skill
description: Use when authoring a new protocol that should work on all platforms.
---

# /universal-skill — Write Skills That Work Everywhere

Use when authoring a new protocol that should work on all platforms.

Universal skill rules:
1. **Don't assume tool names** — describe the action, not the tool ("read the file" not "use the Read tool")
2. **Include platform notes** — short section at the bottom: "On Claude Code: ... | On Codex: ... | On Gemini: ..."
3. **Don't require subagents** — provide a fallback for platforms without subagent support
4. **Don't use !`shell` injection** — that's a Claude Code feature; use platform-neutral language
5. **Test on at least 2 platforms** before publishing

```
UNIVERSAL SKILL CHECK
══════════════════════
Rule 1 — No tool names:     [pass/fail] [offending lines]
Rule 2 — Platform notes:    [pass/fail] [platforms covered]
Rule 3 — No subagent req:   [pass/fail] [fallback provided]
Rule 4 — No shell injection: [pass/fail] [offending lines]
Rule 5 — Multi-platform test: [pass/fail] [platforms tested]
VERDICT: [UNIVERSAL / NEEDS FIXES — list]
```
