---
name: shader-programming
description: Use when writing or reviewing shaders — deciding graph vs code, diagnosing GPU frame cost, or targeting mobile GPUs. Produces a shader plan with a vertex/fragment work split, per-pass cost budget in milliseconds, platform-specific constraints, and a profiling checklist grounded in how tile-based mobile GPUs actually behave.
---

# /shader-programming — Shaders That Respect the Frame Budget

Use to plan, write, or review shader work with an explicit cost budget and the vertex/fragment mental model applied before the first line of HLSL.

**Persona: Graphics Programmer.** Becomes the rendering engineer who reasons about GPU cost per pixel, moves work to the cheapest stage, and profiles before optimizing. Does NOT chase visual features without a budget line, hand-optimize unprofiled code, or treat desktop and mobile GPUs as the same machine.

Internalize the cost model first: a **vertex shader** runs per vertex (thousands), a **fragment shader** per covered pixel (millions) — so any computation that interpolates acceptably (fog factors, per-vertex lighting terms, UV animation) moves to the vertex stage for a ~100-1000x invocation discount. Budget in milliseconds, not vibes: at 60 fps the whole frame is 16.6 ms; a full-screen post pass at 1080p touches ~2M pixels, so commonly keep any single full-screen effect under ~0.5 ms and the total post stack under ~2-3 ms, measured with RenderDoc, PIX, Xcode's Metal debugger, or Android GPU Inspector — never with FPS counters. On authoring: **shader graphs** (Unity Shader Graph, Unreal material graphs, Godot visual shaders) are right for artist-owned surface materials and fast iteration; hand-written **HLSL/GLSL** wins for post-processing, anything with loops or branches, and whenever you need to read the generated cost — inspect graph-compiled output, because innocuous nodes can hide dozens of instructions. **Mobile is a different machine**: tile-based GPUs (all Apple, Mali, Adreno) make opaque overdraw partly forgivable but punish three things brutally — **alpha-blended overdraw** (stacked transparent quads are the #1 mobile GPU killer), **dependent texture reads** (UVs computed in the fragment stage defeat prefetch), and mid-pass renderpass breaks (grabbing the framebuffer forces a full tile flush). Prefer half precision (`half`/`mediump`) on mobile — it commonly doubles ALU throughput on Mali/Adreno — and always author a fallback: cap transparent particle layers at ~4 deep on mobile. Also compile-test every variant target early; a shader that works in-editor and fails on device is a shader you never tested. Rule: **No shader work lands without a measured ms cost on the min-spec device — if you can't state what it costs, you can't ship it.**

BAD: "The water looks great on my 4090, ship it" (a 4090 hides a 30x perf gap; the Mali phone hits 11 fps from blended overdraw and dependent reads). GOOD: "Water is 0.8 ms on the min-spec Pixel via AGI capture; refraction moved to vertex-interpolated UVs and blend layers capped at 2."

```
SHADER PLAN
═══════════
Effect: [what] · authoring: [graph/code + why]
Stage split: [per-vertex work] · [per-fragment work]
Budget: [X ms @ min-spec device · resolution]
Mobile flags: [blend layers ≤4 · half precision · no dependent reads]
Variants: [keywords · count kept under control how]
Measured: [tool · device · captured ms]
```

Skip when: using stock engine materials with no custom effects, or building a text/UI app where the GPU is idle anyway.

Gotchas: optimizing instruction counts before capturing a frame — most real costs are bandwidth and overdraw, not ALU; multiplying shader keywords until variant compilation explodes into hours and gigabytes (each boolean keyword doubles variants); branching on a uniform is cheap but branching per-pixel on texture data can serialize warps — know which one you wrote; alpha-tested (clip) materials disable early-Z on many mobile GPUs, quietly re-adding the overdraw you thought you'd avoided.
