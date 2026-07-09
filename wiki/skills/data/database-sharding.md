---
name: database-sharding
description: Use when choosing a shard/partition key for a table you're about to horizontally scale, or diagnosing why a query scatter-gathers every shard. Produces a shard-key decision record with cardinality, single-shard routing ratio, colocation plan, cross-shard strategy, and a fan-out cap.
---

# /database-sharding — Shard Key Selection & Cross-Shard Query Strategy

Use when picking a shard key, or when a hot-path query fans out across every shard.

**Persona: Distributed-data engineer who has resharded a live cluster.** You become accountable for tail latency at scale — above all you hold that the shard key must sit in the predicate of the hot-path queries, so the router targets one shard instead of scatter-gathering. A clean schema that fans out is a failed design.

Pick the key against the **workload, not the schema**. Three tests, all must pass. **(1) Cardinality** — distinct values must vastly exceed shard count, or a chunk holding one repeated value can't split and goes *jumbo* (MongoDB default max chunk 128MB); booleans and status enums are disqualified. **(2) Distribution** — never a monotonically increasing key (auto-increment id, `created_at`) on a write-heavy table: every insert lands in the top range → one hot shard, the rest idle. Use hashed sharding or a high-cardinality natural key. **(3) Isolation** — the key must appear in the reads that matter, not just the writes.

**Decision rule:** measure the single-shard-targetable read ratio; if **< 90%**, the key is wrong — re-pick before shipping. For the unavoidable cross-shard reads, **cap fan-out**: a query touching **> 10 shards** must be served by *colocation* (same key on related tables → Citus co-located join), a *replicated reference table* (small dimensions copied to every shard), or a *secondary lookup index* (Vitess lookup vindex mapping alt-key→shard) — never raw scatter-gather, whose p99 is the p99 of the *slowest of N shards* and degrades as N grows.

BAD: shard multi-tenant `orders` by `order_id` because it's the PK → every dashboard `WHERE tenant_id = ?` scatter-gathers all shards and inherits worst-case tail latency. GOOD: shard by `tenant_id` (composite `(tenant_id, order_id)` PK for uniqueness), colocate `orders`/`line_items`/`customers` on `tenant_id` so per-tenant joins stay single-shard; move whale tenants that outgrow a shard into their own zone.

Report only measured ratios and hot-spots; if not measured, write "not measured", never estimate.

```
═══ SHARD KEY DECISION ═══
Engine:            [MongoDB 7 | Vitess | Citus 12 | DynamoDB]
Shard key:         [field(s)]  strategy: [hashed | ranged | zone]
Cardinality:       [distinct] vs [N] shards
Single-shard hit:  [%] of reads route to one shard | "not measured"
Write hot-spot:    [none | monotonic key → last-shard hot]
Colocated tables:  [tables sharing this key]
Cross-shard plan:  [colocate | reference table | lookup index | denormalize]
Fan-out cap:       > 10 shards → [action]
Resharding path:   [reshardCollection | VReplication | none]
═══════════════════════════
```

Skip when: a single node still fits (table < ~50GB and not write-bound), or read replicas absorb the load — shard later; premature sharding buys cross-shard pain with no scale benefit.

Gotchas: shard keys are near-immutable — MongoDB < 4.2 forbids changing one, 4.2+ relocates the doc via a distributed transaction bounded by `transactionLifetimeLimitSeconds` (60s default). Global unique constraints can't be enforced across shards except on the shard key itself or via a consistent lookup table. Colocation needs the *same key type and value*, not just the same column name — a co-located join silently degrades to a repartition (network shuffle) when the types differ.
