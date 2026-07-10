---
name: audit-logging
description: Use when building or reviewing audit trails for security-sensitive or compliance-bound actions — admin operations, permission changes, data access, financial events. Produces an append-only audit schema, event catalog, retention plan per regulation, and tamper-evidence design.
---

# /audit-logging — Audit Trails That Survive a Subpoena

Use to design audit logging that answers "who did what to what, when, and from where" years later, under hostile scrutiny.

**Persona: Compliance-Grade Logging Engineer.** Designs the audit event schema, storage, retention, and tamper-evidence; decides which actions are auditable. Does NOT build application debug logging or observability pipelines — audit logs are evidence, not telemetry, and mixing them ruins both.

An audit event is a fixed contract: **actor** (ID + type — human, service, or *AI agent acting for a human*: record both principal and the on-behalf-of user), **action** (past-tense verb from a closed catalog, e.g. `user.role.changed`), **target** (type + stable ID), **context** (timestamp in UTC, request ID, IP, session/token ID, before→after diff for mutations), and **outcome** (success/denied — log denied attempts; they're where the attacks are). Write it **append-only**: a dedicated table with INSERT-only DB grants (no UPDATE/DELETE for the app role), streamed to WORM storage — S3 Object Lock in compliance mode, or a locked bucket per your cloud — so even a compromised admin can't rewrite history. For tamper-evidence, hash-chain each event (`hash = H(prev_hash ‖ event)`) and anchor the head hash externally on a schedule; verification is then a linear scan, cheap enough to run nightly. Retention is regulation-driven, not vibes: commonly **6 years+ for HIPAA, 7 for SOX, ~1 year hot for PCI DSS (3 months immediately searchable)** — pick the max that applies, and set the lock *at write time*. Minimize PII: log identifiers, never payloads — `user:8842 viewed record:med-291`, not the record contents; store emails/names only when the identifier itself is the evidence, because GDPR erasure requests will collide with your immutable store (resolve via pseudonymous IDs joined to an erasable identity table). Emit the audit write in the same transaction as the mutation (or via transactional outbox) — an audit log that can silently miss events is worthless. Rule: **If the app's database role can UPDATE or DELETE audit rows, you don't have an audit log — you have a diary the intruder gets to edit.**

BAD: "We'll grep the application logs if compliance ever asks" (app logs rotate in 30 days, lack actor/target structure, are full of PII, and any engineer with shell access can edit them). GOOD: "INSERT-only `audit_events` table written in-transaction, streamed to S3 Object Lock (7y), hash-chained with a nightly verify job."

```
AUDIT TRAIL DESIGN
══════════════════
Event schema: [actor+on_behalf_of · action · target · context · outcome]
Action catalog: [n events · closed enum]
Write path: [in-txn | outbox] · Store: [INSERT-only table → WORM tier]
Tamper-evidence: [hash chain · anchor cadence · verify job]
Retention: [regulation → years · lock mode] · PII policy: [IDs only]
Access: [who can read · reads are themselves audited: y/n]
```

Skip when: the product has no compliance surface and no multi-user trust boundary (single-tenant internal tool) — structured app logs suffice; or you're on a platform (Salesforce, Workday) whose native audit trail already covers the actions.

Gotchas: logging request payloads "for context" and thereby copying PII/secrets into a store you've made immutable and long-lived; writing audit events async fire-and-forget so failed writes vanish exactly when the system is under attack; using auto-increment IDs and timestamps as "proof of order" across services with clock skew instead of a hash chain; letting admins read audit logs through a path that isn't itself audited.
