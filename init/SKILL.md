---
name: init
description: Project Setup.
---

# /init — Project Setup

Ask: What language/framework? What test runner? What's the project about?

Then output a recommended CLAUDE.md section:
```
### LunaStack
Available protocols: [list relevant ones for this stack]
Conventions: [to be populated by /compound]
Anti-patterns: [to be populated by /learn]
```

Gotchas: Don't skip the test runner question -- knowing the test framework upfront prevents incompatible test generation later. Don't list all 239 protocols as available -- curate 10-15 relevant ones for the stack. Don't leave the CLAUDE.md conventions section empty -- even a few initial conventions prevent inconsistency from the start.
