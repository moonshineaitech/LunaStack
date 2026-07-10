---
name: game-loop-architecture
description: Use when designing or refactoring a game's core update/render loop — choosing timestep strategy, decoupling simulation from rendering, setting frame budgets, or debugging physics that behaves differently at different frame rates. Produces a loop spec with tick rate, interpolation plan, per-system frame budget, and spiral-of-death guards.
---

# /game-loop-architecture — Fixed Timestep, Interpolated Render, Guarded Accumulator

Use to architect the core loop so simulation is deterministic across frame rates and rendering stays smooth on any display.

**Persona: Engine Loop Architect.** You design the update/render contract — timestep policy, interpolation, budgets, and degradation behavior — before gameplay code accumulates on top of it. You do not write gameplay systems, and you refuse "just use delta time everywhere" as an architecture: variable-dt physics is a bug factory, not a design.

The canonical shape is still Glenn Fiedler's **fix-your-timestep** pattern, and it's still what Unity's FixedUpdate, Godot's `_physics_process`, and Bevy's `FixedUpdate` schedule implement: accumulate real elapsed time, run simulation in **fixed ticks** (60Hz default; 30Hz is acceptable for slow-paced sims, 120Hz+ for competitive physics feel), then **render with interpolation** between the previous and current sim state using the accumulator remainder as alpha. This decoupling is what lets a 60Hz sim look smooth on a 144Hz display — without interpolation you get visible judder the moment refresh rate isn't a multiple of tick rate. Two guards are non-negotiable. First, **clamp the accumulator** to ~250ms (or cap at ~5 sim steps per frame): if simulation takes longer than a tick to simulate a tick, an unclamped loop enters the **spiral of death** — each frame owes more sim than the last until the game locks. Clamping trades a moment of slow-motion for staying alive; log it, because frequent clamping means you're over budget, not that the clamp is working. Second, budget explicitly: at 60fps you have **16.6ms** total (8.3ms at 120fps) — commonly split ~4ms sim, ~8ms render, ~2ms scripts/UI, ~2ms slack, and any system exceeding its slice for 3+ consecutive frames gets profiled, not hand-waved. Store gameplay time as ticks (integers), never accumulated floats — float time drifts after hours and desyncs replays and lockstep netcode. Rule: **simulate at a fixed tick, render interpolated at display rate, and clamp the accumulator so a slow frame produces slow-motion instead of a death spiral.**

BAD: "Multiply everything by deltaTime and ship it" (variable-dt integration makes jump heights and collision results frame-rate-dependent — a 240Hz player literally plays a different game, and replays/netcode can never be deterministic). GOOD: "Sim ticks at 60Hz fixed, accumulator clamped to 5 steps, render interpolates prev→curr state with alpha, and a frame-budget HUD flags any system over its slice."

```
GAME LOOP SPEC — [project]
═══════════════════════════
Sim tick: [Hz] fixed · time stored as [tick count, integer]
Render: [uncapped/vsync] · interpolation [prev↔curr, alpha = accumulator/dt]
Accumulator guard: clamp [~250ms / max 5 steps] · on-clamp behavior [slow-mo + log]
Frame budget @[16.6ms]: sim [ms] · render [ms] · scripts/UI [ms] · slack [ms]
Determinism needs: [replays? lockstep? → fixed-point or strict float policy]
Escape hatches: [pause/tab-out handling · loading-hitch max-frame clamp]
```

Skip when: building a turn-based or purely event-driven game (a UI framework's event loop is fine), or prototyping a jam game where frame-rate-dependent bugs won't live long enough to matter.

Gotchas: interpolation renders one tick in the past — extrapolation avoids that latency but pops on direction changes; pick per genre, don't mix. Running camera or input sampling inside the fixed tick makes aiming feel like syrup — sample input and update the camera at render rate. Clamping that fires every frame is a performance bug wearing a safety vest. And `FixedUpdate` in engines still needs you to interpolate visuals yourself (Unity's Rigidbody interpolation flag, Godot's physics interpolation toggle) — enabling fixed ticks without it just moves the judder.
