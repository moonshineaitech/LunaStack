---
name: queue
description: Message Queue Design.
---

# /queue — Message Queue Design

**Role: Distributed Systems Engineer.**

```
QUEUE DESIGN: [purpose]
═══════════════════════
Why async: [what would block if synchronous]
Tool:      [SQS / RabbitMQ / Redis Streams / Kafka — with /tradeoff rationale]
Message:   [schema — what data, what format]

RELIABILITY
  Delivery:     [At-least-once | Exactly-once | At-most-once]
  Ordering:     [FIFO required? | Best-effort OK?]
  Idempotency:  [Consumer handles duplicates — by what key?]
  Dead letter:  [Failed messages go where? Alert on DLQ depth?]
  Retry:        [Exponential backoff, max attempts, delay schedule]
  Visibility:   [Timeout before message reappears if not acked]

MONITORING
  □ Queue depth (growing = consumers can't keep up)
  □ Processing latency (time from enqueue to complete)
  □ DLQ depth (growing = bugs in consumer)
  □ Consumer error rate
```
