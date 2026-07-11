---
name: canvas-webgl-performance
description: Use when building canvas-based visualizations, editors, or games and choosing between Canvas 2D, WebGL, and WebGPU — or when an existing canvas drops frames. Produces a rendering-tier decision, a frame-budget plan (offscreen canvas, dirty rectangles, batching), and context-loss/memory handling requirements.
---

# /canvas-webgl-performance — Pick the Rendering Tier, Then Defend the Frame Budget

Use to choose the right canvas rendering technology for the element count and interaction profile, and to structure the render loop so it survives real hardware.

**Persona: Graphics Performance Engineer.** Sizes the workload, picks the cheapest tier that holds 60fps, and designs the redraw strategy and failure handling. Does NOT reach for WebGPU because it's new, and does not hand-optimize shaders before profiling proves the CPU isn't the bottleneck.

Climb the ladder by live element count and redraw frequency: DOM/SVG comfortably handles up to ~1k interactive nodes (and gives you accessibility and hit-testing free); **Canvas 2D** carries ~1k–10k shapes if you batch paths and avoid per-frame state churn; beyond **~10k elements or any per-frame full redraw**, move to the GPU — **WebGL2** via a scene library (**PixiJS v8**, **Three.js**, **deck.gl**, or **regl**) rather than raw GL, with **WebGPU** as the render backend where available (PixiJS v8 and Three's WebGPURenderer negotiate this; WebGPU is shipped in Chrome/Edge and Safari 26, still flagged-to-recent in Firefox, so always keep the WebGL fallback). On Canvas 2D, the wins are structural, not micro: **dirty-rectangle rendering** (clear and repaint only changed regions — skip it and repaint fully if >~60% of the canvas changes per frame, since tracking overhead exceeds the savings), layered canvases so a static background never repaints, pre-rendering glyphs/sprites to offscreen bitmaps, and moving the whole loop to a worker via **OffscreenCanvas** + `transferControlToOffscreen()` so main-thread jank can't stutter the animation. Budget frames honestly — ~16.7ms at 60Hz, ~8ms on 120Hz displays — and remember `devicePixelRatio` silently multiplies your pixel work 4–9x on retina; render at capped DPR (~2) for dense data viz. GPU contexts are a leased resource: handle `webglcontextlost` (call `preventDefault()`, halt the loop) and `webglcontextrestored` (recreate every texture/buffer — they're gone), and WebGPU's equivalent `device.lost` promise; browsers evict contexts under memory pressure and after ~16 concurrent contexts, so pool or destroy canvases in tabbed UIs. Rule: **At ~10k+ dynamic elements or any full-canvas per-frame redraw, move to WebGL/WebGPU via a batching library; below that, fix Canvas 2D with dirty rectangles and layers before adding GPU complexity.**

BAD: "The scatter plot with 200k points is slow, so loop faster and cache the ctx state in Canvas 2D" (200k `arc()` calls per frame can never fit 16ms — it's a tier problem, not a tuning problem). GOOD: "Move the points to a single instanced draw call in regl/deck.gl, keep axes and labels on a DOM/SVG overlay for accessibility, and repaint the GPU layer only on data or viewport change."

```
CANVAS RENDERING PLAN
══════════════════════════════════
Workload: [N elements] · redraw=[per-frame/on-change] · target=[60/120]fps @ DPR≤[2]
Tier: [DOM-SVG / Canvas2D / WebGL2 / WebGPU+fallback] · Library: [PixiJS v8/Three/deck.gl/regl/none]
Redraw strategy: [dirty-rects / layers / full] · Static layers: [list]
Threading: [OffscreenCanvas worker: yes/no] · Input relay: [pointer events → worker]
Context loss: [lost handler stops loop · restored handler rebuilds N textures/buffers]
Memory caps: [texture budget MB] · [canvas pool size] · Fallback: [tier below / static image]
```

Skip when: the visualization is static or redraws only on user action with <1k elements — plain SVG wins on accessibility, styling, and testability; or you're charting standard forms where Canvas-mode ECharts or Plotly already solves the perf problem.

Gotchas: Measuring FPS on your M-series laptop and shipping jank to mid-range Android — test on a throttled device before declaring the tier adequate; forgetting that OffscreenCanvas workers can't read the DOM, so text metrics, images, and input events all need explicit transfer plumbing designed up front; leaking GPU memory by creating textures per data update instead of updating buffers in place, which works until the tab dies at scale; and skipping context-loss handling because "it never happens locally" — it reliably happens on laptops switching GPUs and mobile Safari under memory pressure, and an unhandled loss renders a permanent blank canvas.
