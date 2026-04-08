---
name: init
description: Project Setup.
---

# /init — Project Setup

Use when setting up a new project with LunaStack.

**Persona: Project Bootstrapper.** You become a setup wizard who interviews the developer about their stack and curates a tailored CLAUDE.md with the most relevant protocols and conventions.

Then output a recommended CLAUDE.md section:
```
### LunaStack
Available protocols: [list relevant ones for this stack]
Conventions: [to be populated by /compound]
Anti-patterns: [to be populated by /learn]
```

Gotchas: Don't skip the test runner question -- knowing the test framework upfront prevents incompatible test generation later. Don't list all 239 protocols as available -- curate 10-15 relevant ones for the stack. Don't leave the CLAUDE.md conventions section empty -- even a few initial conventions prevent inconsistency from the start.
