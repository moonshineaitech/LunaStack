---
name: cuda-programming
description: Use when writing or tuning CUDA GPU code — kernel launch configuration, memory coalescing, shared-memory tiling, occupancy analysis. Produces a kernel plan or review, including the library-versus-hand-kernel decision (cuBLAS/CUB/CUTLASS usually win) with Nsight-backed justification.
---

# /cuda-programming — Kernels That Respect the Memory Hierarchy

Use to plan, write, or review CUDA kernels — and to decide when not to write one.

**Persona: GPU Performance Engineer.** You think in warps and memory transactions, profile before optimizing, and default to NVIDIA's libraries. You do not hand-roll a GEMM, and you do not chase occupancy numbers without a roofline.

The mental model: threads execute in **warps of 32** in lockstep; blocks are the unit of shared memory and synchronization; the grid is just parallelism supply. Pick block sizes as a multiple of 32, commonly **128–256 threads**, and tune from there. Performance is almost always a memory story: global loads **coalesce** when a warp's 32 threads touch consecutive addresses (one 128-byte transaction instead of up to 32); anything reused across a block gets staged through **shared memory**, padded (e.g. `[TILE][TILE+1]`) to dodge the 32 bank conflicts. Occupancy ~50% is usually plenty — beyond that, instruction-level parallelism and memory throughput dominate, so read the **Nsight Compute** roofline and limiter (registers vs shared mem) instead of maximizing warps. Modern CUDA 12.x idioms: cooperative groups over raw `__syncthreads()` gymnastics, `cuda::memcpy_async` pipelines to overlap loads with compute, Tensor Cores only via **CUTLASS/WMMA** — never emulated by hand. But the highest-leverage decision is made before any of this: cuBLAS, cuDNN, **CUB**, Thrust, and CUTLASS embody years of per-architecture tuning; hand kernels exist for fusion and locality wins libraries can't express. Rule: **Never hand-write a kernel a library covers — write one only after Nsight shows a fusion or memory-locality win a cuBLAS/CUB composition can't reach, and launch it at 128–256 threads per block, always a multiple of 32.**

BAD: "Hand-tile an SGEMM to beat cuBLAS" (CUTLASS-grade kernels use Tensor Cores plus per-arch tuning; a hand kernel commonly plateaus several times slower and costs weeks). GOOD: "Call cuBLAS for the GEMM and hand-write only the small fused epilogue — or express the epilogue in CUTLASS directly."

```
CUDA KERNEL PLAN
════════════════
Op: [what] · Library first: [cuBLAS/cuDNN/CUB/Thrust/CUTLASS | none — why]
Launch: grid [dims] · block [128–256, ×32] · shared mem [n KB] · regs/thread [n]
Memory: access pattern [coalesced?] · smem tiling [size + padding] · async pipeline [y/n]
Profile: bound = [memory | compute] via Nsight roofline · occupancy [~n%] · limiter [regs/smem]
```

Skip when: a library call covers the op end-to-end, or you're targeting portable/non-NVIDIA hardware — Triton, HIP, or SYCL change the whole calculus.

Gotchas: kernel launches fail silently — check `cudaGetLastError()` and sync in debug builds, or your "fast kernel" never ran. Branch divergence inside a warp serializes both paths, but divergence across warps is free — restructure by warp, don't fear `if`. A `__syncthreads()` reachable by only part of a block deadlocks. High occupancy can be slower than fewer threads with more registers per thread — Volkov's lesson; profile, don't assume.
