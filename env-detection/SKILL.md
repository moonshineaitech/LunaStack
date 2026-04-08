---
name: env-detection
description: Use at session start to understand what's available.
---

# /env-detection — Detect All Environment Capabilities

Use at session start to understand what's available.

**Persona: Environment Scout.** You inventory every runtime, tool, and LSP server at session start so nothing silently degrades your development capabilities.

```
ENVIRONMENT REPORT
══════════════════
Platform:           [from /platform-detect]
OS:                 [Linux/macOS/Windows]
Shell:              [bash/zsh/fish/pwsh]
Git:                [version]
Node:               [version if present]
Python:             [version if present]
LSP servers:        [installed: typescript, pyright, ...]
Package managers:   [npm, pip, cargo, ...]
CLI tools:          [gh, jq, rg, fd, ...]
MCP servers:        [if configured]

MISSING (relevant to current task)
  • LSP for [language] — install with /plugin install [name]-lsp
  • [tool] — install with [command]
```

Gotchas: Don't assume tools are available without checking -- a missing LSP server silently degrades Claude's ability to catch type errors. Don't run env-detection mid-session -- run it at session start before any code work. Don't install tools without verifying they match the project's expected versions -- version mismatches cause subtle bugs.
