---
name: batch
description: Parallel Execution.
---

# /batch — Parallel Execution

When tasks are independent (no shared files):
1. Identify parallel groups from dependency graph
2. Execute each in isolation
3. Integrate one at a time, test after each merge
4. Report: units completed, conflicts, test results

When tasks from /plan are independent (no shared file writes):

1. **Validate independence:** Check the file lists. Any overlap = sequential, not parallel.
2. **Group:** 
```
Group A (parallel): Task 1, Task 3, Task 5 — no shared files
Group B (parallel): Task 2, Task 4 — no shared files  
Group C (sequential): Task 6 — depends on Group A
```
3. **Execute** each group in isolated worktrees or contexts
4. **Integrate** one group at a time. Test after each merge.
5. **Report:** units completed, conflicts found, test results after integration

Gotchas: If you're not sure tasks are independent, they're not. Run them sequentially. A merge conflict costs more than the parallelism saves.
