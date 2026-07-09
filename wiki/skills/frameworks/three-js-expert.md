---
name: three-js-expert
description: Use when building or reviewing Three.js / WebGL scenes and you want 60fps rendering without memory leaks or draw-call explosions. Produces a review against Three.js-specific traps.
---

# /three-js-expert — Performant Three.js

Use when building a Three.js scene or reviewing it for performance and leaks.

**Persona: WebGL/Three.js Engineer.** You minimize draw calls and you dispose GPU resources, because the browser won't garbage-collect them for you.

Minimize **draw calls**: each mesh with a unique material is a draw call — merge static geometry (`BufferGeometryUtils.mergeGeometries`) and use **`InstancedMesh`** for many copies of the same object (thousands of trees = one draw call, not thousands). Reuse geometries and materials across meshes. **Dispose GPU resources explicitly** — `geometry.dispose()`, `material.dispose()`, `texture.dispose()` when removing objects; Three.js allocations live on the GPU and are NOT freed by JS garbage collection, so this is the top memory leak. Cap `pixelRatio` (`renderer.setPixelRatio(Math.min(devicePixelRatio, 2))`) — retina at 3x quadruples fragment work. Reuse a single animation loop (`requestAnimationFrame`); don't create objects inside it (allocates every frame). Use appropriate geometry detail (LOD) and compressed textures (KTX2/Basis). Frustum culling is on by default — keep it. Remove event listeners and stop the loop on unmount.

BAD: adding/removing 1,000 individual `Mesh` objects each with its own material every frame and never calling `.dispose()` — draw-call explosion + a GPU memory leak that crashes the tab. GOOD: `InstancedMesh` for the 1,000 copies (one draw call); dispose geometry/material/texture on teardown.

```
THREE.JS REVIEW
═══════════════
□ Draw calls minimized: merged geometry / InstancedMesh for repeats
□ Geometries/materials reused across meshes
□ dispose() geometry+material+texture on removal (GPU leak otherwise)
□ pixelRatio capped (min(dpr, 2))
□ Single rAF loop; no per-frame object allocation
□ LOD + compressed textures (KTX2) for heavy scenes
□ Listeners removed + loop stopped on unmount
```

Skip when: a static single-mesh scene where perf isn't a concern.

Gotchas: Three.js GPU resources are NOT freed by JS GC — you must `dispose()` or leak VRAM. Many unique-material meshes explode draw calls; instance/merge them. Allocating objects inside the render loop causes per-frame GC pressure and jank.
