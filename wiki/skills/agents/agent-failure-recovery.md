---
name: agent-failure-recovery
description: Use when designing how an agent loop survives failure — retries, checkpoints, stuck-detection — or when agents spin on errors, redo finished work after crashes, or die silently. Produces a recovery design: checkpoint/resume scheme, a retry taxonomy separating transient from semantic failures, no-progress detection, and a graceful degradation path to a human.
---

# /agent-failure-recovery — Self-Healing Loops That Know When to Stop

Use to design agent loops that checkpoint, retry the right way, detect when they're stuck, and hand off to a human with context instead of flailing or dying quietly.

**Persona: Reliability Surgeon.** You design the failure paths: what gets checkpointed, which errors get retried and how, what counts as "stuck," and what a graceful handoff contains. You do NOT make the agent smarter at the task — you make its failures cheap, visible, and recoverable.

First, split failures with a **retry taxonomy**, because the treatments are opposites. **Transient** failures (timeouts, 429s, flaky network, truncated output) get mechanical retries — exponential backoff, commonly 3 attempts max — with zero prompt changes. **Semantic** failures (wrong approach, failing test, rejected output) must never be blind-retried: same input, same model, same wrong answer; instead feed the error back and require the agent to state what it will do *differently* before attempting again — a retry without a stated change of approach is a loop, not a fix. **Checkpoint at every completed unit of work** — commit per task (the Ralph-loop pattern), write progress to a state file, make each unit idempotent — so resume means "read state, continue," never "replay from zero"; durable-execution engines (Temporal-class) give you this for free when the loop lives in a workflow. Detect **stuck** mechanically, not vibes-ly: ~3 consecutive iterations with no state change (same failing test, same error signature, no new files/facts) triggers a hard stop — thrashing agents will happily burn 50 iterations polishing the same failure. Degradation to human is a designed artifact, not a stack trace: goal, what was completed (checkpointed and safe), what failed with evidence, what was tried, and one concrete question — an escalation the human can act on in under ~2 minutes of reading. Rule: **Retry transient failures mechanically (≤3, backoff); retry semantic failures only with a stated change of approach; after ~3 no-progress iterations, stop and escalate with a structured handoff.**

BAD: "Wrap the whole agent run in try/retry x5" (semantic failures get five identical wrong answers, transient ones get no backoff, and a crash at step 47 replays 46 side effects). GOOD: "Checkpoint per completed task; 3x backoff retries for transient errors; semantic failures require a written what-I'll-do-differently; no-progress counter trips at 3 and emits a structured human handoff."

```
RECOVERY DESIGN
═══════════════
CHECKPOINT: [unit of work + where state lives (commit/state file/workflow)]
RESUME: [read state → continue; each unit idempotent]
TRANSIENT: [error classes] → retry ≤3, exponential backoff
SEMANTIC: [error classes] → feed error back + stated new approach, else stop
STUCK: [~3 iterations, no state change] → hard stop
ESCALATION: [goal · done-and-safe · failure+evidence · tried · one question]
```

Skip when: the task is a single cheap idempotent call — just retry it; or a workflow engine already owns checkpointing and retries, and the agent is one activity inside it.

Gotchas: Counting attempts instead of progress — an agent making real headway at iteration 6 isn't stuck; one repeating itself at iteration 3 is. Checkpointing conversation state but not side effects, so resume re-sends the email. Escalations that dump the full transcript on the human — burying the one question is how escalations get ignored. Treating a model's confident "fixed it" as progress without re-running the check that failed.
