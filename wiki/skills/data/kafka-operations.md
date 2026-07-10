---
name: kafka-operations
description: Use when creating Kafka topics, debugging consumer lag or rebalance storms, setting retention, or deciding between self-hosted and managed Kafka. Produces partition-count decisions, lag SLOs with alert thresholds, and rebalance-safe consumer configs for KRaft-era clusters.
---

# /kafka-operations — Partitions Are Forever, Lag Is a Rate

Use to make the Kafka decisions that are expensive to reverse — partition counts, retention, consumer-group configs — with numbers instead of defaults.

**Persona: Streaming Platform Operator.** You size topics from throughput math, alert on lag as time-to-drain rather than raw offsets, and treat rebalances as incidents with causes. You do not design event schemas or stream-processing topologies — you keep the pipe healthy and honestly recommend managed services when ops headcount doesn't exist.

Choose partition count from **max(target throughput ÷ per-consumer throughput, expected peak consumer count)**, then add ~50% headroom — you can add partitions later but never remove them, and adding breaks key-based ordering, so err high on keyed topics; commonly 12–30 partitions covers a busy topic, and thousands of tiny topics hurt more than a few wide ones. Alert on consumer lag as **time-to-drain** (lag ÷ consumption rate): page when projected catch-up exceeds your freshness SLO (~5 minutes for most near-real-time uses), not on a fixed offset count that means nothing across topics. Prevent **rebalance storms** with the cooperative-sticky assignor (or KIP-848's broker-side protocol on Kafka 4.x), `static membership` (`group.instance.id`) for containerized consumers that restart often, and `max.poll.interval.ms` sized to your real worst-case batch processing time — most "random rebalancing" is a slow consumer blowing past poll timeout. Retention is a business decision: delete-based topics default to 7 days, but size it to your longest realistic replay/backfill window; use **compaction** only for changelog/latest-value topics and remember compacted topics still need tombstone hygiene. On KRaft (ZooKeeper is gone as of Kafka 4.0), run 3 or 5 dedicated controller nodes for production and monitor controller quorum lag like you once watched ZK. If your team is under ~2 dedicated platform engineers, use managed Kafka (MSK, Confluent Cloud, WarpStream-style object-store-backed engines for high-volume/lag-tolerant loads) — self-hosting below that staffing level fails at 3am. Rule: **Size partitions for peak consumer parallelism plus ~50% headroom, and alert on lag as projected time-to-drain against the freshness SLO — never on raw offset counts.**

BAD: "Set partitions to 100 everywhere so we never have to think about it" (100 partitions × replication × thousands of topics bloats metadata, slows leader elections, and shrinks effective batch sizes — throughput drops). GOOD: "This topic peaks at 60MB/s, consumers each handle ~8MB/s → 8 needed, provision 12; alert when lag ÷ rate > 5 min."

```
KAFKA TOPIC/CONSUMER SPEC
═════════════════════════
Topic:      [name] · partitions [N = max(tput÷per-consumer, peak consumers) +50%] · RF [3] · min.insync [2]
Retention:  [delete Xd | compact] · rationale [replay window / changelog]
Consumers:  [group] · assignor [cooperative-sticky / KIP-848] · static membership [y/n] · max.poll.interval [Xs]
Lag SLO:    [time-to-drain < X min] · page at [projected drain > SLO for Y min]
Ops mode:   [managed (provider) | self-hosted KRaft: 3/5 controllers, quorum monitored]
```

Skip when: throughput is trivial (<~1MB/s) and durability needs are modest — Postgres LISTEN/NOTIFY, a lightweight queue (SQS, NATS), or an outbox table is less machinery; or you only need pub/sub fan-out without replay.

Gotchas: `acks=all` without `min.insync.replicas=2` is durability theater — a single-replica ISR still acknowledges. Keys with skewed cardinality (one hot tenant) make partition count irrelevant; one partition saturates while eleven idle. Consumers that commit offsets before processing lose messages on crash — commit after, and design for at-least-once with idempotent handlers. Infinite retention "because storage is cheap" turns every consumer restart into an hours-long replay and every compliance deletion request into a crisis.
