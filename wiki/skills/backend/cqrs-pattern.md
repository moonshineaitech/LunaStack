---
name: cqrs-pattern
description: Use when designing or reviewing a split between a write model (commands, invariants) and a read model (queries, projections), or debugging stale reads after such a split. Produces a per-aggregate verdict covering command/query shape, one-store vs separate-stores, eventual-consistency and read-your-writes handling, dual-write safety via outbox or event sourcing, and projection rebuildability.
---

# /cqrs-pattern — Separating Read and Write Models Correctly

Use when splitting an aggregate into a write model and a read model, or fixing stale/wrong reads after a split.

**Persona: Domain architect who owns the write model's invariants and the read model's query shape as two separate contracts.** Above any convenience, you hold one rule: the write model is the single source of truth, and every read model is a disposable, rebuildable projection of it — never a second authority.

Default to ONE model. CQRS is not a top-level architecture (Greg Young): adopt it per-aggregate, only when a real driver exists — the read query shape fights the aggregate's invariant shape, reads need a different store (search/cache/replica), or reads scale independently of writes. It is orthogonal to event sourcing: two tables or a view in the same Postgres is valid CQRS. Split the *models* (command handlers vs read DTOs) long before you split the *store*; only separate stores on a measured driver (e.g. read:write ≥ ~10:1, or a read that needs a store the write schema can't serve).

Shape both sides strictly. Commands are imperative intentions (`DeactivateAccount`, not `UpdateAccountRow`) that change state and return only an ack/id/version — never a read DTO. Queries are side-effect-free, never load an aggregate, and read a purpose-built projection returning flat DTOs (raw SQL is fine). If one handler both mutates and returns data to render, the models have merged — that is not CQRS.

The instant read and write live in separate stores, the read model lags — design for it, don't "fix" it. Make lag explicit: the command returns new version/sequence N; a redirect to the async read view must wait until the projection's applied-version ≥ N (poll/subscribe) or fall back to the writer's own record on the write store. Mechanical: if projection lag p99 exceeds the ~200ms instant-redirect budget, never redirect the user straight to the eventually-consistent view.

Writing the write store then the read store is a dual write — not atomic; a crash between them desyncs forever. Use a transactional outbox (event committed in the same DB transaction as the state change) + a relay, or event sourcing. Projections must be idempotent (dedupe by event id) and ordered (track last-applied sequence) because at-least-once delivery replays. Every read model must drop-and-rebuild from the source of truth; if it can't, it has become a second source of truth — a bug.

BAD: `POST /orders` writes the order, then the confirmation page immediately queries the read projection and renders "no orders" because the projection hasn't caught up — the split silently broke read-your-writes.
GOOD: the command returns order id + version N; the confirmation view reads the writer's own order from the write store (or waits until projection applied-version ≥ N), so the writer always sees their write while other readers stay eventually consistent.

If lag or read:write ratio is not measured, write "not measured" — never estimate a consistency you did not observe.

```
═══════════════════════════════════════
CQRS SPLIT REVIEW — [Aggregate / Context]
═══════════════════════════════════════
Driver:       [query≠invariant | read-scale | different store | NONE → one model]
Split level:  [models only, one store | separate stores (eventual)]
Event source: [no — CQRS ≠ ES | yes — audit/temporal replay]
Command:      [imperative intent? y/n] returns [ack/id/version | LEAKS read DTO ✗]
Query:        [reads projection DTO? y/n | LOADS aggregate ✗]
Consistency:  [strong (one store) | eventual — lag p99=[X]ms | not measured]
Read-your-writes: [version-token wait | read write-side | UNHANDLED ✗]
Write→read:   [outbox+relay | event-sourced | DUAL-WRITE ✗]  idempotent=[y/n] ordered=[y/n]
Rebuildable:  [drop + replay projection works? y/n]
Verdict:      [SHIP | FIX: [reasons]]
═══════════════════════════════════════
```

Skip when: plain CRUD with symmetric reads/writes and one query shape the aggregate already serves — one model is the correct design, not a compromise. Never apply CQRS system-wide.

Gotchas: CQRS ≠ two databases and ≠ event sourcing — minimal valid CQRS is separate command handlers and read DTOs over one schema; separate stores and event stores are independent later costs. Don't "fix" eventual consistency by updating the projection synchronously inside the command transaction — that recouples the stores and reintroduces the dual-write and latency you split to escape. A read model any other service or the write side treats as truth has silently become a second source of truth; if a rebuild from source would change a decision, an invariant leaked onto the read side.
