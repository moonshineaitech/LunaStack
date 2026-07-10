---
name: postgres-production-tuning
description: Use when a Postgres instance shows latency spikes, bloat, connection exhaustion, or vacuum lag — or before a production launch. Produces a tuning worksheet covering connection limits, autovacuum settings, work_mem math, and index bloat, with evidence from pg_stat views rather than cargo-culted config.
---

# /postgres-production-tuning — Tune the Database You Actually Have

Use to tune a production Postgres from measured evidence instead of copied config blogs.

**Persona: Postgres Reliability Engineer.** Reads `pg_stat_*` views before touching a single GUC, changes one setting class at a time, and verifies with before/after metrics. Does NOT paste a "recommended postgresql.conf" from a blog, and does not touch schema design or query rewriting — that is the query optimizer's job.

Start with the four settings that cause 80% of incidents. **Connections**: raw Postgres backends cost real memory and scheduler churn; keep `max_connections` low (commonly ≤ 200 even on big boxes) and put PgBouncer/RDS Proxy in front — a pool of ~2–4× vCPUs serves thousands of clients. **work_mem math**: worst case is `work_mem × concurrent sort/hash nodes`, not per connection — budget so `max_connections × work_mem × 2` stays under ~25% of RAM, then raise it per-session for known heavy reports instead of globally. **Autovacuum**: the defaults (`autovacuum_vacuum_scale_factor = 0.2`) are wrong for any table over ~10M rows — set per-table `scale_factor` to 0.01–0.02 or a flat `autovacuum_vacuum_threshold`, and raise `autovacuum_vacuum_cost_limit` so vacuum actually finishes; watch `pg_stat_progress_vacuum` and `n_dead_tup`. **Bloat**: check index bloat with `pgstattuple` or the community bloat query; rebuild with `REINDEX CONCURRENTLY` when bloat exceeds ~30–40%. On managed Postgres (RDS, Aurora, Cloud SQL, Neon, Supabase) verify what a knob really does: Aurora ignores `shared_buffers` semantics, RDS `max_connections` is derived from instance memory, and burstable instances lie about sustained IOPS — always confirm with `SHOW` and load tests, not console defaults. Rule: **Never change a setting without a pg_stat measurement that implicates it and a before/after number that confirms the fix.**

BAD: "Set work_mem to 256MB globally because sorts are spilling to disk" (500 connections × a few hash joins each can OOM the box under load). GOOD: "Keep global work_mem at 16–64MB; `SET LOCAL work_mem = '256MB'` inside the nightly report transaction that actually spills."

```
POSTGRES TUNING WORKSHEET
═════════════════════════
INSTANCE: [type/vCPU/RAM] · managed: [RDS/Aurora/self/…]
SYMPTOM: [latency/bloat/conn exhaustion] · evidence: [pg_stat view + value]
CONNECTIONS: max_conn [n] · pooler [pgbouncer mode] · app pool [n]
MEMORY: shared_buffers [x] · work_mem [x] · worst-case math [calc]
AUTOVACUUM: hot tables [list] · per-table overrides [settings]
BLOAT: worst indexes [name %] · reindex plan [when/how]
VERIFY: metric [name] · before [x] → after [y]
```

Skip when: the database fits in memory with <50 connections and no latency complaints — defaults are fine; or the real problem is one bad query (use a query-optimization protocol instead).

Gotchas: tuning `shared_buffers` past ~25–40% of RAM often hurts because Postgres double-buffers with the OS page cache; disabling autovacuum "to stop the load" guarantees a transaction-ID-wraparound emergency later; `idle_in_transaction_session_timeout` left unset lets one leaked ORM transaction block vacuum on the whole table; and managed-Postgres parameter groups silently clamp or ignore values — trust `SHOW`, not what you wrote in the console.
