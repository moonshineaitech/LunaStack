---
name: no-placeholders
description: Zero Tolerance Plan Validation.
---

# /no-placeholders — Zero Tolerance Plan Validation

Use after writing any implementation plan, before execution.

A plan is a FAILURE if it contains ANY of:
- `TBD` or vague descriptions
- `// ... existing code ...`
- `// implementation here`
- "similar to Task N" shorthand
- "use the same pattern as X" without spelling it out
- Undefined references
- Placeholder values like `[VALUE]` without specifying what

```
PLAN VALIDATION
═══════════════
□ Every task has exact file path
□ Every task has specific function/class name
□ Every code block is complete (no ellipses)
□ Every reference is spelled out, not abbreviated
□ Every value is concrete, not "TODO"
□ A junior engineer with no context could execute this

Verdict: PASS / FAIL (rewrite the failing tasks)
```

Gotchas: "I'll figure it out during execution" is the failure mode this prevents. Plans must be executable by Claude on a fresh session with zero context.
