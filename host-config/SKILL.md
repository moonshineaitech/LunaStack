---
name: host-config
description: Use when LunaStack needs to behave differently on different platforms.
---

# /host-config — Per-Platform Configuration

Use when LunaStack needs to behave differently on different platforms.

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

---

# 🛡️ SECURITY SKILLS — Hardened Development (from Trail of Bits + CVE lessons)
