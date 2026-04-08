---
name: linear-pipeline
description: The Superpowers Linear Pipeline.
---

# /linear-pipeline — The Superpowers Linear Pipeline

Use for any feature that takes more than 30 minutes.

The strict ordering. Skip a stage = degraded output.

```
1. /superpowers:brainstorm
   Socratic questioning. Refine the rough idea. Present design in chunks for validation.
   Output: A reviewed spec the user has signed off on.

2. /superpowers:write-plan
   Generate implementation plan from spec.
   Strict /no-placeholders validation.
   Plan reviewer (2nd subagent) checks: spec alignment, task decomposition, file structure.
   Output: A plan executable by a junior engineer with no context.

3. /superpowers:execute-plan
   Subagent-driven execution (mandatory on capable platforms).
   Each task: implement → test → verify → review → merge.
   Spec compliance review BEFORE code quality review.
   Output: Working, tested, reviewed code.

4. /verify-completion
   Prove it works. Run tests. Test UX. Match against spec.

5. /finish-branch
   Tests pass → merge or PR. Tests fail → fix or rollback.
```

Each stage has a verification gate. You don't proceed without clearing it.

Gotchas: Don't skip a stage to save time -- the pipeline exists because each stage catches different issues. Don't let the plan reviewer be the same context as the plan writer -- fresh eyes catch assumption gaps. Don't proceed past a failing verification gate -- fixing issues later is always more expensive than fixing them at the gate.
