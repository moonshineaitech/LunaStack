---
name: realtime-presence-systems
description: Use when building presence, typing indicators, or live cursors over WebSockets — "who's online" at any scale beyond one server. Produces a presence design: heartbeat cadence and TTL math, asymmetric flap debouncing, scoped subscription fanout, regional pub/sub topology, and a thundering-reconnect survival plan.
---

# /realtime-presence-systems — Who's Online, Without Melting Redis

Use to design presence/typing/cursor systems where state is ephemeral by construction (TTLs, not deletes) and fanout is scoped to what users can actually see.

**Persona: Realtime infrastructure engineer who has watched a deploy trigger a reconnect storm.** You size heartbeats, TTLs, and fanout budgets; you do NOT persist presence to the primary database or broadcast state changes to users who can't see them.

Presence is a **heartbeat + TTL** system: the client (or the socket server on its behalf) refreshes a Redis key like `presence:{user}` every ~25s, with TTL set to ~2.5–3× the heartbeat interval (~60–75s) so one dropped ping doesn't flip anyone offline — "online" simply means the key exists, and disconnect cleanup is free because expiry IS the offline signal. Broadcast asymmetrically: announce **online immediately** (users notice lag going green) but hold **offline behind a grace window of at least two missed heartbeats (~60s)** before fanning out — mobile radios and elevator rides cause most flaps, and this one debounce eliminates the bulk of presence traffic. Fanout must be **subscription-scoped**: clients subscribe to presence for the roster/channel/document currently on screen and unsubscribe on navigation; global "notify all my contacts" fanout is O(users × contacts) and is the classic presence scaling wall. Typing indicators are throttled client-side to one event per ~4s and expire server-side via ~6s TTL — never send explicit "stopped typing" as the sole mechanism, and never persist them. Cursors are coalesced to the last position per ~50ms tick (≈20 msg/s cap per user) and interpolated client-side. Regionally, keep pub/sub local (Redis pub/sub or NATS per region, Phoenix Presence's CRDT if on Elixir, or managed edge fabrics — Cloudflare Durable Objects, Ably, Liveblocks/PartyKit) and bridge only cross-region-visible channels over a global stream rather than mirroring everything. Plan for the **thundering reconnect**: a deploy or LB failover disconnects every client simultaneously and they all come back at once — require reconnect jitter (full-jitter exponential backoff, first attempt spread over ~0–30s), randomize each client's heartbeat phase so pings never synchronize, drain old servers gradually, and treat a resumed session within the TTL as "never left" so reconnects generate zero presence events. Rule: **Set presence TTL to ~2.5–3× heartbeat and debounce only the offline edge (~60s grace) — online fires instantly, offline waits.**

BAD: "On WebSocket close, immediately publish offline to all contacts" (every subway tunnel produces an offline+online pair fanned out to hundreds of subscribers; a deploy multiplies that by your whole connected user base at once). GOOD: "Key expiry after 60s grace is the offline signal, reconnect within TTL emits nothing, and clients reconnect with full-jitter backoff spread over 30s."

```
PRESENCE SYSTEM DESIGN
══════════════════════════════════════════
Heartbeat:   interval [~25s] · TTL [2.5–3×, ~60–75s] · phase [randomized per client]
Transitions: online [broadcast immediate] · offline [grace ~60s / 2 missed] · resume-in-TTL [silent]
Fanout:      scope [visible roster/doc only] · sub/unsub on [navigation] · budget [msgs/user/s]
Typing:      client throttle [1 per ~4s] · server TTL [~6s] · persistence [none]
Cursors:     coalesce [last per ~50ms] · cap [~20 msg/s/user] · client [interpolates]
Topology:    per-region [Redis pub/sub|NATS|Durable Objects] · cross-region [bridged channels only]
Reconnect:   backoff [full jitter, 0–30s first] · server drain [gradual] · storm test [run one]
```

Skip when: concurrency is tiny (a few hundred connections on one server — an in-process map with socket-close cleanup is fine), or "presence" really means last-seen timestamps where minutes of staleness are acceptable (just write on activity, no realtime fanout).

Gotchas: Redis pub/sub delivers to nothing if the subscriber was disconnected — pair it with a snapshot read on (re)subscribe or reconnecting clients show everyone offline. One user with N tabs/devices needs per-connection tracking under a per-user rollup, or closing one tab marks them offline everywhere. Deleting presence keys on graceful disconnect but relying on TTL for crashes gives two code paths with different latencies — let TTL be the only truth. Storing presence in Postgres turns your hottest write path into table bloat; it belongs in RAM with TTLs.
