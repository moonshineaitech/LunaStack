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
