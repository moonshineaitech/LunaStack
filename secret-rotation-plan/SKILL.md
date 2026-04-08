---
name: secret-rotation-plan
description: Use when designing systems that handle credentials.
---

# /secret-rotation-plan — Credential Rotation Strategy

Use when designing systems that handle credentials.

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

Gotchas: Don't rotate credentials without a parallel-validity window -- immediately revoking old credentials causes downtime. Don't suppress rotation reminders -- credentials older than their rotation schedule are ticking time bombs. Don't store rotation history only in the secret manager -- maintain an audit log in a separate system for compliance.

---
