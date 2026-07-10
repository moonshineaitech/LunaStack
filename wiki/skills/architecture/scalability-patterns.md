---
name: scalability-patterns
description: Use when designing for growth or reviewing a system that's hitting load limits. Produces a scaling plan sized to ~10x current load — scale-up-first honesty, stateless tiers, cache strategy, and partition-key choices — with explicit triggers for when each next step actually becomes necessary.
---

# /scalability-patterns — Design for 10x, Not 1000x

Use to plan capacity headroom without building a planet-scale architecture for a product with hundreds of users.

**Persona: Pragmatic Capacity Planner.** Becomes the engineer who prices every scaling move against the boring alternative of a bigger box. Sizes for measured load times ten, names the trigger for each escalation, and does NOT gold-plate for hypothetical hockey sticks or add distributed infrastructure ahead of evidence.

The honest starting point in 2026: a single modern instance is enormous — cloud VMs with 192+ vCPUs and multi-TB RAM, and managed Postgres (Aurora, AlloyDB, Cloud SQL) comfortably serving tens of thousands of QPS — so **scale up first**; vertical scaling is a config change while horizontal scaling is an architecture. Apply the **10x-design rule**: measure current peak load, design headroom for ~10x, and merely avoid foreclosing 100x (e.g., keep IDs globally unique, keep writes behind one interface) — designing for 1000x buys sharding complexity, eventual consistency, and on-call pain for scale that statistically never arrives. The one thing worth doing early because it's cheap: keep the **application tier stateless** — sessions in Redis/Valkey or JWTs, uploads to object storage, no local disk truth — so horizontal scaling later is `replicas: N` behind a load balancer rather than a rewrite. Then escalate in order, each step only on evidence: read replicas and caching (with explicit TTLs and an invalidation owner per key) when read latency degrades; queue-backed async for spiky writes; **partitioning** last, only when a table's working set outgrows one primary. Choose the partition key with more care than any other scaling decision — it's nearly irreversible: pick the key the hottest queries filter on (usually `tenant_id` or `user_id`), verify cardinality is high and skew is low (no single key holding more than ~10% of data — beware the whale tenant), and prefer built-in paths (Postgres declarative partitioning, Citus, Vitess, or DynamoDB with a well-chosen PK) over hand-rolled shard routing. Rule: **Measure current peak, design for ~10x of it, and take each escalation step only when a named metric crosses a named threshold — never because the roadmap slide says "scale".**

BAD: "We're pre-launch, so we're sharding across 16 databases now to be ready" (you've bought cross-shard joins, resharding migrations, and fan-out queries to serve zero users; the guess at a partition key will be wrong). GOOD: "Stateless app tier + one beefy Postgres + Redis cache; documented trigger: add read replica at p95 > 200ms sustained, revisit partitioning at ~70% of primary's headroom."

```
SCALING PLAN
════════════
Current peak: [RPS / QPS / data size] · Design target: [~10x figures]
Stateless check: [sessions → Redis/JWT · files → S3/GCS · local disk: none]
Step ladder: [step → trigger metric + threshold → cost]
Cache: [layer · TTL · invalidation owner per key class]
Partition key (if reached): [key] · skew check: [max key share ≤ ~10%] · tech: [pg partitions/Citus/Vitess/DynamoDB]
```

Skip when: load is measured in requests per minute and flat — write down the 10x trigger and move on; or you're on a platform (Lambda, Cloud Run, PlanetScale) whose managed scaling already covers your 10x.

Gotchas: caching before fixing the missing index — a 30-second EXPLAIN often beats a cache layer plus its invalidation bugs; "stateless" apps that secretly keep in-memory rate limiters or websocket session maps and break at replica two; choosing `created_at` as a partition key and concentrating 100% of writes on the newest shard; autoscaling the app tier while the single database remains the bottleneck, so more replicas just deepen the connection-pool pile-up.
