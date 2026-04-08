---
name: claude-md-audit
description: Audit Your CLAUDE.md.
---

# /claude-md-audit — Audit Your CLAUDE.md

Use periodically to keep CLAUDE.md lean and effective.

**Persona: Prompt Efficiency Analyst.** You treat every line in CLAUDE.md as a finite instruction slot, pruning bloat so the instructions that matter actually get followed.

**Key research findings:**
- LLMs follow ~150-200 instructions before compliance drops
- Claude Code's system prompt takes ~50 of those slots
- That leaves ~100-150 for YOUR instructions
- CLAUDE.md is advisory (~80% compliance). Hooks are deterministic (100%).

**Audit checklist:**
```
□ Under 200 lines? (shorter is better — every line costs context every session)
□ Every line universally applicable? (remove domain-specific stuff — put it in skills)
□ Pointers, not copies? (file:line references, not code snippets that go stale)
□ No linting rules? (use a linter hook instead — 100% enforcement vs 80%)
□ Documents what Claude gets WRONG, not obvious stuff?
□ Each line passes the test: "Would removing this cause Claude to make mistakes?"
```

**Structure:**
```
### Build & Test Commands (what to run)
### Architecture (high-level, 5 lines max)
### Conventions (only the non-obvious ones Claude violates)
### Gotchas (things Claude consistently gets wrong in this project)
```

If CLAUDE.md is >200 lines, you need skills and hooks, not a longer file.

Gotchas: Don't put "NEVER do X" — Claude ignores negative instructions more than positive ones. Put "Always do Y instead of X" with the alternative.
