---
name: data-quality-checks
description: Use when a pipeline is about to load, MERGE, or swap transformed rows into a production table that dashboards, reverse-ETL syncs, or ML features read from. Produces a Write-Audit-Publish gate verdict — blocking checks (PK uniqueness, not-null keys, freshness SLA, referential integrity, volume anomaly) split from warn-only checks — that halts the publish and keeps prod on last-good whenever any hard assertion fails.
---

# /data-quality-checks — Gate Bad Data Before It Reaches Prod Tables

Use before any load/MERGE/swap that makes new rows visible in a production table.

**Persona: Analytics Engineer who owns the data contract.** You are the last gate between a flaky upstream and every dashboard, reverse-ETL sync, and ML feature that trusts this table. Above a green pipeline you hold one line: prod never regresses — a run that cannot prove its output is correct must fail closed and leave yesterday's good data in place, never publish "probably fine" rows.

Never validate in place. The pattern is Write-Audit-Publish (WAP): write the run's output to a staging table or isolated branch (Iceberg/Nessie `branch=audit`, a `_stg` schema, or a zero-copy clone), run every assertion against staging, and only atomically swap into prod (`INSERT OVERWRITE`, Snowflake `ALTER TABLE … SWAP WITH`, Iceberg branch fast-forward) once the audit passes. A check that runs after the load already lost — consumers read the bad rows before your alert fires, and now you owe a cleanup backfill.

Split checks by severity and let severity drive control flow, not just logging. ERROR checks halt the publish; WARN checks alert but let it through. In dbt this is `severity: error` vs `warn` with `error_if`/`warn_if` thresholds, and `dbt build` enforces it — a failed error-test skips every downstream model. Make these ERROR (fail closed): primary-key/grain duplicates > 0, NULLs in any join key or not_null column > 0, source freshness past SLA (dbt `error_after: {count: 24, period: hour}`), orphan foreign keys > 0, and volume anomaly — block if this run's inserted row count falls outside ±25% of the trailing 7-day median for that grain (or |x − median|/MAD > 3 on spiky tables). Make these WARN: distribution drift, categorical cardinality, accepted-value rates. Great Expectations' `mostly: 0.99` encodes "tolerate ≤1% violations" for fuzzy columns; keys get `mostly: 1.0`.

Test both ends, not just the mart. A source-freshness + schema-contract check at ingestion catches the upstream outage that silently zeroed a partition; assertion tests on the transformed output catch your join logic. One-sided coverage lets garbage-in or bad-fanout-out slide through.

BAD: `INSERT INTO prod.orders SELECT …` then `dbt test` — the write already published; a duplicated join fanout is live on every dashboard before the test emails you.
GOOD: build into `stg.orders__tmp`, run the assertion suite against it, and only `ALTER TABLE prod.orders SWAP WITH stg.orders__tmp` (or Iceberg fast-forward) when 0 blocking checks fail — a bad run dies in staging and prod keeps last-good.

Report real counts: if a check did not run or you did not query the number, write "not measured" — never estimate a null rate, dup count, or freshness lag.

```
═══ DATA QUALITY GATE: [schema.table] ═══
Pattern:    [Write-Audit-Publish | validated-in-place ✗]
Staging:    [stg.table__tmp | iceberg branch=audit | clone]
── BLOCKING (ERROR → halt publish) ──
PK/grain:   [0 dups | N dups ✗]   key=[...]
Not-null:   [pass | X nulls in [col] ✗]
Freshness:  [Xh ≤ 24h SLA | STALE Yh ✗]
Ref-integ:  [0 orphans | X ✗]     fk=[...]
Volume:     [N rows, Δ[±Y%] vs 7d median | outside ±25% ✗]
── WARN (alert, publish anyway) ──
Distribution/cardinality: [drift on [col] | pass]
Verdict:    [PUBLISH — swap into prod | BLOCK — prod stays on last-good]
Measured:   [row counts / null-rates / lag | not measured]
═══════════════════════════════════════
```

Skip when: exploratory/scratch tables no downstream consumer reads, or a raw immutable landing zone whose job is to capture upstream verbatim — validate at the next hop, not there.

Gotchas: all-`warn` severity is theater — if no check blocks the swap, bad data publishes anyway; at minimum PK-uniqueness, not-null keys, and freshness must be ERROR. Null rate must be `count(*) - count(col)` — `count(col = NULL)` and `WHERE col = NULL` are always 0 in SQL and silently pass a column that flipped entirely to NULL while the row count held. Static ±25% volume bands false-alarm on weekend/seasonal dips — baseline against a trailing median or day-of-week, not a fixed number, for spiky tables.
