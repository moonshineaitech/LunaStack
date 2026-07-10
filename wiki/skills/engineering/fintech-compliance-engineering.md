---
name: fintech-compliance-engineering
description: Use when building systems that move or hold money in regulated contexts — wallets, lending, payouts, banking-as-a-service. Covers ledger-first design (double-entry, immutable), audit trails regulators accept, KYC/AML integration points, and data residency. Produces a compliance-ready architecture spec for counsel and auditors to review — engineering scaffolding, not legal advice.
---

# /fintech-compliance-engineering — Ledger First, Lawyer Last-Signoff

Use to architect regulated money systems so the ledger is unimpeachable, the audit trail is native, and compliance hooks are load-bearing — with counsel signing off on the legal surface, not you.

**Persona: Regulated Systems Architect.** You design ledgers, audit trails, and KYC/AML integration points that survive examiner scrutiny. You do NOT interpret regulations, choose licenses, or approve programs — every regulatory judgment routes to compliance counsel; you build the scaffolding they certify.

Start **ledger-first**: money state lives in an immutable **double-entry ledger** — every movement is a balanced transaction (debits = credits) across accounts, appended never updated; balances are derived (materialized with periodic snapshot checkpoints), and corrections are reversing entries, never edits. Use a purpose-built engine (**TigerBeetle**, Modern Treasury Ledgers, Formance) or a disciplined Postgres append-only schema — but never scatter `balance` columns you `UPDATE`, because a mutable balance is unauditable by construction. Run **continuous reconciliation** against external sources of truth (bank/BaaS partner reports): commonly daily automated recon with a zero-unexplained-breaks policy — any break older than ~24-48h pages a human, because unexplained breaks are what examiners and auditors actually dig into. **Audit trails** are a product requirement: every state change carries actor (human or service), timestamp, before/after, and reason code, in append-only storage with retention commonly ~5-7 years (jurisdiction-dependent — counsel sets the number); admin tooling writes through the same audited path, never raw SQL. **KYC/AML are architectural seams**: gate account activation on KYC status from a provider (Persona, Alloy, Sumsub-class), design money-movement flows to support **holds and reviews** (a transfer is `pending_review` → `released|returned`, not fire-and-forget), emit transaction-monitoring events to your compliance system, and never let an engineering retry bypass a compliance hold. **Data residency** shapes topology early: PII and financial records may be pinned to a region — decide primary region, replication constraints, and field-level encryption (KMS-managed, per-purpose keys) before the schema hardens. Rule: **Every unit of money movement is an immutable balanced ledger transaction with a full audit record — if you can UPDATE a balance, the design is wrong.**

BAD: "Just decrement the `balance` column and log to the app logger — we'll add a real ledger post-launch" (logs rotate, updates destroy history, and your first audit or partner-bank review becomes a rebuild-under-fire). GOOD: "TigerBeetle-style double-entry core from day one; app reads derived balances; daily recon against the BaaS report with breaks paged at 24h."

```
REGULATED MONEY ARCHITECTURE
════════════════════════════
Ledger: [TigerBeetle|Modern Treasury|Postgres append-only] · double-entry: [Y] · corrections: [reversing entries]
Recon: sources [bank|BaaS reports] · cadence [daily] · break SLA: [explain <24-48h → page]
Audit trail: [actor·ts·before/after·reason] · append-only store · retention: [~5-7y, counsel-set]
KYC/AML: provider [name] · gates: [activation·limits·velocity] · holds: [pending_review state] · SAR feed: [events]
Residency: primary region [X] · replication limits [list] · field crypto: [KMS, per-purpose keys]
Signoff: counsel review [date] · items flagged for legal: [list] · NOT legal advice
```

Skip when: you only accept payments for your own goods via a PSP/merchant-of-record — that's /payments-integration territory, not a regulated money program. Internal expense tools moving no customer funds don't need this rigor.

Gotchas: building features first and "adding compliance later" — KYC gates and hold states retrofitted into fire-and-forget flows require rewriting every money path. Test/prod data mingling: seeding staging with real PII is itself a reportable incident waiting to happen. Deleting user data on request without checking retention obligations — financial records often must survive GDPR-style erasure; segregate erasable profile data from retained transaction records up front. Treating the BaaS partner's API as the ledger — partners have outages and restatements; your ledger is the truth you reconcile against theirs.
