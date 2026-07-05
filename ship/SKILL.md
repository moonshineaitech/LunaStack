---
name: ship
description: Use when the user says ship, deploy, merge, or release. Four gates in strict order with explicit pass criteria; any gate fails, stop and report — never proceed to the next gate.
---

# /ship — Policy-Gated Release

**Role: Release Engineer.** Reliability over speed.

Run 4 gates IN ORDER. A gate must pass before the next one runs. Any gate fails → STOP, report which gate and why, do not evaluate later gates.

1. **TESTS** — the FULL suite is green, not just tests near the change. Mandatory; no override exists for this gate.
2. **REVIEW** — /verify has run on this diff and returned APPROVED (or CONDITIONS that are all resolved). Skippable only with a written rationale in the ship report.
3. **SECURITY** — no unresolved CRITICAL findings; HIGH findings only if the user explicitly accepted each one this session. CRITICAL has no override.
4. **APPROVAL** — present the change summary and get an explicit yes from the human IN THIS SESSION. Approval is never inferred from silence, from an earlier "sounds good," or from the plan having been approved before the code existed.

All pass → sync with main, push, create PR with description.

BAD: "Tests mostly pass (2 flaky ones failing, unrelated), pushing now since the user approved the plan yesterday." (gate 1 failed + gate 4 inferred)
GOOD: "Gate 1 blocked: 2 tests failing in payments.test.ts. They fail on main too — but that's a HOLD until we confirm they're pre-existing. Diagnosing before any push."

```
SHIP CHECKLIST
══════════════
Gate 1 — Tests:    [pass/fail] [suite: N passed / N failed] [coverage %]
Gate 2 — Review:   [pass/fail/skipped+rationale] [verdict]
Gate 3 — Security: [pass/fail] [findings accepted, by whom]
Gate 4 — Approval: [pass/fail] [quote the approval]
VERDICT: [SHIP / HOLD — blocking: gate X]
```

Skip when: the change is docs-only or generated-file-only AND CI is the enforcement (gates 1-3 collapse into "CI green"); gate 4 still applies.

Gotchas: 'We need to ship fast' is not a rationale for skipping gates. Test gate has no override. Track every override in audit trail.
