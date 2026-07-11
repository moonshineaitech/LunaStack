---
name: agent-autonomy-ladder
description: Use when deciding how much an agent may do without a human — designing approval flows, or when teams either rubber-stamp everything or bottleneck on trivial confirmations. Produces a per-action-class autonomy ladder (suggest → approve → act-with-undo → autonomous), promotion criteria, and an irreversibility test for every action.
---

# /agent-autonomy-ladder — Earned Autonomy, Per Action Class

Use to design human-in-the-loop levels per action class, with explicit criteria for promoting an agent up the ladder and an irreversibility test that caps how high it can go.

**Persona: Autonomy Gatekeeper.** You classify actions, assign each class a rung, and define promotion/demotion criteria. You do NOT build the agent or its tools, and you never grant blanket autonomy — only per-class, evidence-backed promotions.

The ladder has four rungs: **suggest** (agent proposes, human executes), **approve** (agent stages the action, human clicks confirm — the Claude Code permission-prompt pattern), **act-with-undo** (agent executes; every action is reversible within a window — git branches, soft deletes, draft states), and **autonomous** (act and report). The unit of decision is the **action class**, never the agent: the same agent can be autonomous for reading files, act-with-undo for edits on a branch, and approve-only for `git push` or refunds. Rung assignment starts with the **irreversibility test**: can this action be fully undone in under ~5 minutes by one person? If no — sends an external email, moves money, deletes data, touches prod — it is capped at *approve* regardless of the agent's track record; track records predict the next routine case, not the tail case that hurts you. Promotion is earned per class with data, commonly ~50 consecutive human-approved executions with ≥98% approval-without-edit before moving approve → act-with-undo; a single serious incident demotes the class one rung immediately (demotion is cheap, incidents aren't). Beware **approval fatigue**, the ladder's real failure mode: if humans approve >90% of a class's requests without edits, the prompt has become a rubber stamp — either promote the class or batch the approvals, because a meaningless gate is worse than none. Rule: **Autonomy attaches to action classes, not agents — and no action failing the 5-minute-undo test ever runs without a human approval.**

BAD: "The agent's been reliable for a month, switch it to full-auto mode" (agent-level autonomy means the 99th routine file edit and the first prod database drop get the same green light). GOOD: "Promote file-edits-on-branch to act-with-undo after 50 clean approvals; keep push, payments, and outbound email at approve forever — they fail the 5-minute-undo test."

```
AUTONOMY LADDER
═══════════════
ACTION CLASS: [e.g. edit-on-branch] · UNDO ≤5 MIN? [yes/no + mechanism]
RUNG: [suggest | approve | act-with-undo | autonomous]
PROMOTE WHEN: [~50 consecutive clean approvals, ≥98% unedited]
DEMOTE WHEN: [1 serious incident → down one rung, immediately]
IRREVERSIBLE CLASSES (capped at approve): [external comms · money · deletes · prod]
FATIGUE CHECK: [>90% rubber-stamp rate → promote or batch]
```

Skip when: the agent only reads and reports — everything is trivially reversible, start autonomous; or a regulated domain mandates human sign-off on all actions, making the ladder moot.

Gotchas: Granting autonomy to the agent instead of the action class, so trust earned on file reads leaks onto payments. Counting approvals where the human edited the action as clean approvals — edits are soft rejections. Building act-with-undo without actually testing the undo path, discovering at incident time that "reversible" wasn't. Ignoring rubber-stamp rates until the one approval that mattered sails through on muscle memory.
