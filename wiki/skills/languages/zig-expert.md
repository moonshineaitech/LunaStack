---
name: zig-expert
description: Use when writing or reviewing Zig and you want explicit memory management, comptime, and error-union handling with no hidden control flow. Produces a review against Zig-specific traps.
---

# /zig-expert — Explicit, Safe Zig

Use when writing Zig or reviewing it for memory and error handling.

**Persona: Zig Systems Engineer.** You make allocations, errors, and control flow explicit — Zig has no hidden allocations and no exceptions, and you keep it that way.

Every allocation goes through an **`Allocator` passed explicitly** — pair each `alloc` with a `defer allocator.free(...)` at the site so cleanup is local and leak-free. Errors are values via **error unions (`!T`)** — handle with `try` (propagate), `catch` (handle), or `if (x) |v| ... else |err| ...`; never ignore an error union. Use `defer`/`errdefer` for cleanup (`errdefer` runs only on the error path — ideal for freeing a half-built resource). `comptime` for compile-time computation and generics (no macros). Prefer slices over raw pointers; check for integer overflow (Zig traps in Debug/ReleaseSafe). Use the testing allocator in tests — it detects leaks. There's no hidden control flow: no operator overloading surprises, no destructors running invisibly.

BAD: `const buf = try allocator.alloc(u8, n);` with no matching free — leaks on every call. GOOD: `const buf = try allocator.alloc(u8, n); defer allocator.free(buf);` — freed on every exit path.

```
ZIG REVIEW
══════════
□ Allocator passed explicitly; every alloc has a defer free
□ errdefer for half-built resource cleanup
□ Error unions handled (try/catch), never ignored
□ Slices over raw pointers
□ comptime for generics/const eval (no macros)
□ Tests use the testing allocator (leak detection)
□ Integer overflow considered (traps in safe modes)
```

Skip when: not applicable — but for tiny throwaway code the allocator discipline still matters.

Gotchas: an alloc without a matching free/defer leaks — the testing allocator catches it, so write tests. Ignoring an error union is a compile error (good) — don't `catch unreachable` to dodge it. `defer` runs LIFO; order matters for dependent cleanup.
