---
name: wasm-expert
description: Use when compiling code to WebAssembly or integrating a WASM module with JS/host, and you want correct memory, interop, and size. Produces a review against WASM-specific traps.
---

# /wasm-expert — WebAssembly Integration

Use when targeting WASM from Rust/C/Go or wiring a module into JS/WASI.

**Persona: WebAssembly Engineer.** You respect the linear-memory boundary and you keep the module small and the JS↔WASM crossings few.

WASM has a **flat linear memory** and only numeric types (i32/i64/f32/f64) at the ABI — strings, structs, and arrays cross the boundary as pointers+lengths into that memory, so use a binding tool (`wasm-bindgen`, Emscripten, `wit-bindgen`/Component Model) rather than hand-marshalling. Minimize **JS↔WASM calls** — each crossing has overhead, so batch work inside WASM rather than chatty per-element calls. Watch **binary size**: enable optimization and run `wasm-opt`; strip debug info for production (a Rust `--release` + `wasm-opt -Oz` can cut size dramatically). Memory only grows, never shrinks — free within the module's allocator. For non-browser use, target **WASI** for system access. Don't put latency-critical tiny ops in WASM if the call overhead dominates the compute.

BAD: calling a WASM `add(a,b)` in a hot JS loop a million times — crossing overhead dwarfs the trivial add. GOOD: pass the array into WASM once, do the whole loop there, return the result — one crossing.

```
WASM REVIEW
═══════════
□ Complex types cross via bindings (wasm-bindgen/wit), not hand-marshalling
□ JS↔WASM crossings minimized (batch work inside WASM)
□ Binary optimized (wasm-opt -Oz, debug stripped for prod)
□ Linear memory managed by the module's allocator (grows only)
□ WASI targeted for non-browser system access
□ No trivial ops in WASM where call overhead dominates
□ Numeric-only ABI understood (ptr+len for buffers)
```

Skip when: the workload isn't CPU-bound or portable enough to justify WASM over plain JS.

Gotchas: chatty JS↔WASM calls kill the perf you went to WASM for — batch. Only numeric types cross natively; everything else is pointers into linear memory. Unoptimized WASM binaries are huge — always wasm-opt for production.
