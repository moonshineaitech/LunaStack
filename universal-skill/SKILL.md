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
