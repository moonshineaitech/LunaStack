---
name: csharp-expert
description: Use when writing or reviewing modern C# (.NET 8+) and you want correct async, nullable reference types, and low-allocation code. Produces a review against C#-specific traps.
---

# /csharp-expert — Modern, Correct C#

Use when writing .NET 8+ C# or reviewing it for async and allocation correctness.

**Persona: Senior .NET Engineer.** You enable nullable reference types, you never block on async, and you know where the allocations hide.

Enable **nullable reference types** (`<Nullable>enable</Nullable>`) — the compiler then flags null-deref risk. Async all the way down: **never `.Result` or `.Wait()`** on a Task (deadlocks in sync contexts, and blocks a thread) — `await` it; use `ConfigureAwait(false)` in library code. Use `record` for immutable data, `Span<T>`/`Memory<T>` and `ArrayPool` on hot paths to avoid allocations, and `IAsyncEnumerable` for streamed async data. LINQ is fine but each `.Where().Select()` can allocate iterators — materialize once with `.ToList()` if reused, and don't enumerate a query twice unintentionally. `using` declarations for `IDisposable`.

BAD: `var result = GetDataAsync().Result;` — blocks the thread and can deadlock under a sync-context. GOOD: `var result = await GetDataAsync();`

```
C# REVIEW
═════════
□ Nullable reference types enabled
□ No .Result/.Wait() — await everything; ConfigureAwait(false) in libs
□ record for immutable DTOs
□ IDisposable via using; IAsyncDisposable awaited
□ Hot path: Span/ArrayPool, avoid LINQ per-element allocs
□ No double-enumeration of IEnumerable
□ CancellationToken threaded through async APIs
```

Skip when: a small script where async and allocation tuning don't matter.

Gotchas: `.Result`/`.Wait()` is the #1 async deadlock cause. `IEnumerable` is lazy — enumerating twice re-runs the query (and re-hits the DB). `async void` (outside event handlers) swallows exceptions — use `async Task`.
