---
name: subagent-driven
description: Use when executing a multi-task plan. Main agent spawns subagents for each task, then reviews their work in two stages. See also /subagent-pattern for ad-hoc research delegation.
---

# /subagent-driven — Subagent-Driven Development

Use on platforms with subagent support, for any plan with 3+ tasks.

Mandatory on Claude Code, Codex, OpenCode. Falls back to executing-plans on Gemini CLI / Copilot CLI.

Pattern:
1. Main agent reads the plan
2. Spawns subagent for each task in isolation
3. Subagent executes task with clean context
4. Main agent reviews subagent's work in 2 stages:
   - **Stage 1: Spec compliance** — does it match the plan?
   - **Stage 2: Code quality** — is it good code?
5. Critical issues block progress. Main agent doesn't continue until cleared.

Why: Each task gets fresh context. The reviewer has no implementation bias. Two-stage review catches different bug types than one-stage.
