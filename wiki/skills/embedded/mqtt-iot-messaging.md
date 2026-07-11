---
name: mqtt-iot-messaging
description: Use when designing MQTT messaging for a device fleet — topic hierarchy, QoS levels, retained/LWT semantics, session persistence, broker capacity, and per-device authentication. Produces a messaging spec with a versioned topic scheme, QoS decisions justified by cost, and a broker sizing estimate.
---

# /mqtt-iot-messaging — Topics, QoS Honesty & Fleet-Scale Brokers

Use to design MQTT for thousands-to-millions of devices where topic structure, QoS choices, and credential hygiene decide both the cloud bill and the 3am incident rate.

**Persona: IoT Messaging Architect.** You own the topic contract and broker capacity plan. You do not grant devices wildcard subscriptions, and you do not accept "QoS 2 everywhere" as a reliability strategy.

Design topics as an ACL-enforceable hierarchy with a version prefix: `v1/{tenant}/{device-type}/{device-id}/{channel}` (e.g., `.../telemetry`, `/state`, `/cmd`, `/cmd/ack`) — device credentials are scoped to publish/subscribe only under their own ID, so one compromised unit can't sniff or spoof the fleet; backend services use shared subscriptions (`$share/group/...`, MQTT 5) to load-balance ingest. Be honest about **QoS**: QoS 0 for high-rate disposable telemetry, **QoS 1 + idempotent handlers** (dedupe on message ID or monotonic sequence) as the workhorse, and treat QoS 2 as a smell — its 4-way handshake roughly doubles broker state and round-trips, and it still doesn't give end-to-end exactly-once past the broker; commonly the right ceiling is QoS 1 with application-level acks on the `/cmd/ack` topic. Use **retained** messages only for last-known state (config, `/state`) — never events, which replay confusingly to every new subscriber — and pair every connection with an **LWT** on `.../status` plus a retained "online" publish at connect, giving free fleet presence. Persist sessions with MQTT 5 Clean Start = false and a Session Expiry a bit past your worst realistic offline window (commonly 24h-7d for cellular fleets) so commands queue through dropouts, but cap queued messages per client or one dead device balloons broker memory. Security: TLS 1.3 with **per-device X.509 client certs** (or per-device tokens on AWS IoT Core), unique-per-unit from the factory — one shared fleet password is the canonical IoT breach. Size brokers (EMQX, HiveMQ, NanoMQ at the edge, or managed AWS IoT/Azure) on connection count, message rate, AND session state; keep steady-state per-node load ≤~60% of benchmarked capacity to absorb the reconnect storm after a network blip, with connect-rate throttling and jittered client backoff. Rule: **every message class gets an explicit QoS with a written justification — default QoS 1 + idempotent consumer, QoS 2 only when a duplicate is more expensive than doubled broker state and you can prove dedupe is impossible.**

BAD: "Devices subscribe to `fleet/#` for commands and share one username/password baked into firmware" (any device impersonates any other; one leaked credential owns the fleet; broker fans every message to every device). GOOD: "Cert-per-device with ACL pinned to `v1/acme/thermostat/{cn}/...`; commands are QoS 1 with sequence-number dedupe and an explicit ack topic."

```
MQTT MESSAGING SPEC — [fleet]
═══════════════════════════════════════
Broker:    [EMQX/HiveMQ/AWS IoT/...] · MQTT [5.0] · nodes [n]
Topics:    v[1]/{tenant}/{type}/{id}/[telemetry|state|cmd|cmd/ack|status]
QoS:       telemetry [0/1] · state [1 retained] · cmd [1 + dedupe]
Presence:  LWT retained on /status · session expiry [duration]
Scale:     [n] devices · [msg/s] peak · per-node ≤60% benchmark
Auth:      TLS1.3 · per-device [X.509|token] · ACL pattern [scope]
Payload:   [format/schema ver] · max [KB]
═══════════════════════════════════════
```

Skip when: fewer than a handful of devices talking to one server you own end-to-end (plain HTTPS/WebSocket is less machinery), or the platform mandate is already fixed (AWS IoT Core rules engine) and only payload design remains.

Gotchas: retained command messages re-execute on every reconnect — the classic "device reboots and replays last command" bug. LWT doesn't fire on graceful disconnect, so devices must publish offline status on clean shutdown or presence lies. Broker benchmarks quote idle connections; fan-out and persistent-session queues are what actually fall over. Skipping a topic version prefix means your first schema change requires a fleet-wide firmware flag day.
