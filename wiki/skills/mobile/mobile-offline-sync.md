---
name: mobile-offline-sync
description: Use when a mobile app must work without connectivity — designing local-first storage, choosing a sync engine, picking conflict strategies (LWW vs CRDT vs server-wins), or fixing lost-update bugs. Produces a sync design: local schema, mutation outbox, per-entity conflict policy, and offline UX states.
---

# /mobile-offline-sync — The Device Is a Replica, Not a Cache

Use to design local-first mobile data: reads always local, writes queued and reconciled, conflicts resolved by explicit per-entity policy.

**Persona: Sync Protocol Engineer.** You treat the phone's SQLite as a full replica with a mutation log, and you choose the cheapest conflict strategy each entity can survive. You do not hand-roll a bidirectional sync protocol when an engine fits, and you do not pick CRDTs to feel rigorous.

Architecture: UI reads **only** the local database (SQLite via Room/GRDB/SQLDelight) and renders instantly; writes go to the local DB *and* an append-only **mutation outbox** replayed to the server with **idempotency keys**, exponential backoff capped at ~5 minutes, and OS-scheduled retry (WorkManager / `BGTaskScheduler`) so the queue drains without the app foregrounded. Buy the pipe before building it: **PowerSync**, **ElectricSQL**, or **Zero/Replicache**-style engines handle partial replication and resumable streams — hand-rolling is justified mainly when your server can't expose the change-log they need (and note Realm/Atlas Device Sync is deprecated; don't start there). Conflicts get a policy *per entity, chosen by damage*: **server-wins** for anything where the server computes truth (prices, permissions, inventory); **per-field LWW** with server-assigned timestamps for ordinary CRUD — field granularity is the difference between merging two users' edits and silently discarding one; **CRDTs** (Automerge, Yjs, Loro) only for genuinely concurrent structures — collaborative text, shared lists — because they cost storage growth, schema rigidity, and hard-to-explain merge states. Never trust device clocks for ordering: use server receive-time or **hybrid logical clocks**. UX: show queued state per item (pending badge, not a global spinner), let users retry or discard a permanently-failed mutation, and reconcile optimistic UI when the server rejects — a write that fails validation server-side must visibly revert, not vanish. If a mutation has failed for >24h, surface it; silent queues are where user data goes to die. Rule: **Pick the weakest conflict strategy the data survives — server-wins where the server owns truth, per-field LWW for CRUD, CRDT only where concurrent editing is the product.**

BAD: "POST each edit when connectivity returns and let the last request win at row level" (no idempotency → duplicates on retry; row-level LWW → user A's title edit erases user B's body edit; clock skew reorders history). GOOD: "Outbox with idempotency keys, per-field LWW on server timestamps, server-wins for inventory, pending badges in the UI."

```
OFFLINE SYNC DESIGN
═══════════════════
Local store: [SQLite lib] · Engine: [PowerSync/Electric/Zero/custom + why]
Replication scope: [tables, partial-sync predicate per user]
Outbox: [idempotency key scheme · backoff cap ~5min · scheduler]
Conflict policy: [entity → server-wins / field-LWW / CRDT → rationale]
Clocks: [server ts / HLC] · UX: [pending badge · failed-write surface at >24h · revert path]
```

Skip when: the app is read-mostly and stale-while-offline is acceptable — an HTTP cache plus retry-on-submit beats a sync engine; or every write is inherently online (payments, auth).

Gotchas: testing offline by toggling airplane mode for 10 seconds — real conflicts need two devices editing the same record across hours, plus process death mid-queue. Migrating local schema without migrating queued mutations, so the outbox replays writes the new server schema rejects. Letting the outbox grow unbounded when an account is signed out or a mutation is poison — cap, quarantine, and report. Optimistic UI with no rejection path: server-side validation failures must reach the user, or the app lies about saved data.
