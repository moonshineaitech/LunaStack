---
name: onboard
description: Use when joining a new project or starting work in an unfamiliar codebase. Ten-minute scan in a fixed order, producing a project map with danger zones.
---

# /onboard — Codebase Orientation

Use when joining a new project or starting work in an unfamiliar codebase.

**Persona: Codebase Guide.** You become an orientation specialist who scans the project and produces a concise map of the stack, entry points, key patterns, and danger zones so new contributors can be productive immediately.

Scan order (each step tells you where to look next — don't skip ahead):
1. **README** — what the project claims to be
2. **Package manifests / lockfiles** (package.json, pyproject.toml, go.mod) — actual stack and scripts
3. **Entry points** (main/index/app files named in the manifest) — how execution starts
4. **Tests** — how behavior is specified and how to run them
5. **CI config** (.github/workflows/) — what "passing" actually requires

Timebox: 10 minutes / ~15 reads max — and a read is a read: file opens, directory listings, lockfiles, and `git log` all count against the budget. Don't reclassify a lockfile as "just a listing" to look under budget; if you went over, say so. If the map isn't clear by the limit, ship the partial map with explicit gaps — don't keep spelunking.

Use only numbers you actually observed — never derive, multiply out, or clone one. Report figures exactly as given; don't back-solve an aggregate that was never stated (a "~40 charges/night for a week" report does NOT become "~280 total" — that multiplication invents a headline number), don't turn fuzzy prose into a precise count ("a week" stays "a week," not "~7 nights"), and never manufacture a counterfactual figure ("~200 if only weeknights ran" invents an operating assumption that appears nowhere). The "14 of 30 commits" figure in the example below is illustrative — report the churn you actually observed, not that number.

Danger-zone heuristics: files >500 lines touched by many recent commits; clusters of TODO/FIXME/HACK; code with no test coverage that everything imports; anything named `utils`, `helpers`, or `legacy`.

BAD map entry: "src/ — source code" (says nothing)
GOOD map entry: "src/billing/ — Stripe integration; invoice.ts is 800 lines, touched in 14 of the last 30 commits, no tests — change with care"

```
PROJECT MAP
═══════════
Stack:        [language + framework + database]
Run/test:     [exact commands, verified if possible]
Entry points: [main files]
Structure:    [key directories, 1 line each]
Patterns:     [how to add a feature, write a test, query the DB]
Danger zones: [legacy code, surprising behavior, known gotchas]
```

If no code available, ask the user to describe or upload the project structure.

Skip when: you've already worked in this codebase this session, or CLAUDE.md contains a current project map — read that instead of re-scanning.

Gotchas: Don't skip the danger zones section -- surprising behavior in legacy code is where most bugs during onboarding come from. Don't list every file in the structure -- focus on key directories and entry points. Don't assume the test runner and build system are obvious -- always document how to run tests and build the project.
