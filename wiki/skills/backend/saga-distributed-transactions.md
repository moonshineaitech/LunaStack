---
name: saga-distributed-transactions
description: Use when one business operation must update state across two or more services and it must either fully complete or fully unwind without a distributed lock or 2PC. Produces a saga design — ordered steps, compensations, pivot classification, and an isolation/idempotency plan.
---

# /saga-distributed-transactions — Sagas & Compensating Transactions

Use when one logical operation spans multiple services/databases and 2PC is off the table.

**Persona: Distributed Systems Engineer who owns the money path.** You accept eventual consistency but refuse data corruption: every forward step has a proven inverse or is proven to eventually succeed, and the system never rests in a partially-applied state that double-charges or drops a write.

Model the operation as an ordered list of local transactions, one per service. Classify each step: *compensatable* (undoable by a compensating tx), *pivot* (the go/no-go commit — once it succeeds the saga must run forward), or *retriable* (after the pivot, guaranteed to eventually succeed via retry). All compensatable steps come before the pivot; all retriable steps after. On failure, run compensations for completed steps in reverse (LIFO). Sagas give you ACD but NOT Isolation — plan for the anomalies explicitly.

Coordination choice, mechanical rule: if participants ≤ 4 and no service both emits and consumes saga events, choreography (event-driven) is fine; if participants > 4 OR any service both publishes and handles saga events → use an orchestrator (Temporal, AWS Step Functions, Camunda/Zeebe, Orkes Conductor, MassTransit/NServiceBus sagas) and persist its state durably (event-sourced or state-machine row). Every step and every compensation MUST be idempotent, keyed by sagaId+step, because retries are guaranteed. Publish the next command via a transactional outbox — never dual-write DB + broker in one code path. Retriable steps: exponential backoff, cap ~5 attempts, then dead-letter to a manual-intervention queue with an alert. Set per-step timeouts from measured p99, not guesses.

BAD: compensation for `reserveInventory(sku, qty)` blind-increments stock back by `qty` — not idempotent, so a retried compensation releases the units twice and you oversell.
GOOD: the forward step creates and returns a `reservationId`; compensation is `releaseReservation(reservationId)` — a no-op if already released (idempotent) and it adjusts by that reservation's own delta, so retries and concurrent sagas can't double-release or clobber each other's absolute values.

If you cite a step's p99 to size its timeout, it must be measured — if not measured, write "not measured" and use a conservative default, never invent a latency number.

```
═══ SAGA: [name] ═══
Coordination: [orchestration|choreography]   Engine: [Temporal|Step Functions|...]
#  Service         Forward(→out)          Compensation             Class
1  [order-svc]     createOrder            markCancelled            compensatable
2  [inventory]     reserve(→resId)        releaseReservation(resId) compensatable
3  [payment]       charge(idemKey)        —                        PIVOT
4  [shipping]      scheduleShipment       —                        retriable
Isolation risk: [dirty read on order status] → countermeasure: [semantic lock / *_PENDING]
Outbox: [yes]  Idempotency key: [sagaId+step]  Timeout/step: [p99×3]  Retry cap: [5→DLQ]
```

Skip when: the whole operation fits one database's ACID transaction, or it's read-only cross-service, or 2PC/XA is available and acceptable (single trust domain, low scale) — a saga is real operational complexity you shouldn't add without cross-service writes that must not partially apply.

Gotchas: a timed-out call may have already succeeded — never blind-compensate; make forwards idempotent and confirm state first, or you double-refund. A compensation that can permanently fail strands the saga mid-flight — route it to a DLQ with alerting, never swallow the error. Lost Isolation is silent — other transactions read your PENDING rows and cause lost updates/dirty reads; guard hot rows with semantic locks or `*_PENDING` statuses.
