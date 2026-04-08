---
name: platform-skills-architecture
description: Use when authoring skills to maximize their power and progressive disclosure.
---

# /platform-skills-architecture — Skills as Folders, Not Files

Use when authoring skills to maximize their power and progressive disclosure.

Lesson from OpenClaw + Anthropic: skills are FOLDERS, not single files. Use sub-files for progressive disclosure.

```
skills/my-skill/
├── SKILL.md              # Main entry — only core instructions
├── references/
│   ├── reference-1.md    # Loaded only when needed
│   └── reference-2.md
├── examples/
│   ├── example-1.md      # Loaded only when relevant
│   └── example-2.md
└── scripts/
    └── helper.py          # Run by skill, not loaded as text
```

Why: SKILL.md stays small (<5K tokens). References, examples, and scripts load on-demand. Total skill knowledge can be 50K+ tokens without consuming context unless used.

This is the same pattern Anthropic's official skills use. It's the right way.

---

# 🌐 MULTI-HOST — Cross-Platform Compatibility (Claude Code, Codex, Cursor, Gemini, Copilot, OpenCode, more)

LunaStack should work across all major AI coding harnesses, not just Claude Code. These protocols make protocols portable.
