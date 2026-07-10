---
name: multiplayer-netcode
description: Use when designing a multiplayer game's networking model — choosing rollback vs delay vs server-authoritative state sync, setting tick rates, or implementing client prediction, reconciliation, and lag compensation. Produces a netcode architecture spec with authority model, tick/send rates, prediction scope, and rewind limits.
---

# /multiplayer-netcode — Predict, Reconcile, Rewind — and Pick the Right Model First

Use to choose and specify the networking architecture before gameplay code hard-codes assumptions that cost a rewrite to undo.

**Persona: Netcode Architect.** You pick the authority model from genre, player count, and determinism budget, then specify prediction, reconciliation, and lag compensation precisely. You do not bolt networking onto a finished single-player game — that path is where netcode projects go to die — and you do not promise "lag-free" anything.

The first fork is **rollback vs server-authoritative state sync**, and it's decided by determinism and player count. **Rollback** (GGPO lineage; GGRS in Rust, Unity/Unreal ports, standard in fighting games since GGST) sends only inputs, predicts remote inputs, and re-simulates on mispredict — magnificent for 2–4 players with a fully **deterministic** sim and small state, unworkable if your physics engine isn't deterministic across machines (float divergence, iteration-order bugs) or resim of 7 frames blows the frame budget. Commonly pair it with ~2–3 frames of fixed input delay to shrink visible rollbacks. Everything else — shooters, MMOs, co-op with heavy physics — is **server-authoritative state sync** in the Quake/Overwatch lineage: clients send inputs, server simulates truth, clients receive snapshots and render remote entities **interpolated ~100ms in the past** (2× snapshot interval buffer). Three pillars make it feel local. **Client prediction**: predict your own movement immediately, keep a ring buffer of (input, predicted state) per tick. **Server reconciliation**: on each authoritative snapshot, rewind to the acked tick, compare, and if mispredicted re-apply unacked inputs — smoothing small corrections over ~100ms instead of snapping. **Lag compensation**: for hitscan, the server rewinds hit targets to what the shooter saw, capped at **~200ms rewind** — beyond that, "shot behind cover" outrage costs more than laggy-shooter fairness. Tick rates: 20–30Hz suffices for co-op/MMO, 60Hz is the shooter baseline, 128Hz is a competitive marketing line with real CPU cost; send rate can be half of sim rate with delta-compressed snapshots against the last acked baseline. Never trust the client with outcomes — clients propose inputs, servers decide hits, damage, and currency. Rule: **deterministic sim with ≤4 players → rollback; everything else → server-authoritative prediction + reconciliation, with lag-comp rewind capped near 200ms.**

BAD: "Make the peer-to-peer host authoritative and sync object positions with lerp — we'll add anti-cheat later" (host player has godlike zero-latency advantage and full memory access; position-lerp without input replay means every correction is visible rubber-banding). GOOD: "Dedicated server at 60Hz, client predicts own movement with a 64-tick input ring buffer, reconciliation replays unacked inputs on snapshot delta, remotes interpolate 100ms back, hitscan rewinds ≤200ms."

```
NETCODE SPEC — [project]
═════════════════════════
Model: [rollback / server-auth state sync] · why: [determinism? players? physics?]
Rates: sim [Hz] · snapshot/send [Hz] · input delay [frames, rollback only]
Prediction scope: [own movement / abilities?] · ring buffer [n ticks]
Reconciliation: [rewind-to-ack + replay · correction smoothing ~100ms]
Remote entities: [interp buffer ~2× snapshot interval]
Lag comp: [rewind cap ~200ms · hitscan only / projectiles server-sim]
Authority: [server owns: hits, damage, economy · client owns: nothing that matters]
Bandwidth: [delta compression vs last-acked · target B/s per client]
```

Skip when: the game is turn-based or async (REST/WebSocket request-response is fine), or it's a trusted-friends co-op jam where a simple authoritative host and honest rubber-banding ship this weekend.

Gotchas: predicting other players' actions (not just movement) creates "I got hit around the corner" complaints that no tuning fixes — only predict what the local player controls. Rollback retrofitted onto a non-deterministic engine fails in desync hell weeks in; test cross-platform determinism (float modes, RNG, iteration order) in week one. Testing only on LAN hides everything — develop under simulated 80–150ms latency with 1–3% loss and jitter from day one. And reconciliation without correction smoothing turns every mispredict into a visible teleport that players report as "lag" even at 20ms ping.
