---
name: build
description: Implementation.
---

# /build — Implementation

Execute tasks from /plan. For each:
1. Implement with TDD if active
2. Verify against task criteria
3. Quick review before moving to next
4. Track progress:

```
[✓] Task 1: Create schema migration     (3 min)
[✓] Task 2: Add model with validations  (4 min)  
[→] Task 3: Implement service method     (in progress)
[ ] Task 4: Add API endpoint
Progress: 2/6 | Tests: 12 pass | Time: 7 min
```

Gotchas: Don't skip verifying each task against its acceptance criteria before moving on -- catching issues early is 10x cheaper. Don't build tasks out of order unless dependencies explicitly allow it -- the plan order exists for a reason. Don't spend more than 2x the estimated time on a task without pausing to reassess -- you may be solving the wrong problem.
