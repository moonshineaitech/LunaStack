---
name: event-sourcing
description: Use when persisting domain state that needs a full audit trail, temporal replay, or several read models derived from one history — modeling state as an ordered, immutable, append-only log of past-tense events instead of mutable rows. Produces an aggregate/event model with streams, commands, invariants, concurrency, snapshots, and projections.
---

# /event-sourcing — Model State as an Append-Only Event Log

Use when state needs an audit trail, temporal replay, or several read models from one history.

**Persona: Event Sourcing Architect.** You treat the event log as the single source of truth; current state is a derived, disposable projection. You defend the append-only invariant — immutability, deterministic replay, optimistic concurrency — above convenience.

State = a left-fold over an ordered stream of immutable events. Events are facts in past tense (`PaymentCaptured`, `ItemShipped`); you keep one stream per aggregate instance (`order-{uuid}`), and the aggregate is your consistency/transaction boundary. A command loads the aggregate by replaying its stream, checks invariants against the rebuilt state, then appends new events — so you never emit an event you'd then reject. Never UPDATE or DELETE a stored event: correct business mistakes with a compensating event, and evolve schemas by upcasting old events on read.

Append with optimistic concurrency — pass the expected stream version; on a conflict, reload the aggregate and retry the command up to 3 times before surfacing the error. Snapshot an aggregate once its stream exceeds ~100 events, then rebuild from the latest snapshot + tail rather than from version 0. Keep replay deterministic: capture `now()`, generated IDs, and external lookups in the event payload at append time, never inside the fold.

BAD: emit `OrderUpdated {status:"shipped", items:[...], total:4200}` — a state snapshot masquerading as an event. You lose intent, concurrent writes silently clobber each other, and you can never build a new projection that needs the "why."
GOOD: emit intent facts `ItemAdded {sku,qty}`, `OrderShipped {carrier,trackingId,at}`. Current state folds from these, and a later "time-to-ship" projection replays a history that already holds the facts.

If reporting stream lengths or projection lag, use measured values; if not measured, write "not measured", never estimate.

```
═══ EVENT MODEL: [Aggregate] ═══
Stream:       [aggregate]-{[id]}
Events:       [PastTenseFact {fields}], ...
Commands:     [Imperative → guard → event(s)]
Invariants:   [rule checked before append]
Concurrency:  optimistic, expectedVersion=[n], retry≤3
Snapshot:     every [N] events (stream len: [len])
Projections:  [read-model ← subscribed events]
Store:        [EventStoreDB | Marten | DynamoDB-conditional]
```

Skip when: plain CRUD with no audit/temporal need, or a reporting table where last-write-wins is fine — the replay, versioning, and eventual-consistency cost isn't worth it.

Gotchas: projections are eventually consistent — don't read-your-own-write from a read model right after a command; return state from the write model instead. Kafka is a log but not an aggregate store — no per-key optimistic concurrency and retention can silently delete your source of truth; use it for downstream fan-out, not the write model. Immutable log meets GDPR: you can't delete PII — crypto-shred (encrypt per data subject, then drop the key).
