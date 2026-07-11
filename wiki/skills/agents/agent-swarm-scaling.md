---
name: agent-swarm-scaling
description: Use when scaling from one agent to a fleet of parallel agents on a decomposable workload — bulk migrations, many-module refactors, wide research sweeps. Produces the fleet design: work decomposition with isolation (worktrees/containers), merge and dedup strategy, and adversarial verification before results count.
---

# /agent-swarm-scaling — Fleets Without Fratricide

Use to run many agents in parallel on decomposed work with hard isolation, deliberate merging, and verification that doesn't trust the workers.

**Persona: Fleet Coordinator.** You decompose the work, enforce isolation, and own the merge. You do NOT do the shard work, and you never let a worker's self-reported success count as done.

Parallelism pays only when **decomposition is real**: shards must be independently completable and independently verifiable, with interfaces between them frozen *before* fan-out — if two shards need to negotiate mid-flight, they were one shard. Slice by module/directory/file-set for code, by source or subclaim for research; write each shard as a self-contained brief (goal, owned paths, frozen interfaces, done-check) because workers share no context. **Isolation is physical, not polite**: one git worktree or container per worker (the standard Claude-Code-fleet pattern), no shared mutable state, workers forbidden from touching paths outside their shard — two agents editing one file produces corruption that looks like progress. Size soberly: fan out commonly 3-10 workers; beyond that, merge and verification become the bottleneck and the coordinator drowns — throughput scales sublinearly while review cost scales superlinearly. **Merging is its own job**: integrate shards one at a time onto a clean base, re-running the full verify suite after each landing (not once at the end, or you get a bisection nightmare); for research fleets, dedup near-identical findings by normalizing claims before counting agreement — ten workers citing one upstream source is one source, not consensus. Then the step fleets skip: **adversarial verification** — a fresh-context reviewer agent (or human) per shard that actively tries to falsify the done-check, because worker self-reports optimize for looking finished, and at fleet scale a 5% hallucinated-success rate means every batch ships defects. Rule: **No shard merges on its worker's word — every shard passes an independent, fresh-context verification against its done-check before integration.**

BAD: "Launch 20 agents on the repo and merge all branches Friday" (overlapping edits, drifted interfaces, and one mega-merge where 20 shards' failures superpose). GOOD: "8 workers, one worktree each, frozen interfaces in shard briefs, land shards serially with full test runs, adversarial review per shard before it counts."

```
FLEET PLAN
══════════
SHARDS: [N=3-10 · shard → goal · owned paths · frozen interfaces · done-check]
ISOLATION: [worktree/container per worker · no shared mutable state]
WORKER BRIEF: [self-contained; no cross-shard chat]
MERGE: [serial landings onto clean base · full verify after each]
DEDUP: [normalize claims/diffs · collapse same-upstream findings]
VERIFY: [fresh-context adversarial pass per shard — falsify the done-check]
```

Skip when: the work has a serial dependency spine — pipeline it instead; or total work fits one agent's context and budget, where fleet overhead is pure loss.

Gotchas: Decomposing by effort ("split it into 10 equal parts") instead of by independence, guaranteeing mid-flight collisions. Letting workers "coordinate" through shared files — that's a race condition with extra steps. Verifying with the worker's own context, which inherits its blind spots; fresh context is the point. Scaling worker count while the human merge/review budget stays flat — the queue after the fleet is the real capacity limit.
