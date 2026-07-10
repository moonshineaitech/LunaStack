---
name: flaky-test-triage
description: Use when tests pass and fail non-deterministically and you need to find and fix the root cause instead of retrying. Produces a triage of the flake source with a real fix.
---

# /flaky-test-triage — Kill Flaky Tests at the Root

Use when a test passes on rerun — the most corrosive kind of test failure.

**Persona: Test Reliability Engineer.** You treat a flaky test as a real bug, because a suite people don't trust is a suite people ignore.

Flakiness has a small set of root causes — identify which: **(1) timing/async** (asserting before an async op completes — the #1 cause; fix with proper waiting, not sleeps); **(2) test-order/shared state** (a test depends on another's side effect or shared DB/global — isolate state, randomize order to expose it); **(3) time/timezone** (tests using real `now()`/timezone — freeze the clock); **(4) randomness** (unseeded random data — seed it); **(5) external dependencies** (real network/service — mock them); **(6) resource/concurrency** (parallel tests colliding on a port/file/row). Rule: **never "fix" a flake by adding a retry or a longer sleep** — that hides the bug and slows the suite. Quarantine the flake (skip + ticket) so it stops blocking CI, then fix the root cause. Reproduce by running it in a loop (`--count 100`) and under randomized order.

BAD: wrapping a flaky test in `retry(3)` and moving on — the underlying race still exists and will bite in production. GOOD: identify the missing `await`/wait condition, replace the implicit timing assumption with an explicit wait on the actual state, verify with 100 loop runs.

```
FLAKE TRIAGE
════════════
Symptom:     [passes on rerun; failure rate ~__%]
Reproduce:   [loop x100 / randomized order result]
Root cause:  [timing / order+shared-state / time / randomness / external / resource]
Fix:         [explicit wait / isolate state / freeze clock / seed / mock / dedicate resource]
NOT:         retry or longer sleep (hides the bug)
Verify:      [100 consecutive passes after fix]
```

Skip when: the "flake" is actually a real intermittent product bug — then it's `/debug`, and that's a finding, not a test problem.

Gotchas: retries and longer sleeps hide flakes instead of fixing them — and slow every run. A flake often reveals a real race that would also fail in production. Test-order flakes hide until you randomize order.
