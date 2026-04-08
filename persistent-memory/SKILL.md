---
name: persistent-memory
description: Use when designing multi-session AI workflows where context should survive across days/weeks.
---

# /persistent-memory — Cross-Session Memory Architecture

Use when designing multi-session AI workflows where context should survive across days/weeks.

OpenClaw's persistent memory is one of its best features (and biggest security risks). LunaStack's clean version:

```
MEMORY ARCHITECTURE
═══════════════════

LAYER 1: Session memory (in-context)
  Lives: current conversation
  Persists: until /clear or /compact
  Use: working state, current focus

LAYER 2: Project memory (file-based)
  Lives: .lunastack/memory/{project}/
  Persists: forever
  Use: decisions, conventions, lessons
  Format: structured Markdown files
  
LAYER 3: Global memory (file-based, opt-in)
  Lives: ~/.lunastack/memory/global/
  Persists: forever
  Use: cross-project patterns, personal preferences
  Caveat: NEVER include client-confidential data

WRITE PATTERN
  At key moments (decision made, lesson learned, milestone reached):
  → /snapshot writes to Layer 1
  → /handoff writes to Layer 2
  → /compound writes to Layer 3 (only high-confidence patterns)
```

Gotchas: Don't write client-confidential data to global memory (Layer 3) -- it persists forever and crosses project boundaries. Don't skip the opt-in requirement for global memory -- default-on global persistence is a privacy risk. Don't store session-specific state in persistent memory -- it pollutes future sessions with stale context.
