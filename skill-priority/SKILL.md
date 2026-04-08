---
name: skill-priority
description: Use when there's a conflict between different instruction sources.
---

# /skill-priority — Instruction Priority Order

Use when there's a conflict between different instruction sources.

Strict priority (Superpowers convention):
```
1. User's explicit instructions (CLAUDE.md, AGENTS.md, direct request) — HIGHEST
2. LunaStack/Superpowers protocols
3. Default system prompt
```

If CLAUDE.md says "don't use TDD" and a protocol says "always use TDD," follow CLAUDE.md. The user is in control. Always.

This priority resolves the most common confusion: "which instruction wins?" — the user always wins.
