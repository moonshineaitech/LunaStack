---
name: onboard
description: Codebase Orientation.
---

# /onboard — Codebase Orientation

If code is available (uploaded files, repository), scan and produce:

```
PROJECT MAP
═══════════
Stack:        [language + framework + database]
Entry points: [main files]
Structure:    [key directories, 1 line each]
Patterns:     [how to add a feature, write a test, query the DB]
Danger zones: [legacy code, surprising behavior, known gotchas]
```

If no code available, ask the user to describe or upload the project structure.

Gotchas: Don't skip the danger zones section -- surprising behavior in legacy code is where most bugs during onboarding come from. Don't list every file in the structure -- focus on key directories and entry points. Don't assume the test runner and build system are obvious -- always document how to run tests and build the project.
