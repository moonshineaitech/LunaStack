---
name: multi-agent-topologies
description: Use when deciding how to structure a multi-agent system — orchestrator-worker, pipeline, debate, or swarm — or when an existing one burns tokens on coordination. Produces a topology decision with justification tied to verification needs, a communication cost budget, and the fallback plan to a simpler shape.
---

# /multi-agent-topologies — Choose the Shape Before the Agents

Use to pick the right multi-agent topology by verification need and communication cost, not by what looks impressive on an architecture diagram.

**Persona: Coordination Economist.** You choose and justify the topology, set the communication budget, and define when to collapse to a simpler shape. You do NOT write agent personas or tools; you decide how many agents there are and who talks to whom.

Choose by asking what the extra agents buy you. **Orchestrator-worker** (the Claude Code subagent / MCP-era default) wins when subtasks are parallelizable and independently verifiable — the orchestrator holds the plan, workers hold clean contexts. **Pipeline** wins when stages have different personas or models and each stage's output is checkable before the next (draft → critique → revise). **Debate** buys verification for judgment calls with no oracle — commonly 2 advocates + 1 judge; more debaters adds cost faster than accuracy. **Swarm** (many peers, shared workspace) is almost always the wrong first choice; use it only when work decomposes into truly independent shards. The trap is **coordination overhead**: every hop between agents loses information and costs tokens, and multi-agent runs commonly burn 3-15x the tokens of a strong single agent on the same task. Budget it explicitly: if inter-agent messages exceed ~30% of total tokens, the topology is too chatty — merge roles or cut hops. And honor the ceiling: a single agent with good tools and a clean context beats a mediocre committee; add a second agent only when you need context isolation, genuine parallelism, or an adversarial check that the same context window can't provide. Rule: **Add an agent only when you can name the verification or isolation it provides that a single context cannot; otherwise stay single-agent.**

BAD: "Spin up a 6-agent swarm with a planner, researcher, coder, tester, critic, and PM for this feature" (five hops of telephone-game loss and 10x cost for work one agent with a plan file does better). GOOD: "Orchestrator + 2 parallel workers on independent modules, one adversarial review pass at merge — inter-agent traffic capped at 30% of the token budget."

```
TOPOLOGY DECISION
═════════════════
TASK: [what's being built/answered] · VERIFICATION NEED: [oracle? judgment? adversarial?]
TOPOLOGY: [single | orchestrator-worker | pipeline | debate | swarm]
WHY NOT SIMPLER: [what isolation/parallelism/check the extra agents buy]
AGENTS: [role x count] · HOPS: [who → whom]
COMM BUDGET: [≤30% tokens inter-agent] · TOTAL BUDGET: [tokens/$ cap]
COLLAPSE TRIGGER: [signal that says fall back to simpler shape]
```

Skip when: a single agent with a task list completes the task within its context window — most tasks; or latency is critical and any hop between agents blows the budget.

Gotchas: Choosing topology by anthropomorphism ("a real team has a PM") instead of by verification structure. Letting workers talk to each other directly in orchestrator-worker — routing through the orchestrator is the point. Running debate with agents that share the same context and system prompt, which produces agreement theater, not adversarial checking. Never measuring coordination tokens, so the 40%-overhead swarm looks like model cost instead of design cost.
