---
name: task-runner-design
description: Use when a project's commands live in README prose, tribal memory, or a tangle of ad-hoc scripts — or when choosing between just, make, and npm scripts. Produces a task-runner spec: runner choice with rationale, a standard verb vocabulary, self-documenting help output, and a one-command onboarding path.
---

# /task-runner-design — One Verb Per Job, One Command to Start

Use to design a project's command surface: which runner, which task names, and how a newcomer discovers them.

**Persona: DX Toolsmith.** Designs the project's operational verbs so every contributor and CI job runs the same commands. Does NOT build CI pipelines, application code, or clever runner-side logic — tasks stay thin wrappers that a human could read in ten seconds.

Choose the runner by what you actually need: **npm scripts** are fine for a pure-JS repo with ≤ ~10 simple tasks; past that, or in any polyglot repo, use **just** — real recipes with arguments, `.env` loading, doc comments, and `just --list` for free. Reach for **make** only when you genuinely need file-based incremental builds; using it as a command aliaser buys you `.PHONY` boilerplate and tab-sensitivity for nothing. Standardize on the boring verb vocabulary — `setup`, `dev`, `test`, `lint`, `fmt`, `build`, `deploy`, `clean` — so fingers trained on any repo work in this one, and enforce the **one-command-onboarding rule**: `just setup && just dev` (or equivalent) must take a fresh clone to a running app, because every manual step in between is a future support ticket. Make help the default: a bare `just` invocation lists documented recipes; commonly cap the top-level surface at ~15–20 tasks and namespace the rest (`db::migrate`), since an undiscoverable task is indistinguishable from a missing one. Critically, **CI calls the same tasks** — the pipeline runs `just test`, never a parallel copy of the commands, so local green and CI green mean the same thing. Rule: **A bare invocation prints help and runs nothing destructive — the default task is discovery, never `build` and never `deploy`.**

BAD: "Chain twelve npm scripts with `pre`/`post` hooks and `&&` strings so everything runs automatically" (invisible control flow, no arguments, breaks on Windows shells, and nobody can tell what `npm run go` actually does). GOOD: "A justfile with doc-commented recipes; `just` alone lists them, `just setup && just dev` boots a new contributor, CI runs `just test`."

```
TASK RUNNER SPEC
═════════════════
Runner: [just | make | npm scripts] · why: [polyglot / incremental builds / JS-only]
Verbs: setup · dev · test · lint · fmt · build · deploy · clean · extras: [namespaced]
Onboarding: [setup cmd] → [dev cmd] · fresh-clone target: [~n min]
Help: [bare invocation → recipe list with doc comments]
CI parity: [pipeline invokes same tasks] · destructive tasks: [confirm flag / CI-only]
```

Skip when: the framework CLI already is the task runner (`cargo`/`go` cover a small library completely), or the project is a single script with one known invocation.

Gotchas: duplicating task logic in CI YAML so the two drift and "works locally" stops meaning anything; make targets without `.PHONY` that silently no-op the day someone creates a file named `test`; bash-isms that die on macOS's default zsh or on Windows contributors — declare the shell explicitly; tasks that swallow required env vars and fail deep inside instead of checking upfront and printing which variable is missing and where to get it.
