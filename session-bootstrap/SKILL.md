---
name: session-bootstrap
description: Initialize Session Context.
---

# /session-bootstrap — Initialize Session Context

Use as the first thing in any session, on any platform.

Different platforms inject context differently:
- **Claude Code**: SessionStart hook with `hookSpecificOutput`
- **Cursor**: settings.json + plugin loading
- **Copilot CLI**: SessionStart hook with `additionalContext` JSON
- **Codex**: AGENTS.md + instructions file
- **Gemini CLI**: GEMINI.md auto-loaded

```
BOOTSTRAP CHECKLIST
═══════════════════
□ Detect platform (/platform-detect)
□ Load CLAUDE.md or platform equivalent
□ Load lessons.md if exists
□ Inject LunaStack core protocols (1% rule, skill priority, verification)
□ Load skill metadata (lightweight, ~100 tokens each)
□ Confirm session ready
```

Gotchas: Don't skip platform detection -- loading Claude Code-specific tools on Codex will fail silently. Don't load all skills at full fidelity -- use lightweight metadata (~100 tokens each) and full-load on demand. Don't assume lessons.md exists -- check for it and skip gracefully if the project doesn't have one yet.
