---
name: iot-fleet-management
description: Use when operating or designing operations for a deployed device fleet — provisioning identity, budgeting telemetry, running remote diagnostics, commanding offline devices, and decommissioning units. Produces a fleet operations spec covering per-device identity lifecycle, data budgets, twin/shadow command flow, and revocation.
---

# /iot-fleet-management — Operating Devices You Can't Touch

Use to run a device fleet as a managed population: unique identity from the factory, telemetry that fits bandwidth and battery budgets, commands that survive offline gaps, and clean revocation at end of life.

**Persona: Fleet Operations Engineer.** You own the device lifecycle from factory provisioning to certificate revocation. You do not treat devices as always-online servers, and you do not add a telemetry field without pricing its bandwidth and battery cost.

Identity is the foundation: each unit gets a unique key/cert at manufacture — factory HSM signing, or better, keys generated **on-device in a secure element** (ATECC608, TrustZone, TPM) so private keys never exist outside the chip — then exchanges its birth credential for operational identity via just-in-time provisioning (AWS IoT fleet provisioning, Azure DPS). Telemetry runs on an explicit per-device budget: define bytes/day and messages/day before defining fields, then meet it with **delta/report-by-exception** publishing (send on change past a deadband, plus a slow heartbeat), batching, and CBOR or protobuf over JSON (~40-60% smaller); on cellular, budget against the data plan — commonly ≤~1 MB/month/device on NB-IoT-class plans — and remember each radio wake costs battery, so fewer larger messages beat many small ones. Commands go through a **device twin/shadow** (desired vs reported state) rather than fire-and-forget publishes: you write desired state, the device converges when it next connects and updates reported state, giving you idempotent, offline-tolerant, auditable control — direct RPC only for live interactive sessions. Remote diagnostics is log-on-demand: devices keep a RAM/flash ring buffer and upload only when flagged, never streaming debug logs fleet-wide (that torches both budget and privacy); add remotely adjustable log levels per device and a "request diagnostic bundle" command. Decommissioning is designed on day one: revoke the cert (deny-list/CRL at the broker), tombstone the twin, wipe device secrets via a signed decommission command, and rate-limit-alarm on revoked-credential connection attempts — a returned/resold unit still phoning home with valid credentials is a real breach vector. Rule: **all device-bound state changes flow through desired/reported twin reconciliation — if a command's effect can't be re-derived after the device was offline for a week, redesign it as state, not as an event.**

BAD: "Push a config command to all 40k devices at 9am; the 3k offline ones just miss it" (fleet forks into inconsistent config populations nobody can enumerate). GOOD: "Set desired config in each twin with a version field; devices converge on reconnect; a dashboard diffs desired vs reported and pages when convergence stalls >48h."

```
FLEET OPS SPEC — [fleet]
═══════════════════════════════════════
Identity:  key origin [secure element/factory HSM] · JIT prov [DPS/fleet-prov]
Registry:  [platform] · groups [rings/regions] · fw versions tracked
Telemetry: budget [KB/day · msg/day]/device · encoding [CBOR/proto]
           policy [deadband + heartbeat interval]
Commands:  twin desired/reported · convergence SLA [h] · drift alert
Diagnostics: ring buffer [KB] · on-demand upload · log level remote-set
Decommission: cert revoke → twin tombstone → secure wipe · alarm on reuse
═══════════════════════════════════════
```

Skip when: a pilot of a handful of devices you can physically reach — manual ops is honest at that scale, just don't ship shared credentials — or the fleet platform is fully dictated by an existing enterprise deployment.

Gotchas: shared or per-model (not per-unit) credentials make revocation of one device impossible without bricking thousands. Telemetry schemas only ever grow — without a budget gate, firmware teams add fields until the cellular bill or coin cell forces a crisis retrofit. Twin documents have size caps (commonly 8-32KB) — they hold state, not logs or history. Skipping the decommission path means ex-customers' devices keep writing into your production data forever.
