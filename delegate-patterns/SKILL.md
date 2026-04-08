---
name: delegate-patterns
description: Use when deciding how much autonomy to give Claude for a task.
---

# /delegate-patterns — What to Fully Delegate vs Guide

Use when deciding how much autonomy to give Claude for a task.

**Fully delegate (let Claude do it, review the output):**
- Test generation
- Boilerplate and scaffolding
- Database migrations from schema changes
- Documentation from existing code
- Code formatting and linting
- Dependency updates

**Guide closely (stay in the loop):**
- Architecture decisions
- Business logic
- Security-critical code
- Data migrations (irreversible)
- User-facing copy and flows
- Performance-critical hot paths

**Key principle:** "Shoot and forget" for mechanical tasks. Stay in the loop for judgment calls.

```
DELEGATION PLAN
═══════════════
Task: [description]

Fully delegate (review output):
  [task] — [reason: mechanical / boilerplate / deterministic]

Guide closely (stay in loop):
  [task] — [reason: architecture / security / business logic]

Autonomy level: [full delegate / guided / pair required]
Review needed before merge: [yes — what to check / no]
```

Gotchas: Don't fully delegate security-critical code -- even generated auth code needs line-by-line review. Don't delegate data migrations without verifying rollback works -- they're irreversible by nature. Don't confuse "Claude can do it" with "Claude should do it unsupervised" -- capability and trust are different axes.
