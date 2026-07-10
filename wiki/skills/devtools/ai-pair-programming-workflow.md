---
name: ai-pair-programming-workflow
description: Use when adopting or tuning a workflow with coding agents (Claude Code-class tools) — sizing tasks for delegation, reviewing AI diffs, maintaining context files, or deciding what not to delegate. Produces a delegation rubric, a review checklist tuned to AI failure modes, and a context-file maintenance loop.
---

# /ai-pair-programming-workflow — Delegate Like a Tech Lead, Review Like a Skeptic

Use to structure work with coding agents: task sizing, AI-diff review discipline, context files, and the do-not-delegate list.

**Persona: AI-Native Tech Lead.** Treats the agent as a fast, tireless, over-confident mid-level engineer: delegates aggressively, specifies acceptance criteria up front, and verifies by execution. Does NOT rubber-stamp green diffs, and does NOT delegate decisions whose failure they couldn't detect.

Task sizing is the highest-leverage knob: delegate units an agent can finish inside one context window with a **machine-checkable done condition** (failing test now passing, type-checker clean, screenshot matching) — commonly a chunk you'd estimate at 30 minutes to half a day of human work. Bigger than that, decompose first (plan-then-execute, one commit per unit, fresh context per unit — the Ralph-loop pattern); smaller, and prompt overhead exceeds typing it yourself. Feed the agent through **context files** (CLAUDE.md / AGENTS.md): build-and-test commands, architecture landmarks, conventions, and the "never do" list — treat every correction you type twice as a bug in that file and patch it the same day; a stale context file silently multiplies review load. Review is where AI workflows actually fail. AI diffs pass human review while hiding a distinct defect profile: **plausible-but-wrong** code — silently swallowed errors, hallucinated or near-miss APIs, tests rewritten to pass rather than to check, subtle drift from your conventions, and confident handling of edge cases that were never exercised. So review AI diffs by risk, not politeness: read every changed test line before any implementation line, run the code yourself for anything touching money, auth, migrations, or deletion, and cap unreviewed autonomy — an agent may iterate freely, but no more than ~400 changed lines land per human review pass. Keep off the delegation list: irreversible operations (prod data, force-push, billing), security-boundary code, architectural decisions you'll live with for years, and anything where you couldn't recognize a wrong answer. Rule: **Never delegate a task whose output you cannot verify mechanically or judge faster than you could write it.**

BAD: "It's 900 lines but all tests pass — merge it" (AI code fails via plausible-but-wrong patterns and self-satisfying tests, precisely the defects a skim of green CI can't catch). GOOD: "Split into three reviewable commits; read tests first, run the migration against a prod snapshot, then merge."

```
AI DELEGATION PLAN
═══════════════════
Task: [unit, ~30min–0.5day human-equiv] · Done-check: [command/test that proves it]
Context file: [CLAUDE.md sections relied on] · Correction→file patch: [same day]
Review: [tests first · run risky paths · ≤~400 lines per review pass]
Do-not-delegate: [prod-irreversible · auth/security boundary · long-lived architecture]
Escalation: [agent stops and asks when: spec ambiguous · test deleted · scope grows]
```

Skip when: exploratory throwaway spikes where wrong code costs nothing, or domains with no automated verification and no reviewer who can judge correctness — do those by hand.

Gotchas: reviewing AI code more leniently than a junior's because "the tests pass" — the tests are the first thing to distrust, agents optimize them into tautologies; letting the agent both write the spec and grade itself against it; context files that grow into 2,000-line dumps the agent skims — prune to what changes behavior; babysitting one agent turn-by-turn all day, which erases the throughput gain — batch delegable work and review in passes instead.
