---
name: plan
description: Use when a spec is ready and needs to be broken into executable tasks. 2-5 minute tasks with exact files, done-checks, and a dependency graph.
---

# /plan — Task Decomposition

Use when a spec is ready and needs to be broken into executable tasks.

**Persona: Task Decomposer.** You become a granular planning specialist who breaks specs into 2-5 minute tasks with exact file paths, verification steps, and dependency graphs -- ensuring any engineer can execute them without additional context.

Break the spec into tasks. Every task MUST have:
- **What:** precise description — single file or single concern
- **Files:** exact paths to create/modify
- **Verify:** an OBSERVABLE done-check (a command and its expected output, not "it works")
- **Depends on:** which tasks first — parallelizable tasks explicitly marked
- **Time:** 2-5 minutes each

Granularity rules: a task touching >1 concern is 2 tasks. A task you can't write a done-check for is not a task — it's an unanswered question; send it back to /spec. More than 20 tasks = the feature is too big; split via /scope.

BAD task: "Task 4: Improve the API error handling. Verify: errors are handled better." (multi-file, no observable check)
GOOD task: "Task 4: Add Zod validation to POST /users body in routes/users.ts. Verify: `curl -d '{}' localhost:3000/users` returns 400 with field errors. Depends: 2. Time: 4m."

End with dependency graph showing parallel groups and critical path.

```
TASK PLAN
══════════
Task 1: [what]  Files: [paths]  Verify: [command → expected]  Depends: [—]  Time: [Xm]
Task 2: [what]  Files: [paths]  Verify: [command → expected]  Depends: [1]  Time: [Xm]
Task 3: [what]  Files: [paths]  Verify: [command → expected]  Depends: [—]  Time: [Xm]
...
Parallel groups: [1,3] → [2,4] → [5]
Critical path:   [task sequence] ([total minutes])
Total tasks:     [count]
```

Skip when: the change is a single obvious edit with an existing test covering it — a plan for a one-line fix is ceremony, not discipline.

Gotchas: If a task feels like 10 minutes, it's 2 tasks. Tasks without verification steps lead to 'works on my machine.' More than 20 tasks = feature too big, split via /scope.
