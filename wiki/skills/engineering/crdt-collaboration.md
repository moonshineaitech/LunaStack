---
name: crdt-collaboration
description: Use when building collaborative or local-first editing — shared documents, whiteboards, multiplayer state — or choosing between CRDTs and OT. Covers Yjs/Automerge-class selection, awareness/presence, persistence and update compaction, and offline-merge UX. Produces a collaboration architecture with sync topology, persistence plan, and merge-conflict UX policy.
---

# /crdt-collaboration — Convergence Is the Easy Part

Use to design real-time and offline-capable collaboration where documents converge automatically, presence feels alive, and the server doesn't drown in update logs.

**Persona: Local-First Systems Engineer.** You choose the sync engine, design persistence and compaction, and define what users see when merges get weird. You do NOT design the editor's feature set or ship a research CRDT — you wire proven libraries into a system that survives production.

The CRDT-vs-OT question is settled for new builds: **OT** only wins when you already run an authoritative central server and need Google-Docs-style transform semantics; everything else — offline-first, P2P, multi-server — wants CRDTs. In 2026 the pragmatic pick is **Yjs** (fastest, huge editor ecosystem: ProseMirror/TipTap, CodeMirror, Slate) or **Automerge 3** (Rust core, better version-history semantics); wrap either in a sync layer like **Hocuspocus, PartyKit-class workers, or Liveblocks/Y-Sweet** rather than hand-rolling websocket fanout. Keep **awareness (presence, cursors, selections) out of the document**: it's ephemeral state on a separate protocol (Yjs awareness) — writing cursor positions into the CRDT bloats history forever with data nobody needs tomorrow. Persistence is where naive builds die: append-only update logs grow unboundedly, so **compact** — merge incremental updates into a full state snapshot commonly every ~500-1000 updates or on document close, store snapshot + recent tail, and periodically garbage-collect tombstones (Yjs GC on; keep them only if you need per-keystroke history). Design the **merge UX honestly**: CRDTs guarantee convergence, not intent — two users restructuring the same section offline converge to an interleaved mess, so after an offline gap longer than ~24h or divergence beyond a few hundred ops, show a "merged changes" diff-review instead of silently splicing. Cap concurrent editors per doc (~30-50 live editors is a practical ceiling before awareness traffic and update chatter degrade) and shard bigger rooms into sub-documents. Rule: **Presence lives outside the document, and every document has a compaction schedule — an append-only CRDT log with no snapshot policy is an outage on a timer.**

BAD: "Store every Yjs update as a row forever — storage is cheap" (a busy doc emits millions of updates; loads take 30s replaying history and the sync server OOMs). GOOD: "Snapshot every ~1000 updates via Hocuspocus persistence hooks, keep the recent tail for late-joiners, GC tombstones."

```
COLLABORATION ARCHITECTURE
══════════════════════════
Engine: [Yjs|Automerge] · editor binding: [TipTap|CodeMirror|custom] · why-not-OT: [reason]
Sync: [Hocuspocus|PartyKit|Liveblocks|Y-Sweet] · topology: [client-server|P2P/relay] · auth per doc: [scheme]
Presence: [awareness protocol, NOT in doc] · fields: [cursor·selection·user meta]
Persistence: snapshot every [~500-1000 updates|on-close] · tail kept: [N] · tombstone GC: [on|history mode]
Offline merge UX: silent-merge under [threshold] · diff-review beyond [24h / N ops] · version history: [snapshots]
Limits: [~30-50 live editors/doc] · oversize strategy: [subdocuments|sharding]
```

Skip when: a single-writer document with viewers only needs plain autosave plus broadcast — no CRDT. Turn-based or last-write-wins data (settings, forms) is fine with a plain database and optimistic locking.

Gotchas: syncing the whole workspace as one CRDT document — permissions and load balloon; one doc per access-control boundary. Trusting client updates blindly: CRDT sync bypasses your API validation layer, so enforce schema/authz server-side in the sync provider. Undo in CRDTs is per-user scope, not global — wire Yjs UndoManager to the local origin or users undo each other's work. Counting on CRDTs for numeric invariants (inventory, balances) — they converge values, not business rules; keep money out of the CRDT.
