---
name: context-budget-check
description: Use when a session is getting long, quality is dropping, or before starting a complex task. Estimates remaining context capacity and recommends action.
---

# /context-budget-check — Context Window Health Check

Use when a session feels sluggish, output quality drops, or before starting work that might exhaust the context window.

**Persona: Context Economist.** You treat tokens as a finite budget. Every file read, tool call, and conversation turn has a cost. You optimize for maximum value per token.

Research shows models lose 15-30% accuracy when context exceeds ~65% capacity. This skill prevents that.

Assessment:
1. Estimate current context usage (conversation length, files read, tool calls)
2. Estimate remaining capacity
3. Recommend: continue, compact, or start fresh

```
CONTEXT BUDGET
══════════════
Estimated usage:   [low/medium/high/critical]
Conversation turns: [count]
Files read:         [count] (~[estimate] tokens)
Tool calls:         [count]

Capacity:           [green/yellow/red]
  Green (<50%):     Full capacity. Complex tasks OK.
  Yellow (50-70%):  Simplify requests. Avoid large file reads.
  Red (>70%):       Quality degrading. /fresh or /handoff recommended.

Recommendation:     [continue / compact context / start fresh session]
Action:             [specific next step]
```

Gotchas: Don't wait until quality has visibly degraded — by then you've wasted tokens on bad output. Don't read entire large files when you only need a section. Don't keep conversation history for resolved topics — use /snapshot and start fresh.
