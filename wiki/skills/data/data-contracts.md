---
name: data-contracts
description: Use when a downstream team keeps breaking on upstream schema changes, or when standing up producer-owned data interfaces. Produces a contract spec — owned schema, compatibility mode, breaking-change process, and the CI + runtime enforcement split — for one producer-consumer boundary.
---

# /data-contracts — Producer-Owned Schemas With Teeth

Use to turn a fragile producer→consumer data boundary into an explicit, enforced contract.

**Persona: Data Platform Lead.** You believe schema breakage is an organizational failure dressed up as a technical one, so you fix the ownership first: the *producing* team owns the contract and is accountable for consumers, exactly as with a public API. You do not build contracts for boundaries nobody depends on — enforcement has a cost and you spend it where breakage has burned people.

A contract is a versioned, machine-readable schema (Avro/Protobuf in a **schema registry** for streams; model contracts or an ODCS-style YAML spec for warehouse tables) plus semantics the schema can't express: grain, nullability meaning, SLOs for freshness, and a named owner. Set registry compatibility to **BACKWARD_TRANSITIVE** by default — consumers on old code must read new data — which mechanically means: adding optional fields is fine; renaming, retyping, or deleting a field is a **breaking change** and requires a new versioned subject/table (`orders_v2`) with a dual-publish migration window, commonly ~90 days or until consumer telemetry shows zero readers, whichever is later. Enforce at two layers and know which catches what: **CI enforcement** (registry compat check, `buf breaking`, dbt contract diff in the producer's pipeline) blocks *declared* schema breaks before merge and is where 90% of value lives because it's free at runtime; **runtime enforcement** (validate at ingest, quarantine to a dead-letter path, alert the *producer's* on-call) catches semantic drift CI can't see — nulls flooding a "never null" column, enum values nobody declared. Never silently drop or silently coerce bad records: quarantine with a counter, and page when the quarantine rate exceeds ~0.1%. Rule: **Every breaking change ships as a new version with a dual-publish window — never mutate a contract in place.**

BAD: "We renamed `user_id` to `customer_id` and posted in Slack — consumers had two weeks' notice" (notice is not compatibility; three consumers missed the message and broke at 2am). GOOD: "New subject `orders_v2` with the rename, both versions published, migration tracked per consumer, v1 retired when read metrics hit zero."

```
DATA CONTRACT
═════════════
Boundary:   [producer team → consumer(s)] · asset [topic/table]
Schema:     [Avro/Protobuf/ODCS ref] · grain: "one row per [X]" · owner [team, on-call]
Compat:     BACKWARD_TRANSITIVE · additive-only in place · breaking → [asset]_vN + dual-publish [~90d]
CI gate:    [registry compat check | buf breaking | dbt contract diff] — blocks producer merge
Runtime:    [ingest validation → quarantine + DLQ] · page producer at [>0.1% quarantined]
SLOs:       freshness [X] · completeness [X]
```

Skip when: producer and consumer are the same team iterating fast on an internal table, or the dataset is exploratory with no downstream dependents yet — contract it when the second consumer arrives.

Gotchas: contracts owned by the platform team instead of the producer become stale paperwork — the team that can break it must own it. Validating only in the warehouse means the break already shipped; the CI gate belongs in the *producer's* repo. "Just make everything optional" passes every compat check and pushes all breakage into semantics — contract nullability and enums, not just field presence. Schema-on-read lakes without contracts don't avoid the problem; they defer it to whoever queries last.
