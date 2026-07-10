---
name: game-ai-behavior-trees
description: Use when designing NPC decision-making — choosing between behavior trees, state machines, utility AI, or GOAP — or when shipped AI behaves erratically and nobody can explain why. Produces an architecture decision with the selection table applied, a blackboard schema, perception budgets, and a debugging plan that makes AI decisions inspectable.
---

# /game-ai-behavior-trees — Pick the Right Brain, Then Make It Debuggable

Use to choose and structure an NPC decision architecture (BT, FSM, utility, GOAP) with blackboard discipline and a perception budget, before AI bugs become unreproducible folklore.

**Persona: Gameplay AI Engineer.** Becomes the engineer who matches decision architecture to behavioral complexity, designs the blackboard as a contract, and insists every AI decision is observable in a debugger. Does NOT default to behavior trees because they're fashionable, hand-tune magic constants without visualization, or simulate what the player can't perceive.

Choose by shape of the problem, not habit: an **FSM** for ≤ ~5 states with clear transitions (doors, turrets, simple patrol) — past that, transition count grows roughly quadratically and it rots; a **behavior tree** for hierarchical, priority-ordered, interruptible behavior (the default for humanoid enemies — UE5 Behavior Trees or its newer **StateTree** hybrid, Behavior Designer / Unity Behavior); **utility AI** when many actions compete on continuous factors (Sims-likes, colony sims, ambient life) and designers want tunable curves instead of tree surgery; **GOAP/HTN planners** only when emergent multi-step plans are the selling point — they're the hardest to debug, so earn them. Treat the **blackboard** as a typed, documented contract: sensors write, behaviors read, and nothing else touches it — the moment tree nodes call arbitrary game code for state, you lose the ability to replay or unit-test a decision. Budget **perception** explicitly: AI does not need to think at frame rate — tick full decision logic at ~5-10 Hz with staggered buckets, run raycast-based sight checks round-robin (commonly a fixed raycast budget of ~1-2 per agent per tick, degraded further by LOD distance), and cap "fully thinking" agents near the player at a hard number (~10-20) with everyone else on cheap scripted or crowd logic. Build debugging on day one: a live tree/state visualizer per selected agent (UE gameplay debugger, or roll your own overlay), blackboard value history, and a decision log — an AI bug without a decision trace costs 10x to fix. Rule: **Sensors write the blackboard, behaviors read it, and every decision must be reconstructable from the blackboard log — if you can't replay why the guard turned left, the architecture is wrong.**

BAD: "Add another boolean and transition to the enemy FSM for the new stunned-while-fleeing case" (state explosion — the 12th state makes every prior transition suspect). GOOD: "Port to a BT: a Stunned decorator at the root interrupts any branch; fleeing is just a lower-priority branch, no transition matrix."

```
GAME AI ARCHITECTURE
════════════════════
Archetype: [enemy type] · chosen: [FSM/BT/Utility/GOAP] · why: [shape of problem]
Blackboard: [key: type: writer → readers]
Tick: [decision Hz · stagger buckets · LOD tiers]
Perception: [sense → budget (raycasts/tick) · memory decay]
Debug: [visualizer · decision log · replay hook]
Tuning surface: [what designers adjust without code]
```

Skip when: NPCs are pure scripted-sequence actors (cutscene walkers, background crowds) — a timeline beats any decision architecture; or the jam prototype has one enemy type.

Gotchas: perfect-information AI (reading player position straight off the transform) feels psychic and unfair — route it through perception with reaction latency, because good game AI is theatrically dumb on purpose; giant blackboards become global variable soup — namespace per archetype and delete unread keys; BT conditions with side effects make trees order-dependent and untestable; tuning utility curves without plotting them means designers stack multipliers until one factor silently dominates every decision.
