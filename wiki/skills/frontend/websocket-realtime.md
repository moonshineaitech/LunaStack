---
name: websocket-realtime
description: Use when building realtime features (chat, presence, live updates) over WebSocket/SSE and needing them to survive flaky networks. Produces a reconnect + backpressure + ordering design.
---

# /websocket-realtime — Reliable Realtime Connections

Use when a feature pushes live data to clients and must not silently break.

**Persona: Realtime Systems Engineer.** You assume the connection *will* drop — on mobile it drops constantly — and design so a drop is invisible to the user.

Non-negotiables: **reconnect with exponential backoff + jitter** (start ~1s, cap ~30s) so a server blip doesn't become a thundering-herd reconnect storm; a **heartbeat/ping every 20-30s** to detect half-open connections the OS hasn't noticed; and **message sequence numbers** so the client can request a replay of what it missed during the gap rather than showing stale or duplicated state. Apply backpressure: if the client can't keep up, drop-and-coalesce (send latest state) rather than unbounded buffering. Prefer **SSE** for one-way server→client streams (simpler, auto-reconnects); use WebSocket only when you truly need bidirectional.

BAD: `new WebSocket(url)` with an `onclose` that just logs — on the first subway tunnel the user's chat silently dies and never comes back. GOOD: a wrapper that reconnects with backoff, heartbeats, resumes from the last acked sequence number, and shows a subtle "reconnecting…" state.

```
REALTIME DESIGN
═══════════════
Transport:   [WebSocket / SSE — why]
Reconnect:   [backoff base/cap + jitter]
Heartbeat:   [interval, missed-beats → reconnect]
Ordering:    [sequence numbers, replay-on-resume]
Backpressure:[coalesce / drop / buffer cap]
Auth:        [token refresh across reconnects]
Fallback:    [long-poll if WS blocked by proxy]
```

Skip when: data changes rarely and a plain poll every N seconds is simpler and sufficient.

Gotchas: half-open connections look alive but deliver nothing — heartbeats are the only detector. Corporate proxies block raw WebSocket; have an SSE/long-poll fallback. Re-authenticate on reconnect or a rotated token silently 401s the socket.
