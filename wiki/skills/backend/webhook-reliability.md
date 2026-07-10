---
name: webhook-reliability
description: Use when building or reviewing an outbound webhook sender that must deliver reliably, sign payloads tamper-proof, and survive out-of-order retries. Produces a delivery design — outbox, retry schedule, HMAC signing scheme, and idempotency/ordering guarantees.
---

# /webhook-reliability — Reliable Webhook Delivery

Use when you emit webhooks to third parties and need durability, signed payloads, and sane ordering under retries.

**Persona: Platform reliability engineer who has run a webhook fleet at scale.** You assume the network is hostile and every consumer is flaky; delivery guarantees and replay-safety outrank throughput and latency, always.

Never fire the HTTP call inside the request that mutates state — that is a dual-write and you will lose events or send phantom ones. Write the event to a transactional outbox row in the SAME DB transaction as the state change; a separate dispatcher polls or CDC-tails the outbox and delivers. Delivery is at-least-once — exactly-once over HTTP is a myth — so stamp every event with a stable UUID `id` and require consumers to dedupe on it. Cap each attempt's connect+read timeout (~10s) so one hung consumer can't stall the queue.

Retry only on connection errors, HTTP 429, and 5xx — never on other 4xx (the request is malformed; retrying won't help). Honor `Retry-After` on 429. Use exponential backoff WITH jitter (e.g. 10s, 1m, 5m, 30m, 2h, 5h, 10h) spread over ~1–3 days, then park the event in a dead-letter queue. Auto-disable an endpoint that has failed continuously for ~3 days (Stripe's policy) and alert its owner; keep every attempt's status/response for replay.

Sign the RAW request-body bytes with HMAC-SHA256 — never re-serialized or parsed JSON. Prefix a scheme version (`v1,`) so you can rotate algorithms, and follow the Standard Webhooks spec (`webhook-id`/`webhook-timestamp`/`webhook-signature`) if you can. Put the timestamp INSIDE the signed content and reject deliveries where |now − t| > 300s to defeat replay. Verify with a constant-time compare (`hmac.compare_digest`), never `==`. Support 2+ active secrets during rotation. Never follow 3xx redirects — treat them as failures.

Ordering: HTTP plus retries guarantees out-of-order arrival — a retried event 1 lands after event 2. Do not trust arrival order. Stamp each event with a per-resource monotonic version/sequence; consumers apply last-write-wins and DROP any event whose version ≤ the last applied. If strict in-order is mandatory, partition by resource id onto a single-writer queue (Kafka key / FIFO group).

BAD: `hmac(secret, JSON.stringify(req.body))` computed after the JSON body-parser ran — key reordering and whitespace differ from what the sender signed, valid signatures fail, and someone "fixes" it by turning verification off.
GOOD: capture the raw body buffer before parsing, sign `HMAC-SHA256(secret, f"{t}.{raw_body}")`, and verify with a constant-time compare inside a 300s timestamp window.

If you report a delivery-success rate or latency, it must be measured — if not measured, write "not measured", never estimate.

```
═══ WEBHOOK DELIVERY DESIGN: [service] ═══
Source:       state change → outbox table [name]  (same tx: [yes])
Dispatcher:   [poll|CDC]   per-attempt timeout [10s]   concurrency [N]
Retry:        on [conn,429,5xx]   backoff+jitter [10s→10h/3d]   → DLQ [name]
Auto-disable: after [~3d] continuous failure → alert [owner]
Signing:      HMAC-SHA256 over raw body   header [name]   scheme [v1,]   skew ≤ [300s]
Rotation:     [N] active secrets   compare [constant-time]   redirects [never]
Ordering:     version field [name]   consumer rule [LWW drop ≤]   strict [partition|no]
Idempotency:  event id [uuid]   consumer dedupe [required]
Delivery rate:[%] over [window]   (if not measured: "not measured")
```

Skip when: you're RECEIVING/verifying inbound webhooks from a provider (that's a consumer task), or events stay inside one service (use a durable queue directly), or it's a one-off manual notification.

Gotchas: the JSON body-parser consumes the raw bytes — capture them (e.g. `express.raw` / a verify callback) before any middleware, or your HMAC can never match. An eventual 200 after retries still means duplicates were delivered — a non-idempotent consumer double-charges, so dedupe on event id, not arrival. Polling the outbox with `SELECT ... LIMIT` without `FOR UPDATE SKIP LOCKED` makes two dispatchers grab the same row and double-send.
