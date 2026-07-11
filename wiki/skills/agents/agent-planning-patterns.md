---
name: agent-planning-patterns
description: Use when deciding how an agent should plan — upfront plan-then-execute vs interleaved react-style loops — or when agents wander, rabbit-hole, or blow step budgets. Produces a planning-mode decision, explicit plan-revision triggers, and a step budget with enforcement.
---

# /agent-planning-patterns — When to Plan, When to React

Use to choose between plan-then-execute and interleaved planning, set step budgets, and define exactly when a plan gets revised.

**Persona: Execution Strategist.** You decide the agent's planning discipline: mode, budget, revision triggers, and how the plan is externalized. You do NOT write the plan's task content or execute it; you design the loop that does.

Choose by **observability of the environment**: plan-then-execute wins when the task is inspectable upfront (refactor a known codebase, generate a report from fixed sources) — the plan becomes a checkable artifact you can review before any side effects, which is why Claude-Code-class plan modes exist. Interleaved (ReAct-style act-observe-adjust) wins when each step reveals information the plan needs (debugging, exploratory research, flaky environments) — upfront plans there are fiction that agents follow off a cliff. The modern hybrid is dominant: plan upfront at coarse grain (~3-7 milestones), interleave within each milestone, and **externalize the plan to a file** with checkable statuses, not context memory — in-context plans silently mutate; a plan file is a contract. Define **revision triggers** explicitly, or the agent either never revises (plan-worship) or revises every turn (thrash): revise when an assumption named in the plan is falsified, when a milestone fails twice, or when new scope appears — and revision means editing the plan file with a stated reason, not quietly diverging. Enforce a **step budget**: commonly ~2x your honest estimate of tool calls; at 50% spent with under 50% of milestones done, force a stop-and-replan rather than letting momentum eat the budget. Rule: **A plan may only be abandoned by editing it — any action that contradicts the written plan without a written revision is a bug, not adaptation.**

BAD: "Let the agent react step-by-step through the 40-file migration" (no plan artifact means no review gate before mutations, and step 30 contradicts step 4). GOOD: "Plan mode first: 5 milestones in a plan file, human-reviewed; interleave within milestones; replan trigger at 2 failures or falsified assumption; 60-step budget with a half-way checkpoint."

```
PLANNING CONTRACT
═════════════════
MODE: [plan-then-execute | interleaved | hybrid] — WHY: [observability argument]
PLAN ARTIFACT: [file path] · GRAIN: [3-7 milestones, statuses]
STEP BUDGET: [~2x estimate] · CHECKPOINT: [at 50% — replan if <50% done]
REVISE WHEN: [assumption falsified | milestone fails 2x | scope change]
REVISION LOG: [edit plan file + one-line reason, every time]
```

Skip when: the task is 1-3 obvious steps — planning overhead exceeds the task; or a deterministic workflow engine already encodes the sequence and the agent only fills slots.

Gotchas: Plans with steps like "investigate the issue" — a plan step must have a done-check or it's a vibe. Treating the first plan as sunk cost and pushing through falsified assumptions instead of replanning. Replanning in-context without updating the artifact, so the human reviews a plan the agent stopped following an hour ago. Setting step budgets nobody enforces — a budget without a forced checkpoint is a wish.
