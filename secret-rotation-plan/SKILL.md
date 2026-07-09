---
name: secret-rotation-plan
description: Use when designing or reviewing any system that stores, transmits, or authenticates with long-lived credentials -- API keys, DB passwords, signing keys, webhook secrets, cloud creds -- and needs a rotation schedule plus a zero-downtime cutover plan.
---

# /secret-rotation-plan — Credential Rotation Strategy

Use when designing or reviewing any system that stores, transmits, or authenticates with long-lived credentials and needs a rotation schedule plus a zero-downtime cutover plan.

**Persona: Credential Lifecycle Manager.** You design zero-downtime rotation strategies ensuring every secret has a schedule, a parallel-validity window, and an audit trail.

```
SECRET ROTATION PLAN
════════════════════

CREDENTIALS INVENTORY
  • Database password         | rotated last: [date] | next: [date]
  • API keys (third-party)    | rotated last: [date] | next: [date]
  • JWT signing key           | rotated last: [date] | next: [date]
  • Webhook secrets           | rotated last: [date] | next: [date]
  • Cloud provider creds      | rotated last: [date] | next: [date]

ROTATION FREQUENCY
  Critical (DB, signing keys): every 90 days
  Standard (API keys):         every 180 days
  Low-risk (read-only tokens): every 365 days

PROCESS
  1. Generate new credential
  2. Add to secret store (parallel to old)
  3. Deploy with both credentials valid
  4. Verify new credential works
  5. Remove old credential
  6. Verify old credential rejected
  7. Document rotation in audit log

EMERGENCY ROTATION (compromised)
  Same process, but step 3 = revoke immediately
  Acceptable downtime: ZERO (must have both valid during transition)
```

Decision rule: flag any credential past its schedule (Critical > 90 days, Standard > 180, low-risk > 365) as OVERDUE and block the plan until it has a next-rotation date; on confirmed compromise, emergency-rotate within 1 hour, never longer. Require a parallel-validity window of at least 1 full deploy cycle on every non-emergency rotation.

BAD: "Rotate the DB password Friday night." — single cutover, old and new never both valid, guaranteed downtime and no rollback path. GOOD: "Add new DB password alongside the old, deploy with both valid, verify new works, then revoke old." — parallel-validity window, zero downtime.

Skip when: the system holds no long-lived secrets and authenticates only via short-lived, auto-issued tokens (workload identity / OIDC with < 15 min TTL) that rotate themselves — there is nothing to schedule.

If you don't know when a credential was last rotated, write "unknown" -- never invent, back-date, or estimate a "rotated last" / "next" value.

Gotchas: Don't rotate credentials without a parallel-validity window -- immediately revoking old credentials causes downtime. Don't suppress rotation reminders -- credentials older than their rotation schedule are ticking time bombs. Don't store rotation history only in the secret manager -- maintain an audit log in a separate system for compliance.

---
