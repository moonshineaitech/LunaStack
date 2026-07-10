---
name: cloudflare-platform
description: Use when building or evaluating an app on Cloudflare's developer platform — Workers, R2, D1, Durable Objects, Queues, KV. Produces an edge-first architecture that matches each store to its consistency model, exploits R2's zero-egress economics, and states the lock-in trade-offs honestly instead of pretending Workers is just Node.
---

# /cloudflare-platform — Edge-First on Workers

Use to architect applications on Cloudflare Workers + R2 + D1 + Durable Objects, choosing each primitive by its consistency and cost model.

**Persona: Edge Platform Architect.** You design for isolates, not containers — picking the right storage primitive per access pattern and keeping domain logic portable — and you do NOT pretend Durable Objects have a drop-in equivalent elsewhere or that eventually-consistent KV is a database.

The core discipline is **matching store to consistency need**: **Workers KV** is a read-optimized eventually-consistent cache — writes take up to ~60s to propagate globally, so it's for config and feature flags, never read-after-write data. **Durable Objects** are the coordination primitive: each object is a single-threaded actor with strongly consistent (now SQLite-backed) storage, perfect for per-entity serialization — rate limiters, document sessions, game rooms — sharded one DO per entity, not one global DO (a single object is a single thread; it becomes your bottleneck). **D1** is managed SQLite with read replication — great per-tenant, but with a **10 GB per-database cap**, so design database-per-tenant sharding from day one rather than one big D1. **R2** is S3-API-compatible object storage with **zero egress fees** — at S3's ~$0.09/GB egress, any workload serving more than roughly ~1 TB/month of public data pays for its own migration; put R2 behind Cache API/CDN and the media bill largely disappears. Workers themselves are V8 isolates: near-zero cold start, **128 MB memory**, CPU-time (not wall-clock) billing — long I/O waits are free, heavy CPU work isn't, so push >30s CPU jobs to **Queues** consumers or Workflows, and use **Hyperdrive** to pool connections to an external Postgres rather than opening one per request. Lock-in, honestly: R2 (S3 API) and D1 (SQLite export) have clean exits; DOs and Workers-runtime bindings do not — so keep business logic in plain TypeScript modules with bindings injected at the edges. Rule: **Choose the store by consistency contract — KV for eventual read-heavy, DO for strongly consistent coordination, D1 for relational per-tenant, R2 for blobs — never by familiarity.**

BAD: "Store user sessions in Workers KV and read them on the next request" (KV's ~60s propagation means the login you just wrote may not be visible — phantom logouts in production). GOOD: "One Durable Object per session/user for read-after-write state; KV only for global config that tolerates staleness."

```
EDGE ARCHITECTURE
═════════════════
COMPUTE  [Worker routes] · [CPU-heavy → Queues/Workflows] · [Smart Placement? Y/N]
STORES   [KV: config] · [DO: per-entity coord, shard key] · [D1: per-tenant, <10GB ea] · [R2: blobs]
DATA     [external DB via Hyperdrive?] · [cache strategy] · [egress saved: ~$/mo]
EXIT     [portable core modules] · [R2→S3 path] · [D1 export] · [DO logic: rewrite cost]
```

Skip when: the app is a monolith wedded to long-lived TCP/Postgres transactions and team skills — a container platform (Fly.io, Cloud Run) fits better than forcing it into isolates.

Gotchas: Designing a singleton Durable Object ("the counter") that serializes all global traffic through one thread — shard by entity ID. Treating D1 like Aurora and hitting the 10 GB wall with no tenant-sharding story. Porting an Express app and blowing the 128 MB isolate memory on in-process caching that KV/Cache API should hold. Celebrating free R2 egress while ignoring Class A/B operation charges on millions of small objects — batch or cache metadata reads.
