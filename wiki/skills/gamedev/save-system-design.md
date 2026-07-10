---
name: save-system-design
description: Use when designing or reworking a game's save system — save format, autosave timing, corruption handling, or cloud sync. Produces a save architecture spec: atomic write protocol, rotating-backup recovery ladder, versioned schema migration plan, cloud-conflict resolution policy, and an autosave cadence that respects player intent.
---

# /save-system-design — A Lost Save Is a Lost Player

Use to architect saves that survive power cuts, schema changes, and two devices editing the same slot — the three failures every shipped game eventually meets.

**Persona: Save Systems Engineer.** You assume the process dies mid-write, the old version's saves outlive your refactors, and cloud sync will race. You do not write directly over the current save file, ever, and you do not treat migration as something to add "when we change the format."

**Atomicity first**: every save is write-to-temp → flush/fsync → atomic rename over the target (on consoles, the platform save API's transactional commit), with a **checksum or hash in the header** verified on load — the write-in-place save that corrupts on power loss is still the most common save bug in postmortems. Behind that, keep a **recovery ladder**: commonly ≥3 rotating save generations plus the last known-good, so a corrupt newest file degrades to "lost 10 minutes," not "lost 60 hours"; on load failure, walk the ladder silently and tell the player what happened rather than presenting an empty slot. **Version everything from build one**: a monotonic schema version in the header, forward-only migration functions applied in sequence (v3→v4→v5, never hand-written v3→v5 jumps), a migration test corpus of real saves from every shipped version, and a policy that you *never* delete unknown fields — a newer-version save opened by an older build should refuse politely, not truncate data. **Cloud conflicts**: naive last-write-wins deletes playtime, so resolve by progress heuristics (playtime + progression markers) and, when both branches have meaningful deltas, ask the player with concrete labels ("Level 12, 14h, today 3pm" vs "Level 11, 13h, yesterday") — Steam Cloud, PSN, and Xbox all surface conflict hooks; use them instead of silently picking. **Autosave cadence** balances safety against intent: checkpoint on state transitions (zone change, quest step, pre-boss) plus a timer commonly every ~5 minutes, but write autosaves to their own rotating slots so they never destroy a manual save — players use manual saves to *branch*, and an autosave that overwrites the only slot right after a disastrous choice is a design failure, not a technical one. Rule: **never overwrite the only copy — atomic rename for the file, rotating generations for the slot, and autosave in its own slots apart from manual saves.**

BAD: "Serialize the struct straight to save.dat on quit; if the format changes we'll bump the build and old saves just won't load" (one power cut corrupts the only copy, and every update wipes the install base's progress — review-bomb material). GOOD: "Versioned header + checksum, temp-write + rename, 3 rotating generations, v(n)→v(n+1) migration chain tested against a corpus of real saves from every shipped build."

```
SAVE ARCHITECTURE SPEC — [game / platform]
═══════════════════════════════════════════
Write path: temp → fsync → atomic rename (or platform transactional API) · header [version + checksum]
Recovery: rotating generations [≥3] + last-known-good · load-failure ladder [newest → oldest → inform player]
Migration: schema v[N] monotonic · chain v(n)→v(n+1) only · corpus [saves from every shipped version]
Cloud: conflict = progress heuristic [playtime + markers] → player choice w/ labeled snapshots
Autosave: triggers [zone/quest/pre-boss + ~5 min timer] · own slots [never overwrites manual]
```

Skip when: the game is a stateless arcade score-chaser — persist settings and a leaderboard entry and stop. Skip cloud-conflict design if you genuinely ship single-platform with no cloud saves, but leave the version header anyway.

Gotchas: serializing engine objects directly (Unity ScriptableObjects, raw memory dumps) welds your save format to internal refactors — save an explicit DTO layer you control. Testing migration only with dev saves misses the mangled real-world files; harvest saves from every beta build into a corpus. Saving on the main thread during autosave produces the telltale hitch players learn to dread — serialize a snapshot, write async. And "the cloud provider handles conflicts" means last-write-wins, which means the Steam Deck picked up on the plane just deleted last night's desktop session.
