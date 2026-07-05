---
name: spec
description: Use when requirements are clear enough to write down but code hasn't started. Produces testable acceptance criteria, an edge-case checklist, and an explicit out-of-scope list.
---

# /spec — Detailed Specification

**Role: Technical Product Manager.** Ambiguity becomes bugs.

1. **Summary** — 1 paragraph, what and why
2. **User stories** — AS A / I WANT / SO THAT (max 5)
3. **Acceptance criteria** — GIVEN / WHEN / THEN (testable, specific)
4. **Edge cases** — the checklist below; each addressed or explicitly marked N/A with a reason
5. **Failure modes** — table: Failure | Detection | Response | User Sees
6. **Non-functional** — performance, security, accessibility requirements
7. **Out of scope** — explicitly what this does NOT include
8. **Open questions** — decisions needed before implementation

Acceptance criterion example (this is the bar):
GIVEN a logged-in user with an expired session token, WHEN they submit the checkout form, THEN they are redirected to login with the cart preserved and see "Session expired — your cart is saved."

Edge-case checklist — address every row or mark N/A: empty input · maximum input · concurrent access · permission denied · network failure mid-operation.

Placeholder rule: a spec containing TBD, "figure out later," or an unresolved either/or ("Redis or Memcached") is not READY — route it through /no-placeholders and resolve before /plan.

BAD criterion: "The form should handle errors gracefully." (not testable — what error, what behavior?)
GOOD criterion: the GIVEN/WHEN/THEN above — a test can be written from it verbatim.

```
SPECIFICATION
══════════════
Summary:            [1 paragraph]
User stories:       [count] defined
Acceptance criteria: [count] GIVEN/WHEN/THEN clauses
Edge cases:         [5/5 addressed or N/A'd with reasons]
Failure modes:      [count] documented
Non-functional:     [performance / security / a11y requirements]
Out of scope:       [list of exclusions]
Open questions:     [count remaining]
Status:             [READY / BLOCKED on [question]]
```

Skip when: the change is a bug fix with a reproduction (that's /debug — the repro IS the spec), or a one-line change with an existing test.

Gotchas: If the spec is >3 pages, the feature is too big — split it. Implementation details don't belong in specs (say WHAT, not HOW). If you can't define 'done,' the spec isn't ready.
