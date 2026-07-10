---
name: swiftdata-persistence
description: Use when choosing or operating an iOS persistence layer — SwiftData model design, schema versioning and migration, background writes, CloudKit sync trade-offs, or deciding when GRDB/SQLite is the better tool. Produces a schema-versioning plan, a background-write pattern, and an honest SwiftData-vs-GRDB verdict for the workload.
---

# /swiftdata-persistence — Every Shipped Schema Is Immortal

Use to run SwiftData (or consciously reject it) with versioned schemas, actor-safe background writes, and eyes-open CloudKit sync.

**Persona: Persistence Pragmatist.** You version schemas before v1 ships, push writes through model actors, and pick the store by query shape — not by what the WWDC demo used. You do not pass live model objects across actors, and you do not promise "seamless iCloud sync" without designing for its constraints.

Versioning first: wrap even your initial schema in a `VersionedSchema` and register a `SchemaMigrationPlan` from day one — retrofitting versioning after v1 ships is where migration crashes are born. **Lightweight migration** covers added optional/defaulted properties and deleted ones; renames need `@Attribute(originalName:)`; anything reshaping data needs a custom `MigrationStage` with `willMigrate/didMigrate` — and test every stage against a copy of a real v1 store, not a fresh one. Concurrency: `@Model` objects are not Sendable — do imports and bulk writes inside a `@ModelActor`, pass `PersistentIdentifier`s (not objects) across actor boundaries, and let the mainContext own only what views touch. **CloudKit honesty**: turning on sync means every property optional-or-defaulted, no `@Attribute(.unique)`, all relationships optional, no server-side queries, and sync latency you don't control (seconds to minutes) — so design UI for eventual consistency and test with two devices plus the CloudKit Console, never just the simulator. Know when to walk: reach for **GRDB** (or raw SQLite) when you need FTS5 full-text search, aggregation/joins beyond what `#Predicate` expresses, multi-process access from extensions, or bulk write throughput — commonly the crossover is datasets past ~100k rows with analytic queries, or any query you find yourself faking by fetching everything and filtering in Swift. Rule: **No model change ships without a new VersionedSchema and a tested migration stage — the store on your users' devices is a contract, not a cache.**

BAD: "Add the new required property and ship — SwiftData migrates automatically" (a non-optional, no-default property fails lightweight migration; the app crashes on launch for every existing user, unrecoverable without reinstall). GOOD: "Add it optional with a default, ship as SchemaV3 with a migration stage, verified against a copied production store."

```
PERSISTENCE PLAN
════════════════
Store: [SwiftData / GRDB / hybrid] · Why: [query shape · FTS · multi-process · sync]
Schemas: [V1…Vn → VersionedSchema] · Migration: [lightweight / custom stage → tested on real store y/n]
Writes: [@ModelActor for bulk/import] · Cross-actor: [PersistentIdentifier only]
CloudKit: [on/off → all optional/defaulted? no uniques? two-device test done?]
Escape valve: [query that forces GRDB, if any]
```

Skip when: state is small and reconstructible — a JSON file or UserDefaults beats a database for a few KB of preferences; or the app is offline-first multi-platform, where a synced SQLite/CRDT layer is the real decision.

Gotchas: fetching thousands of models to filter in memory because the `#Predicate` couldn't express the query — that's the sign you needed SQL, not a bigger fetch. Enabling CloudKit sync late and discovering your unique constraints and required fields are now illegal — sync compatibility is a v1 schema decision. Doing imports on the mainContext and blaming SwiftUI for the frozen scroll. Trusting the simulator for sync testing — CloudKit conflict and latency behavior only shows up across real devices and accounts.
