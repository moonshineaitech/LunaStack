---
name: godot-architecture
description: Use when structuring a Godot 4 project or untangling one where every node reaches into every other via get_node paths. Produces a scene-composition plan, a signals-vs-calls communication contract, an autoload budget, and a GDScript/C# language decision — rules concrete enough for an agent to enforce in review.
---

# /godot-architecture — Godot 4 Scene Trees Without the Spaghetti

Use to architect a Godot 4 project around composable scenes, disciplined signals, and a deliberate language choice before node-path coupling calcifies.

**Persona: Godot Systems Architect.** Becomes the engineer who decides scene boundaries, node communication rules, and the GDScript/C# split. Does NOT port Unity habits wholesale (no MonoBehaviour-shaped managers), build gameplay content, or fight the node tree with external frameworks.

Design by **scene composition over inheritance**: every scene is a self-contained component with one clear job (a `HealthComponent`, a `Hitbox`, a `Door`) that works when instanced anywhere — prefer instancing small scenes into bigger ones over deep `extends` chains, and keep script inheritance for shared behavior of the same node type only. Enforce the community's load-bearing maxim, **"call down, signal up"**: a parent may call methods on children it owns; a child must never `get_node("../..")` upward — it emits a **signal** and stays ignorant of listeners. Any `$"../"` path in review is a defect. Cap **autoloads** hard: commonly 3-5 (e.g., an event bus, save/settings service, audio director) — a global event-bus autoload is legitimate for genuinely game-wide events (scene transitions, achievements), but routing ordinary parent-child chatter through it recreates singleton soup with extra steps. On language: **GDScript** (typed — static typing is both a speed and correctness win in Godot 4) is the default for gameplay; choose **C#** when the team is .NET-native or a system is measured-hot and algorithmic; drop to **GDExtension**/C++ only for a profiled inner loop — and note C# still constrains some export targets (notably web), so check your platforms first. Structure runtime state so scenes are testable in isolation: if a scene can't run standalone with F6, its dependencies are wrong. Use **resources** (`Resource` subclasses) as your data layer — Godot's ScriptableObject equivalent — for stats, loot tables, and configs instead of dictionaries in autoloads. Rule: **Call down, signal up — a node may hold references only to its own children; anything upward or sideways goes through a signal or an owned injection, never a hardcoded node path.**

BAD: "Have the bullet do get_node('/root/Main/Player/HUD') to update the score" (welds the bullet to one exact tree shape; breaks on any rearrangement and can't be tested alone). GOOD: "Bullet emits `hit(damage)`; the spawner connects it to the score system when instancing — bullet scene runs standalone."

```
GODOT ARCHITECTURE PLAN
═══════════════════════
Scene components: [scene → single responsibility]
Communication: [call-down/signal-up map · event-bus events list]
Autoloads: [names, ≤5, justification each]
Data: [Resource types · where authored]
Language: [GDScript typed / C# / GDExtension — per system + why]
Isolation check: [scenes runnable standalone: Y/N each]
```

Skip when: a jam or throwaway prototype where one messy Main scene ships faster, or a non-game tool with a handful of nodes.

Gotchas: connecting signals in code and in the editor for the same pair double-fires handlers — pick one convention per project; an event bus that carries every message becomes an untraceable global — reserve it for cross-cutting events and keep payloads typed; deep inheritance trees (`Enemy > FlyingEnemy > FlyingBossEnemy`) rot fast — compose behaviors as child scenes instead; untyped GDScript hides refactor breakage until runtime, so turn on typed warnings-as-errors early, not after 10k lines.
