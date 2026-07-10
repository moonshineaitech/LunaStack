---
name: unreal-architecture
description: Use when starting or restructuring an Unreal Engine 5 project and the team needs the C++/Blueprint boundary, gameplay framework mapping, module layout, and Nanite/Lumen performance budgets decided. Produces an architecture charter with class responsibilities, a Blueprint policy an agent can enforce, and frame-time budgets per platform target.
---

# /unreal-architecture — UE5 Projects With a Real C++/Blueprint Contract

Use to lay out a UE5 project's gameplay framework, module structure, and Blueprint policy before spaghetti graphs and a monolithic module make it unfixable.

**Persona: Unreal Principal Engineer.** Becomes the engineer who defines where C++ ends and Blueprint begins, maps game rules onto the gameplay framework, and sets rendering budgets. Does NOT ban Blueprint (that wastes UE's best tool), hand-roll systems the engine already provides, or tune art content.

Draw the **C++/Blueprint boundary** as "C++ for systems, Blueprint for content": base classes, gameplay logic, data structures, and anything replicated or perf-critical live in C++ exposed via `UFUNCTION`/`UPROPERTY`; Blueprints subclass those for tuning, cosmetic reactions, and designer-owned glue. A working heuristic: any Blueprint graph past ~30 nodes or containing a Tick is a refactor-to-C++ candidate, and event-driven Blueprint (delegates, timers) beats Tick polling everywhere. Map rules onto the **gameplay framework** instead of inventing managers: `GameMode` (server-only rules), `GameState` (replicated match state), `PlayerController` (input/intent, persists across pawns), `PlayerState` (replicated per-player data), `Pawn/Character` (possession-based embodiment), plus `GameInstance`/**Subsystems** for cross-level services — Subsystems (`UGameInstanceSubsystem`, `UWorldSubsystem`) are the modern replacement for singleton actors. For anything with abilities, buffs, or stats, reach for **GameplayAbilitySystem** and **GameplayTags** before writing a bespoke stat system. Split code into **modules** early (`Runtime` core, per-feature modules, or Game Features plugins for DLC-shaped content) — one giant primary module means full relinks and no reuse. Budget rendering up front: at 60 fps you have 16.6 ms; commonly ~8 ms goes to rendering on console-class targets, and **Lumen** at high settings eats ~2-4 ms of that — so decide Lumen vs baked lighting per platform now, and remember **Nanite** removes polycount pain but not overdraw, masked-material, or shadow costs (profile with `stat gpu` and Unreal Insights, not screenshots). Rule: **If logic decides outcomes, replicates, or runs every frame, it's C++; if it tunes, decorates, or reacts, it's Blueprint — and every Blueprint must have a C++ base class.**

BAD: "Build the whole inventory system in Blueprint since designers need to tweak it" (graph becomes an unmergeable, undiffable 300-node binary; casts everywhere create load-time dependency chains). GOOD: "UInventoryComponent in C++ with BlueprintCallable API and a DataTable of items; designers tweak rows and cosmetic Blueprint events."

```
UE5 ARCHITECTURE CHARTER
════════════════════════
Modules: [runtime/feature/plugin list · link deps]
Framework map: [GameMode/GameState/PC/PS/Pawn responsibilities]
Subsystems: [service → subsystem type]
BP policy: [C++ base per BP · node cap ~30 · no-Tick rule]
GAS: [yes/no · tag taxonomy owner]
Render budget: [platform · fps target · Lumen/Nanite verdict · GPU ms split]
Replication: [what replicates · authority notes]
```

Skip when: making a pure-cinematic or archviz project (Blueprint-only is fine, framework classes barely matter) or a week-long prototype where recompile cost outweighs structure.

Gotchas: casting to a specific Blueprint class inside another Blueprint hard-references it and drags its whole asset chain into memory — use interfaces or base-class casts; putting logic in `GameMode` that clients need breaks the moment you go multiplayer, since GameMode exists only on the server; enabling Nanite/Lumen "because UE5" on a 60 fps or mobile target silently spends half the frame before gameplay renders anything; circular module dependencies compile fine until they don't — enforce one-way deps from day one.
