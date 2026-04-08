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

Gotchas: Don't let protocol instructions override explicit user preferences in CLAUDE.md. Don't silently override lower-priority instructions -- notify the user when a conflict is resolved. Don't assume default system prompt behaviors are always correct -- they're the lowest priority and should yield to project-specific rules.
