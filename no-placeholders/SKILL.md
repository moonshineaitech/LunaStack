---
name: no-placeholders
description: Use after writing any implementation plan, before execution. Scans for TBDs, ellipses, and unresolved choices; placeholders in acceptance criteria block, and each becomes a concrete question back to the user.
---

# /no-placeholders — Zero Tolerance Plan Validation

Use after writing any implementation plan, before execution.

**Persona: Plan Validator.** You become a zero-tolerance inspector who rejects any plan containing TBD, vague references, placeholder values, or ellipses -- demanding every task be executable by someone with no prior context.

The exact scan list — flag every occurrence of:
- `TBD`, `TODO`, `FIXME`, "figure out later", "somehow"
- `// ... existing code ...` or `// implementation here`
- "similar to Task N" / "use the same pattern as X" without spelling it out
- "etc." in a requirement position (fine in prose, fatal in a task list)
- Unresolved either/or choices ("Redis or Memcached", "REST or GraphQL")
- Placeholder values like `[VALUE]` without specifying what

Severity rule: a placeholder in **acceptance criteria or a task definition = BLOCK** (plan fails). A placeholder in a nice-to-have or future-work note = WARN (list it, don't block).

Resolution procedure: each blocking placeholder becomes ONE concrete question to the user — batched into a single message, not a drip. "Redis or Memcached?" becomes "Cache choice needed: Redis (persistence, more ops) vs Memcached (simpler, volatile). The plan's session-storage task needs this decided. Which?"

BAD plan line: "Task 6: Set up caching (Redis or similar) — details TBD."
GOOD plan line: "Task 6: Add Redis session cache via ioredis in src/cache.ts; TTL 3600s; Verify: `redis-cli TTL sess:test` returns ≤3600."

```
PLAN VALIDATION
═══════════════
□ Every task has exact file path
□ Every task has specific function/class name
□ Every code block is complete (no ellipses)
□ Every reference is spelled out, not abbreviated
□ Every value is concrete, not "TODO"
□ A junior engineer with no context could execute this

Blocking placeholders: [N] → [questions batched to user]
Warnings:              [N] (non-blocking, listed)
Verdict: PASS / FAIL (rewrite the failing tasks)
```

Skip when: validating exploratory notes or a brainstorm — this gate is for plans about to be EXECUTED, not for thinking out loud.

Gotchas: "I'll figure it out during execution" is the failure mode this prevents. Plans must be executable by Claude on a fresh session with zero context.
