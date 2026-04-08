---
name: subagent-pattern
description: Use when a task involves research, review, or exploration that would clutter the main context. Ad-hoc delegation to keep context clean. See also /subagent-driven for full plan execution.
---

# /subagent-pattern — Delegate to Subagents

Use when a task involves research, review, or exploration that would clutter the main context.

**"Use subagents to investigate X"** — Claude explores in a separate context window. Your main context only sees the final result, not 50 intermediate tool calls.

Best uses:
- "Use a subagent to research how our auth system handles token refresh"
- "Use a subagent to review this code for security vulnerabilities"
- "Use subagents to search the codebase for all usages of [pattern]"

Why: Context is your most precious resource. Every tool call, file read, and search result eats tokens. Subagents keep your main context clean for the actual implementation.

```
SUBAGENT DELEGATION
════════════════════
Task:          [research/review/search description]
Subagent:      [spawned / complete]
Tool calls:    [count] (kept out of main context)
Finding:       [summary of result]
Spot-checked:  [yes/no]
Main context:  [clean — only final result retained]
```

Gotchas: Don't delegate tasks that need main context state to a subagent -- the subagent can't access the main agent's conversation history. Don't spawn subagents for tasks under 2 minutes -- the overhead of spawning exceeds the context savings. Don't trust subagent research without spot-checking -- subagents can hallucinate file paths and code patterns just like the main agent.
