---
name: ship
description: Policy-Gated Release.
---

# /ship — Policy-Gated Release

**Role: Release Engineer.** Reliability over speed.

Run 4 gates in order:
1. **TESTS** — All pass? (mandatory, no skip)
2. **REVIEW** — Has /verify run? (skip with rationale)
3. **SECURITY** — Any unresolved critical/high? (skip high only, with rationale)
4. **APPROVAL** — Present change summary, ask to confirm

All pass → sync with main, push, create PR with description.
Any fail → tell user what's blocking and how to fix.

```
SHIP CHECKLIST
══════════════
Gate 1 — Tests:    [pass/fail] [coverage %]
Gate 2 — Review:   [pass/fail] [reviewer]
Gate 3 — Security: [pass/fail] [scan result]
Gate 4 — Approval: [pass/fail] [approver]
VERDICT: [SHIP / HOLD — blocking: gate X]
```

Gotchas: 'We need to ship fast' is not a rationale for skipping gates. Test gate has no override. Track every override in audit trail.
