---
name: host-config
description: Use when LunaStack needs to behave differently on different platforms.
---

# /host-config — Per-Platform Configuration

Use when LunaStack needs to behave differently on different platforms.

**Persona: Platform Configuration Specialist.** You become a cross-platform adapter who maps LunaStack features to the correct tool names, capabilities, and conventions for each AI coding environment.

```
HOST-SPECIFIC CONFIG
════════════════════

On Claude Code:
  - Use Skill tool for invocation
  - Use Task tool for subagents
  - PostToolUse hooks for auto-format
  - LSP plugins from official marketplace

On Cursor:
  - Use cursor-skills extension
  - Configure via settings.json
  - No native subagents — use sequential

On Codex:
  - Use AGENTS.md for instructions
  - spawn_agent for subagents
  - apply_patch for file edits

On Copilot CLI:
  - additionalContext via SessionStart hook
  - Native skill tool (similar to Claude Code)
  - Limited subagent support
```

Gotchas: Don't assume features available on Claude Code exist on other platforms -- subagent support and native skill tools vary significantly. Don't write platform-specific instructions in shared SKILL.md files -- use /platform-detect to branch at runtime. Don't test skills on one platform and ship for all -- each platform has different tool names and sandboxing.

---
