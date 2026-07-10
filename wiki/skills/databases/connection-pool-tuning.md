---
name: connection-pool-tuning
description: Use when the database hits "too many connections", latency climbs under load despite low DB CPU, or a serverless/autoscaling app talks to Postgres/MySQL. Produces a pool sizing sheet: per-tier pool math from cores not clients, PgBouncer/proxy mode choice, a timeout ladder, and serverless connection-storm defenses.
---

# /connection-pool-tuning — Size for Cores, Not Clients

Use to size and layer connection pools so the database runs at its throughput peak instead of drowning in idle backends.

**Persona: Connection Topology Engineer.** Draws the full path — app pools × instances → pooler → database — and does the multiplication before changing any number. Does NOT fix slow queries (a slow query shrinks effective pool capacity; that's a different protocol) and does not raise `max_connections` as a first move.

The counterintuitive truth: throughput peaks at a **small** pool. A database does useful work on roughly `(cores × 2) + effective spindles` connections (the classic HikariCP formula — call it ~2–3× vCPUs on SSD/NVMe); beyond that, added connections only add context-switching and lock contention, so a 16-vCPU Postgres wants ~30–50 active connections total, not 500. That total is a budget divided across tiers: `app_instances × pool_size` must fit it, which is impossible at scale without a middle layer — **PgBouncer** (or RDS Proxy, Supabase Supavisor, ProxySQL for MySQL) in **transaction mode**, which multiplexes thousands of client connections onto that small server pool. Transaction mode forbids session state (named prepared statements need PgBouncer ≥1.21's protocol-level support, advisory locks and `SET` don't pool) — audit for these before flipping the mode. Serverless (Lambda, Cloud Run, Vercel) turns every cold start into a connection storm, so functions get pool size 1 plus a mandatory proxy, or an HTTP-native driver (Neon serverless, PlanetScale). Then build the **timeout ladder** so waits fail in the right order: client statement timeout < app pool checkout timeout (~3–5s — fail fast and shed load) < proxy `query_wait_timeout` < DB `idle_in_transaction_session_timeout`, with `max_lifetime` (~30min, jittered) below any infra idle-kill. Rule: **Total server-side connections ≤ ~3× database vCPUs; every client beyond that multiplexes through a transaction-mode pooler.**

BAD: "Load test failed with pool exhaustion, so we raised the app pool from 20 to 200" (the DB now context-switches 200 backends; p99 gets worse and the next failure is OOM). GOOD: "Keep server pool at ~40 for 16 vCPUs, put PgBouncer in transaction mode in front, and fix the 2s query that was hogging checkouts."

```
CONNECTION POOL SHEET
═════════════════════
DB: [engine] · vCPUs [n] · budget = ~3×vCPU = [n conns]
APP TIER: instances [n] × pool [n] = [total] · fits budget? [y/n]
POOLER: [pgbouncer/RDS Proxy/…] · mode [transaction] · default_pool_size [n]
  session-state audit: [prepared stmts/SET/advisory locks — findings]
SERVERLESS: max concurrency [n] · driver [pooled/http] · pool size [1]
TIMEOUT LADDER: stmt [s] < checkout [s] < queue [s] < idle-in-txn [s] · max_lifetime [min]
VERIFY: p99 [before→after] · active vs idle conns [before→after]
```

Skip when: a single app instance with a pool of ≤10 talks to an unshared database — defaults are fine; or you're on a platform whose driver already multiplexes over HTTP.

Gotchas: sizing pools by expected concurrent users instead of DB cores is the root error behind most "we need a bigger instance" tickets; transaction-mode pooling silently breaks session-scoped features and the failures look like application bugs; forgetting connection `max_lifetime` means a NAT gateway or LB idle-kills sockets and you see mysterious "connection reset" spikes; and per-pod pools in Kubernetes multiply on every autoscale event — the pooler must sit between the cluster and the DB, not inside each pod.
