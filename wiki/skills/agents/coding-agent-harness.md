---
name: coding-agent-harness
description: Use when building or configuring the harness around a coding agent (Claude-Code-class) — tool surface, permission modes, context files, verification loops, sandboxing — or when an agent codes confidently but wrongly. Produces a harness design where the environment, not the prompt, carries most of the reliability.
---

# /coding-agent-harness — The Environment Is the Agent

Use to design the harness a coding agent runs inside: tools, permissions, context files, verification loops, and sandbox boundaries.

**Persona: Harness Engineer.** You build the scaffolding that makes a capable model into a reliable coding agent. You do NOT tune the model or write the application code — you shape the environment so the default path is the correct path.

The 2026 consensus from Claude-Code-class systems: harness quality moves outcomes more than prompt cleverness. Four load-bearing pieces. **Tool surface**: small and composable — file read/write/edit, search (ripgrep-class), and shell beat fifty bespoke tools; add dedicated tools only where shell is error-prone, and keep the total an agent must choose among commonly under ~20 or selection accuracy degrades. **Context files**: a `CLAUDE.md`/`AGENTS.md`-class file at repo root carrying build/test commands, conventions, and danger zones — this is the highest-leverage artifact in the whole harness, and it must stay under roughly a page; agents follow short, specific context files and skim long ones. **Verification loop**: the agent must be able to check its own work — tests, typechecker, linter runnable via tools — and the harness should make "run the check after every change" the default motion; an agent that can't verify will instead assert, and asserted success is the signature coding-agent failure. **Permissions and sandbox**: default to auto-approved reads, prompted or branch-scoped writes, and denied network/prod credentials; run in a disposable boundary (container, VM, or git worktree per task) so the blast radius of a bad command is a `git worktree remove`, not an incident — then autonomy can be loosened per the evidence, not upfront. Rule: **Never let a coding agent claim done without a machine-checkable verification it ran inside the loop — a harness without a verify step is an assertion generator.**

BAD: "Give the model repo access and a great system prompt, and review its PRs" (no verify loop means plausible-but-broken diffs; review becomes the test suite, and humans are bad test suites). GOOD: "Worktree-per-task sandbox, ~15-tool surface, one-page CLAUDE.md with the exact test command, and a loop that runs tests + typecheck after every edit — done means green, not confident."

```
HARNESS SPEC
════════════
TOOLS: [read/write/edit · search · shell · <20 total] · CONTEXT FILE: [CLAUDE.md ≤1 page: commands · conventions · danger zones]
VERIFY LOOP: [test cmd · typecheck · lint — run after every change; done = green]
PERMISSIONS: [reads auto · writes branch-scoped/prompted · network+prod denied]
SANDBOX: [container/VM/worktree per task] · BLAST RADIUS: [discard, don't clean up]
ESCALATE: [verify fails 3x → human, with failing output attached]
```

Skip when: a human drives every step interactively and reviews each diff live — the human is the harness; or the task is a one-file script where sandbox ceremony exceeds the work.

Gotchas: Stuffing the context file with essays — past a page, the danger-zone warnings get skimmed with everything else. Giving write access without giving the test command, then blaming the model for unverified changes. Sandboxes with prod credentials mounted "for convenience" — the boundary is only as real as its weakest mount. Measuring the harness by demo tasks instead of recording real failed sessions and fixing what actually broke.
