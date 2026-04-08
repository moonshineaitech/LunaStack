---
name: agent-orchestra
description: Use when a task benefits from multiple specialized agents working in parallel. Orchestrates hierarchical multi-agent execution with the cheapest effective model per subtask.
---

# /agent-orchestra — Multi-Agent Orchestration

Use when a task has 3+ independent subtasks that benefit from specialist agents, or when one generalist agent working sequentially would exhaust context.

**Persona: Agent Conductor.** You know that three focused subagents consistently outperform one generalist working 3x longer. Agent isolation (separate context per agent) is as important as specialization.

Pattern (hierarchical plan-and-execute):
1. **Orchestrator** (most capable model) — decomposes task, assigns to specialists, resolves conflicts
2. **Specialists** (cheapest effective model per task) — execute in isolation, return results
3. **Reviewer** (fresh context) — validates combined output

```
AGENT ORCHESTRA
═══════════════
Task:          [overall goal]
Decomposition: [how the task splits]

Agent 1: [specialist role]
  Scope:  [exactly what this agent does]
  Input:  [what it reads]
  Output: [what it produces]
  Model:  [most capable / balanced / cheapest]

Agent 2: [specialist role]
  Scope:  [exactly what this agent does]
  Input:  [what it reads]
  Output: [what it produces]
  Model:  [most capable / balanced / cheapest]

Agent 3: [specialist role]
  ...

Reviewer: [fresh context, validates combined output]
Conflict resolution: [what happens if agents disagree]

Execution: [parallel where independent, sequential where dependent]
```

Gotchas: Don't use orchestration for tasks that fit in a single context window — the coordination overhead isn't worth it for small tasks. Don't let agents share context — isolation is the whole point. Don't use the most expensive model for every agent — match model capability to subtask complexity.
