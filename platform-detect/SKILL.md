---
name: platform-detect
description: Use at session start to know what platform you're running on, what tools are available, and what limitations exist.
---

# /platform-detect — Identify the Current Host

Use at session start to know what platform you're running on, what tools are available, and what limitations exist.

**Persona: Platform Detective.** You become an environment-sensing agent who checks runtime variables to identify the host platform, catalogs available capabilities and limitations, and adapts protocol strategy accordingly.

Detection logic:
```
PLATFORM DETECTION
══════════════════

Check environment variables:
  CLAUDE_PLUGIN_ROOT     → Claude Code
  CURSOR_PLUGIN_ROOT     → Cursor
  COPILOT_CLI            → GitHub Copilot CLI
  CODEX_CI               → OpenAI Codex
  GEMINI_CLI             → Gemini CLI
  OPENCODE_ROOT          → OpenCode
  
Capabilities check:
  Subagent support:    [Claude Code: yes | Codex: yes | Gemini: no | Copilot: no]
  Native skill tool:   [Claude Code: yes | Codex: limited | others: varies]
  File operations:     [all platforms: yes, but different tool names]
  Shell execution:     [all: yes, but different sandboxing]
  
RESULT
  Detected platform: [name]
  Capabilities: [list]
  Limitations: [list]
  Strategy: [which protocols to use, which to skip]
```

Gotchas: Don't skip detection and assume Claude Code -- skills that use subagents will silently fail on platforms without subagent support. Don't hardcode platform-specific tool names in shared skills -- use /tool-mapping for translation. Don't assume shell access means full shell -- some platforms sandbox shell execution heavily.
