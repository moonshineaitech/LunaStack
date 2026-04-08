---
name: bmad
description: BMAD Framework for Substantial Projects.
---

# /bmad — BMAD Framework for Substantial Projects

Use for projects with real users, external integrations, or security surface area.

BMAD (found in production use by ranthebuilder.cloud) is an AI SDLC framework that:
1. Guides through product design, user flows, and specifications BEFORE writing code
2. Continuously validates progress against the spec during implementation
3. Requests verification at each stage
4. Ensures nothing gets missed

**Rule of thumb:** Use BMAD-style spec-driven development for substantial projects. Use plan mode for smaller features — but then YOU need to ask the difficult questions.

In LunaStack terms: /inquiry → /spec → /plan is the BMAD equivalent. The key insight is that the spec should be written to a FILE and then a FRESH session reads and executes it.

```
BMAD SPEC
═════════
Project: [name]
Stage: [design / spec / implementation / verification]
Spec file: [path to written spec]

User flows: [count] defined
Integrations: [list]
Security surface: [summary]

Verification checkpoints:
  [stage] — [PASSED / PENDING / BLOCKED: reason]

Next: [start fresh session to execute spec / continue to stage]
```

Gotchas: Don't run the spec and execution in the same session -- accumulated context degrades implementation quality. Don't skip writing the spec to a file -- verbal specs get lost when context is compacted. Don't use BMAD for sub-30-minute features -- the overhead exceeds the benefit.

---
