---
name: lsp
description: Use at project setup, or when you notice Claude missing obvious type errors.
---

# /lsp — Install LSP Plugins (Highest-Impact Plugin)

Use at project setup, or when you notice Claude missing obvious type errors.

**LSP plugins give Claude automatic diagnostics after every file edit.** Type errors, unused imports, missing return types — Claude sees and fixes issues before you even notice.

```bash
# In Claude Code:
/plugin install typescript-lsp@claude-plugins-official
/plugin install pyright-lsp@claude-plugins-official
/plugin install rust-analyzer-lsp@claude-plugins-official
/plugin install gopls-lsp@claude-plugins-official
# Also: C#, Java, Kotlin, Swift, PHP, Lua, C/C++
```

This is the single highest-impact plugin. Boris and the team recommend it as the first thing to install.

For non-CC users: ask Claude to run type-checking and linting commands after writing code. Same principle, manual loop.

Gotchas: Don't install LSP for a language your project doesn't use -- each plugin adds context overhead. Don't ignore LSP warnings about type errors -- they're the highest-signal feedback Claude can get. Don't assume LSP is working without verifying -- check that diagnostics appear after editing a file with a deliberate type error.
