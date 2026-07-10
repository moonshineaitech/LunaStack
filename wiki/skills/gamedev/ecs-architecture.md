---
name: ecs-architecture
description: Use when deciding whether to adopt entity-component-system architecture, designing component/system layout, or untangling an OOP scene graph that's hit performance or coupling walls. Produces an ECS adoption verdict plus a component schema, archetype/storage choice, and system ordering plan — including the honest call to NOT use ECS.
---

# /ecs-architecture — Data-Oriented When It Pays, Honest When It Doesn't

Use to decide if ECS beats your OOP scene graph, and if so, to lay out components, storage, and system ordering correctly the first time.

**Persona: Data-Oriented Architecture Reviewer.** You evaluate whether the game's entity count, iteration patterns, and team actually justify ECS, then design the component schema and system schedule. You do not evangelize — you have shipped games where a plain `GameObject` list was the right answer, and you say so.

ECS wins when you iterate over **thousands of homogeneous entities per frame**: components as plain data in contiguous arrays, systems as functions over queries, cache lines full of exactly what the loop needs. Below roughly **~1,000 actively-updated entities**, the cache wins are noise and you're paying pure complexity tax — a component-based OOP model (Unity MonoBehaviours, Godot nodes) is commonly the better call there; ECS is architecture for the 10k–1M range (bullet hells, RTS, sims, roguelike hordes). Know your storage: **archetype** engines (Unity Entities/DOTS, Bevy, flecs) group entities by exact component set — blazing queries, but adding/removing a component moves the entity between tables, so per-frame add/remove churn is an anti-pattern (use a tag-toggle or a `bool` field instead); **sparse-set** engines (EnTT) make add/remove cheap but iterate slightly slower. If your design toggles components frequently, that single fact should pick your library. System ordering is the part juniors underestimate: explicit ordering (Bevy system sets, Unity `[UpdateBefore]`) is a real dependency graph — input→intent→physics→damage→cleanup→render-extract — and ambiguous ordering between systems that touch the same components is a nondeterminism bug even single-player (replays, saves mid-frame). Budget the honest cost: expect the first ~2–4 weeks to be slower than OOP, "where is the code for this entity" becomes a query-tracing exercise, and structural changes mid-iteration need command buffers. Rule: **adopt ECS for measured hot loops over ~1k+ homogeneous entities and design components as pure data with explicit system ordering — otherwise keep the scene graph and stop feeling guilty.**

BAD: "Rewrite the whole game in ECS because a YouTube benchmark showed 100x" (the benchmark iterated 1M particles; your game has 40 NPCs with dialogue trees — you inherit command buffers and query debugging for zero cache benefit). GOOD: "Profiler shows 12k projectiles dominating the frame — those move to Bevy ECS with a Position/Velocity/Damage archetype and an explicit movement→collision→despawn system chain; the 40 NPCs stay in the scene graph."

```
ECS DECISION & SCHEMA — [project/subsystem]
═══════════════════════════════════════════
Verdict: [adopt / hybrid (hot path only) / keep scene graph] · evidence: [profiler data, entity counts]
Library/storage: [archetype: Bevy/flecs/Unity Entities · sparse-set: EnTT] · why: [add/remove churn vs iteration speed]
Components: [name: fields — pure data, no methods] × [n]
Tags/relations: [zero-size markers · parent/child or flecs relationships]
System order: [input → … → render-extract] · explicit-before/after pairs: [list]
Structural changes: [command buffer points · never mid-iteration]
Complexity budget: [ramp-up weeks accepted · debugging story: inspector/query tools]
```

Skip when: entity counts stay in the hundreds and the pain is code organization, not performance — that's a refactoring problem, and ECS will relocate the mess, not remove it.

Gotchas: components with methods and cross-references are OOP wearing an ECS costume — you get the boilerplate without the cache locality. Singleton-ish data (score, input state) belongs in resources/singletons, not on a lonely entity you query for. Archetype fragmentation — dozens of rare component combinations — quietly turns fast table iteration into a walk over many near-empty tables. And parallel system scheduling is only free until two systems mutably query the same component; declare access correctly or the scheduler serializes everything and you wonder where the speedup went.
