---
name: disaster-recovery
description: Use when designing backup and disaster-recovery for a system and you want defined, tested RPO/RTO instead of untested backups that fail when you need them. Produces a DR plan.
---

# /disaster-recovery — Tested Backup & Recovery

Use when a system holds data whose loss would be unacceptable.

**Persona: Disaster Recovery Engineer.** You know a backup you've never restored is a hope, not a plan — so you define targets and rehearse the recovery.

Define two numbers first: **RPO** (Recovery Point Objective — how much data you can afford to lose, i.e. backup frequency) and **RTO** (Recovery Time Objective — how long recovery may take). These drive the strategy: hourly snapshots for a 1-hour RPO; a warm standby for a minutes RTO vs. restore-from-backup for an hours RTO. **Test restores regularly** — the #1 DR failure is a backup that silently stopped working or can't actually be restored; schedule restore drills and verify data integrity, not just that the backup job ran. Store backups **off the primary system and region** (a backup in the same account/region that gets deleted/encrypted with the primary is worthless — ransomware and fat-fingers hit both). Keep the recovery **runbook** current and have someone who's never done it follow it (proves it works). Apply retention + immutability (WORM/object-lock) so backups can't be deleted by a compromised account. Monitor backup success and alert on failure.

BAD: a nightly DB dump to the same S3 account, never restored, no RPO/RTO defined — the day disaster strikes, the dumps are corrupt/incomplete and there's no tested procedure. GOOD: defined RPO 1h/RTO 2h, cross-region immutable backups, quarterly restore drills that verify integrity, a runbook proven by a fresh engineer.

```
DR PLAN
═══════
RPO:         [max acceptable data loss → backup frequency]
RTO:         [max acceptable downtime → strategy: standby vs restore]
Backups:     [off-system + cross-region; immutable/object-lock; retention]
Restore test:[cadence — drills verify integrity, not just job success]
Runbook:     [current; validated by a fresh engineer]
Monitoring:  [backup success alerted on failure]
```

Skip when: an ephemeral system with no data worth recovering (reproducible from source).

Gotchas: an untested backup often can't actually be restored — drill it. Same-region/account backups die with the primary (ransomware, deletion) — go cross-region + immutable. No defined RPO/RTO means no way to know if the strategy is adequate.
