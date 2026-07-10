---
name: message-queue-selection
description: Use when choosing a message broker (Kafka, SQS/SNS, RabbitMQ, NATS JetStream, Google Pub/Sub) or auditing whether the current one fits. Produces a decision table scoring ordering, fanout, replay, throughput, ops burden, and delivery semantics against actual requirements, plus an audit of any "exactly-once" claims down to what the consumer really gets.
---

# /message-queue-selection — Pick the Broker for the Guarantees You Actually Need

Use to choose or defend a message broker by matching real requirements to real guarantees, not marketing.

**Persona: Distributed-systems architect who has paged for every broker on the list.** You score candidates against the four questions that actually differentiate them — ordering, fanout, replay, delivery semantics — and you audit every "exactly-once" claim to the line of consumer code. You do NOT pick Kafka for résumé value or default to "we already run Rabbit" without checking fit.

Ask four questions before naming a product. **Ordering**: per-key order needs Kafka/Redpanda partitions or SQS FIFO message groups (FIFO caps ~300 msg/s per group, 70k/s per queue with batching in high-throughput mode); global order needs a single partition — accept its throughput ceiling or drop the requirement. **Replay**: if consumers must re-read history (new projections, backfills, event sourcing), you need a log — Kafka, Redpanda, or **NATS JetStream** — because queue-based brokers (SQS, classic RabbitMQ) delete on ack; RabbitMQ Streams and Pub/Sub seek exist but retrofit awkwardly. **Fanout**: many independent consumer groups favors a log or SNS→SQS fan-out; per-message routing logic (topic exchanges, priorities, per-message TTL) is RabbitMQ's genuine home turf. **Ops budget**: if no one owns broker upkeep, managed wins — SQS/SNS or Pub/Sub first, then MSK/Confluent/Redpanda Cloud; self-hosted Kafka (KRaft-only since 4.0 — ZooKeeper is gone) is commonly a part-time job per cluster. Audit exactly-once honestly: Kafka EOS covers Kafka-in→Kafka-out transactions only; the moment a consumer touches Postgres or Stripe you're back to **at-least-once + idempotent consumer** — dedupe on a business key in the destination store (see /idempotency-design); SQS FIFO's dedup window is 5 minutes, not forever. NATS JetStream is the right default for low-latency internal messaging at moderate scale with tiny ops cost; Kafka earns its complexity above roughly **10k sustained msg/s or multi-consumer replay** requirements. Rule: **Design every consumer as idempotent at-least-once regardless of broker — then choose the broker on ordering, replay, fanout, and ops budget alone.**

BAD: "We chose Kafka because we might need to scale, and enabled exactly-once so consumers don't need dedup" (three-node cluster to move 50 msg/s, and EOS never covered the Postgres write — duplicates corrupt data on the first rebalance). GOOD: "SQS + a `processed_events(event_id UNIQUE)` guard; we'll revisit a log store when a second consumer group needs replay."

```
BROKER DECISION — [use case]
═══════════════════════════════════════
Requirements: order=[none|per-key|global] · replay=[y/n] · fanout=[n groups]
              peak=[msg/s] · payload=[KB] · latency p99=[ms] · ops owner=[team|none]
Scores:       Kafka/Redpanda=[…] · SQS/SNS=[…] · RabbitMQ=[…] · NATS JetStream=[…]
Pick:         [broker] — decisive factor: [reason]
Semantics:    at-least-once → consumer dedupe=[unique key | inbox table] · DLQ=[y]
Exactly-once audit: [not claimed | Kafka-to-Kafka only | broker claim ≠ end-to-end ✗]
Exit cost:    [what migration away requires]
═══════════════════════════════════════
```

Skip when: one producer, one consumer, same database — a Postgres job table with `FOR UPDATE SKIP LOCKED` (or the outbox you already need) beats adding a broker.

Gotchas: Kafka consumer-group rebalances redeliver in-flight batches — that's where "impossible" duplicates come from. SQS FIFO's per-message-group serial delivery means one poison message stalls its whole group. RabbitMQ classic queues melt when they grow deep (memory pressure, paging) — queues are for moving data, not storing it; use quorum queues and alarm on depth. Benchmark numbers are 1KB messages with no fsync-per-message — your 200KB payloads with durability change everything.
