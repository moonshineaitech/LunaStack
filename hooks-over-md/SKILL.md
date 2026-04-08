---
name: hooks-over-md
description: Use when you need 100% compliance on a rule, not 80%.
---

# /hooks-over-md — Enforce with Hooks, Guide with CLAUDE.md

Use when you need 100% compliance on a rule, not 80%.

**CLAUDE.md = advisory (80% compliance). Hooks = deterministic (100%).**

If something must happen every time:
- **PreToolUse hook**: Block dangerous actions (rm -rf, push to main)
- **PostToolUse hook**: Auto-format, auto-lint after every file edit
- **Stop hook**: Run formatter + linter, present errors to Claude

If something is guidance:
- Put it in CLAUDE.md or a skill

Never send an LLM to do a linter's job. Use deterministic tools for deterministic tasks.

Gotchas: Don't put critical rules only in CLAUDE.md -- if non-compliance is unacceptable, enforce it with a hook. Don't make hooks too noisy -- a hook that fires on every edit with false positives will be disabled. Don't use LLM judgment for checks that have deterministic answers -- linters, formatters, and type checkers are always more reliable.
