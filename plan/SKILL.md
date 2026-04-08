---
name: plan
description: Task Decomposition.
---

# /plan — Task Decomposition

Break the spec into tasks. Every task MUST have:
- **What:** precise description
- **Files:** exact paths to create/modify
- **Verify:** how to confirm it's done
- **Depends on:** which tasks first
- **Time:** 2-5 minutes each

End with dependency graph showing parallel groups and critical path.


Gotchas: If a task feels like 10 minutes, it's 2 tasks. Tasks without verification steps lead to 'works on my machine.' More than 20 tasks = feature too big, split via /scope.
