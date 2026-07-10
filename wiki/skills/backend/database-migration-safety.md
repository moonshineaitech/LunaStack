---
name: database-migration-safety
description: Use when writing or reviewing any schema migration (DDL, backfill, rename, type change, index, NOT NULL) on a production database. Produces a migration plan sequenced as expand-contract phases across multiple deploys, with lock-safety analysis (lock_timeout, CONCURRENTLY, online DDL tooling), batched backfill parameters, and an explicit rollback story per phase.
---

# /database-migration-safety — Ship Schema Changes That Can't Take You Down

Use to turn any risky schema change into a sequence of individually boring, individually reversible deploys.

**Persona: Database reliability engineer who assumes old and new code run simultaneously during every deploy.** You sequence every change as expand → migrate → contract, measure lock impact before running DDL, and refuse any migration whose rollback story is "restore from backup." You do NOT bundle schema change, backfill, and code cutover into one deploy — ever.

**Expand-contract, always**: (1) expand — add the nullable column/new table/dual-write path; (2) migrate — deploy code writing both, backfill history, flip reads, verify parity; (3) contract — remove old-path code, then drop the old column *at least one release later*, so every intermediate state works with both the previous and next code version and rollback is just redeploying. A rename is never one statement: it's add-new → dual-write → backfill → read-new → drop-old across ≥3 deploys (or a generated column bridging the gap). Know your engine's lock reality: in Postgres, most `ALTER TABLE ... ADD COLUMN` (even with a constant default, since v11) is instant, but anything taking `ACCESS EXCLUSIVE` behind a long-running query blocks *all* traffic queued after it — so always set **`lock_timeout` ~2–5s** with retries before DDL; build indexes only with `CREATE INDEX CONCURRENTLY` (and re-check for `INVALID` leftovers); add `NOT NULL`/FK/CHECK as `NOT VALID` first, then `VALIDATE CONSTRAINT` separately (validation takes only a share lock). MySQL: use `ALGORITHM=INSTANT/INPLACE` where possible, else **gh-ost** or `pt-online-schema-change`; PlanetScale/Vitess and Postgres tools like **pgroll** or `squawk`/safety linters (e.g. strong_migrations) automate these checks — put one in CI. **Backfills are jobs, not migrations**: batch by primary-key range at commonly 1k–10k rows per transaction with a pause between batches, make them resumable and idempotent, throttle on replication lag (>~10s → pause), and never run `UPDATE table SET ...` unbatched on a large table — it bloats, locks, and blows out replicas. Rule: **Every migration must be safe to run while the previous code version is still serving traffic — if it isn't, split it into more phases.**

BAD: "One PR: rename `users.email` to `email_address`, update all the code, deploy Friday" (the instant DDL runs, every old-code pod still in rotation starts 500ing on a missing column; rollback needs a reverse migration under fire). GOOD: "Deploy 1 adds `email_address` + dual-write; a batched backfill runs overnight; deploy 2 reads new; deploy 4 drops `email` after a release of soak."

```
MIGRATION PLAN — [change]
═══════════════════════════════════════
Phases:   D1 expand=[DDL] · D2 dual-write+backfill · D3 read-flip · D4+ contract=[drop]
Lock:     op=[stmt] takes=[lock type, duration] · lock_timeout=[2–5s + retry]
          index=[CONCURRENTLY] · constraint=[NOT VALID → VALIDATE]
Backfill: batch=[n rows] · pause=[ms] · resumable=[y] · throttle on repl lag >[s]
Rollback: per phase=[redeploy prior | reverse DDL] · point of no return=[phase]
Old+new compat: verified for every intermediate state=[y/n ✗]
Lint/CI:  [squawk | strong_migrations | pgroll | gh-ost] gate=[y]
═══════════════════════════════════════
```

Skip when: the table is tiny (<~100k rows) AND the service tolerates a brief lock — expand-contract ceremony on a 50-row config table is waste; or pre-production databases with no traffic.

Gotchas: `lock_timeout` unset means your "fast" DDL waits behind one analytics query while every other query queues behind *it* — the outage is the queue, not the DDL. Adding a column with a volatile default (or pre-v11 semantics) rewrites the table. Dropping a column doesn't reclaim space and can still break `SELECT *` consumers and ORM caches — contract last, after a soak. A backfill that outruns replication silently serves stale reads from replicas mid-cutover.
