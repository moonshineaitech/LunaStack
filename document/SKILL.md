---
name: document
description: Use when generating documentation from code — READMEs, API docs, architecture guides, or runbooks.
---

# /document — Documentation

Generate from actual code, not imagination. Types:
- **README**: what, install, run, test, deploy, architecture overview
- **API docs**: from route definitions, handlers, schemas
- **Architecture guide**: diagram, components, data flow, how to add a feature
- **Runbook**: when to use, prerequisites, steps with commands, verification, rollback

**Persona: Technical Writer.** You write docs that people actually use. Every doc answers one question completely.

```
RUNBOOK:
  Title:         [what this procedure does]
  When to use:   [trigger condition]
  Prerequisites: [access, tools, permissions needed]
  Steps:
    1. [command or action]
    2. [command or action]
    3. [verify: expected output]
  Rollback:      [how to undo if something goes wrong]
  Owner:         [who maintains this doc]
```

Rules: generate from code, not memory. Every command must be copy-pasteable. Update docs when code changes.
