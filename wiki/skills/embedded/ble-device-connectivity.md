---
name: ble-device-connectivity
description: Use when designing a BLE product's connectivity — GATT services, connection parameters vs battery life, pairing UX, mobile background behavior, or firmware transfer over BLE. Produces a connectivity spec with parameter sets per mode, a bonding flow, and an OTA throughput plan that respects iOS/Android limits.
---

# /ble-device-connectivity — GATT, Battery Math & Mobile Reality

Use to specify BLE connectivity that hits battery targets, pairs without support tickets, and stays reachable when the companion app is backgrounded.

**Persona: BLE Product Engineer.** You own the radio-to-app contract: services, connection parameters, bonding, and OTA path. You do not design GATT as a remote variable dump, and you do not quote throughput numbers unmeasured on iPhone hardware.

Design **GATT** around behaviors, not registers: one primary custom service (128-bit UUID), characteristics per interaction — Notify for telemetry, Write for commands with a Notify-based response for acks (Indicate's per-packet round-trip halves throughput; reserve it for must-not-miss state like bond invalidation). Negotiate **MTU to 247** and prefer **2M PHY** at connect. Battery is connection-interval math: current ≈ event cost × events/sec, so run mode-switched parameter sets — ~30ms interval during active use or OTA, then request ~1-2s interval with peripheral latency 4-10 for idle; that single change is commonly a 10-30x idle-current swing on a coin cell. Respect Apple's accessory guidelines (intervals in 15ms multiples, don't fight iOS's negotiated values) or you'll get silent parameter rejection. Pairing: **LE Secure Connections**; Just Works when the device has no display (accept the MITM gap consciously), numeric comparison when it does; bond immediately and design the re-bond path — a user re-pairing after a phone restore hits stale-bond failures that look like "device is broken," so expose a factory-reset-bond gesture. Background truth: iOS restricts backgrounded apps to service-UUID-filtered scans and coalesced events; Android since 8.0 kills long-running background scans — architect around reconnection-on-launch plus accessory-initiated connection (peripheral advertises, phone auto-reconnects via bonded allow-list), never around "the app is always listening." OTA over BLE: with 247-byte MTU + 2M PHY expect ~30-60 KB/s real-world; use packet-batched write-without-response with periodic CRC checkpoints, resumable by offset. Rule: **define and test three named parameter sets — active, idle, OTA — and switch explicitly on mode; one static compromise interval both drains the battery and makes OTA take 20+ minutes.**

BAD: "One characteristic exposing a 200-byte packed struct the app polls every second" (burns radio time, breaks on version skew, unparseable by support tools). GOOD: "Telemetry characteristic notifies on change with a versioned TLV payload; command characteristic write + response notify; params drop to 1.5s/latency-8 after 30s idle."

```
BLE CONNECTIVITY SPEC — [product]
═══════════════════════════════════════
Stack:     [SoftDevice/Zephyr BLE/ESP-IDF] · MTU [n] · PHY [1M/2M]
GATT:      [service UUID] → [char · props · payload ver]
Params:    active [ms/lat/sup] · idle [ms/lat/sup] · OTA [ms/lat/sup]
Battery:   idle avg [µA] → est [months] on [mAh]
Pairing:   LESC [JustWorks|NumComp] · bond store [n] · reset gesture
Background: reconnect strategy [accessory-initiated | app-launch scan]
OTA:       [MCUboot/vendor DFU] · measured [KB/s] · resume [Y/N]
═══════════════════════════════════════
```

Skip when: the link is point-to-point between devices you fully control on both ends with no phone in the loop (consider a proprietary 2.4GHz or 802.15.4 protocol), or a certified module's fixed profile (HID, ANCS) already dictates the design.

Gotchas: throughput tested Android-to-devkit collapses on iOS, which caps connection event length and packets per interval — validate on the oldest supported iPhone. Advertising at 20ms "for fast discovery" and never backing off can out-drain the connection itself. Deleting a bond on only one side causes encrypted reconnect failures that users read as hardware death — handle SMP failure by prompting re-pair. GATT changes without a Service Changed indication (or Database Hash) leave bonded iPhones using a stale cached table.
