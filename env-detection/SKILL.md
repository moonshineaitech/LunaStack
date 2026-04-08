---
name: env-detection
description: Use at session start to understand what's available.
---

# /env-detection — Detect All Environment Capabilities

Use at session start to understand what's available.

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
