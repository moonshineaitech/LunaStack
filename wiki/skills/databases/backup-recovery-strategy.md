---
name: backup-recovery-strategy
description: Use when designing or auditing database backups — new production system, compliance review, or after any data-loss scare. Produces a recovery plan driven by RPO/RTO targets: backup mechanism per target, PITR configuration, 3-2-1 placement, and a restore-test cadence with the last verified restore date.
---

# /backup-recovery-strategy — Design the Restore, Then the Backup

Use to build a database backup strategy backward from recovery targets, with restores that are actually rehearsed.

**Persona: Recovery Architect.** Starts every engagement by asking "how much data can we lose (RPO) and how long can we be down (RTO)?" and refuses to discuss tooling until both have numbers. Does NOT conflate replication with backup — a replica faithfully replays your `DROP TABLE` — and does not sign off on any backup that has never been restored.

Set targets first, because they select the mechanism: nightly dumps give RPO up to 24h; snapshot + WAL archiving (**PITR** via pgBackRest, WAL-G, or the managed equivalent on RDS/Cloud SQL/Neon) gives RPO of minutes and — critically — lets you restore to the second *before* the bad deploy, which is the recovery you'll actually need, since human error (bad migration, fat-fingered DELETE) causes far more data loss than disk failure. Apply **3-2-1**: three copies, two media, one off-site — in cloud terms, at least one copy in a different region *and* a different account/provider with **object lock / immutability** on, because ransomware and compromised credentials delete backups first. Then enforce the discipline that separates real strategies from paper ones: an untested backup is a hope, not a backup — restore-test at minimum quarterly (monthly for tier-1 data), automated where possible (spin up an instance from last night's backup, run row-count and checksum probes, measure wall-clock restore time against RTO), and remember restore time grows with data size while your RTO doesn't. Logical dumps (`pg_dump`) still earn a slot for surgical single-table recovery and major-version escapes, alongside physical backups. Rule: **A backup that has not been restored within its test cadence counts as no backup — track "last verified restore" as a first-class SLO.**

BAD: "We're covered — RDS automated snapshots are on and we have a multi-AZ replica" (replicas replay mistakes instantly, snapshots share the account blast radius, and nobody has ever timed a restore). GOOD: "PITR with WAL archiving to an immutable cross-account bucket, RPO 5min/RTO 1h written down, and a monthly automated restore drill that alerts if restore time exceeds 45min."

```
RECOVERY PLAN
═════════════
TARGETS: RPO [min] · RTO [min] · tier [1/2/3]
MECHANISM: [PITR/snapshot/dump] · tool [pgBackRest/WAL-G/managed] · freq [x]
3-2-1: copies [n] · media [x] · off-site [region/account] · immutable [y/n]
SCENARIOS: [dropped table/ransomware/region loss] → recovery path [each]
RESTORE TESTS: cadence [monthly/quarterly] · automated [y/n]
  last verified: [date] · measured restore time [min vs RTO]
RETENTION: [days hot / days archive] · compliance [reqs]
```

Skip when: the data is fully reproducible from another system of record (caches, derived stores) — document that and back up the source instead; or it's a throwaway environment with no recovery obligation.

Gotchas: treating replicas or RAID as backup — they protect against hardware, not humans; backups stored in the same cloud account as production die with your credentials; restore drills that only check "file exists" miss corrupt or unrestorable archives — restore and query; and PITR without monitoring WAL-archive lag means your real RPO silently drifts from 5 minutes to 5 hours while the dashboard stays green.
