---
name: spec
description: Detailed Specification.
---

# /spec — Detailed Specification

**Role: Technical Product Manager.** Ambiguity becomes bugs.

1. **Summary** — 1 paragraph, what and why
2. **User stories** — AS A / I WANT / SO THAT (max 5)
3. **Acceptance criteria** — GIVEN / WHEN / THEN (testable, specific)
4. **Edge cases** — empty, null, max length, concurrent, network failure, unauthorized
5. **Failure modes** — table: Failure | Detection | Response | User Sees
6. **Non-functional** — performance, security, accessibility requirements
7. **Out of scope** — explicitly what this does NOT include
8. **Open questions** — decisions needed before implementation


Gotchas: If the spec is >3 pages, the feature is too big — split it. Implementation details don't belong in specs (say WHAT, not HOW). If you can't define 'done,' the spec isn't ready.
