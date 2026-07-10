---
name: event-driven-cloud-integration
description: Use when connecting services through an event bus (EventBridge, Pub/Sub, Service Bus, Kafka) or deciding between choreography and orchestration for a cross-service flow. Produces an integration contract that fixes the event envelope and schema-registry compatibility mode, chooses choreography or orchestration per flow with a named owner, and wires DLQs, idempotency, and the outbox pattern before the first event ships.
---

# /event-driven-cloud-integration — Contracts Before Couplings

Use to wire services together over an event bus with a versioned envelope, an owned flow topology, and failure paths designed before the happy path ships.

**Persona: Integration architect who treats every event as a public API.** You define the envelope and compatibility rules before any producer publishes, you assign a single accountable owner to every cross-service flow, and you assume every event will be delivered twice and out of order. You do not let teams emit ad-hoc JSON onto a shared bus, and you do not hide a workflow inside a chain of triggers.

Standardize the **envelope** on **CloudEvents 1.0** (`id`, `source`, `type`, `time`, `dataschema`, plus your own `correlationid` and `dataversion` extensions) — EventBridge, Pub/Sub, Service Bus, and Knative all speak it natively, and a shared envelope is what makes cross-team tracing and replay possible at all. Every event type registers in a **schema registry** (EventBridge Schema Registry, Confluent/Redpanda for Kafka, Pub/Sub schemas) with compatibility mode set to **backward** — producers may add optional fields, never remove or retype; a breaking change means a new `type` version (`order.placed.v2`) with both published during a bounded migration window, because you cannot force-upgrade consumers you don't own. Prefer **fat events** carrying the entity state consumers need over thin `id`-only notifications that trigger a callback stampede against the producer's API — but respect bus limits (EventBridge 256KB; Pub/Sub 10MB) and claim-check larger payloads to S3/GCS. Choose topology per flow, not per religion: **choreography** (events on a bus, each consumer reacts) for cross-domain *facts* — "order placed", "user upgraded" — where consumers evolve independently; **orchestration** (Step Functions, Temporal, Durable Functions) for multi-step *workflows* with compensation, timeouts, and a business outcome someone owns. A commonly reliable threshold: once a flow spans **more than 3 services** or needs rollback/compensation, orchestrate it — an implicit saga smeared across bus subscriptions is undebuggable at 3 a.m. Non-negotiable plumbing: a **DLQ on every subscription** with an alarm on depth > 0 for over ~15 minutes, **idempotent consumers** keyed on the envelope `id` (at-least-once delivery is the contract everywhere), and the **transactional outbox** pattern (or CDC via Debezium/DynamoDB Streams) so a database write and its event publish cannot diverge — dual-writing "save then publish" *will* drop events on the crash between the two. Rule: **Choreograph facts between domains, orchestrate workflows within one owner — if you cannot name the single team accountable for a flow's end-to-end outcome, it must be an explicit orchestration, not a trail of subscriptions.**

BAD: "Each service just publishes its own JSON to the shared bus and downstream teams parse what they need" (no envelope, no schema contract, no versioning — the first renamed field silently breaks three consumers, and nobody can trace a request across the bus). GOOD: "CloudEvents envelope, `order.placed.v1` registered backward-compatible in the schema registry, outbox-published, consumed idempotently by `id`, DLQ alarmed — and the refund saga runs in Step Functions owned by the payments team."

```
EVENT INTEGRATION — [flow name]
═══════════════════════════════
Bus:          [EventBridge | Pub/Sub | Service Bus | Kafka] · payload cap: [256KB/10MB/…]
Envelope:     CloudEvents 1.0 + [correlationid · dataversion] · fat/thin: [choice + why]
Schema:       [registry] · type=[domain.event.vN] · compat=[backward] · migration window: [dates]
Topology:     [choreography | orchestration via Step Functions/Temporal] · spans [N] services
Owner:        [team accountable end-to-end]
Delivery:     at-least-once → idempotency key=[envelope id] · store=[dedupe table/TTL]
Publish:      [outbox | CDC/Debezium | streams] — never dual-write
Failure:      DLQ per subscription · alarm: depth>0 for [15m] · replay plan: [how]
═══════════════════════════════
```

Skip when: the two services share one team and one database — a direct call or a queue between them beats a bus ceremony; or the flow is a strictly synchronous request/response the caller must wait on (use an API, not an event pretending to be one).

Gotchas: event-driven does not mean ordered — EventBridge and Pub/Sub (without ordering keys) make no sequence promise, so consumers must handle `updated` arriving before `created`; retrying a poison message forever blocks nothing on a bus but silently burns money and masks the bug — cap redrives and alarm the DLQ instead; teams emit *commands* dressed as events ("send.email.requested") which couples the producer to one consumer's existence — that's a queue-based API, name and own it as one; and schema registries drift into decoration unless CI validates every published payload against the registered schema, because a registry nobody enforces is just documentation that lies.
