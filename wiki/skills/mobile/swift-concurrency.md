---
name: swift-concurrency
description: Use when adopting Swift 6 strict concurrency or debugging data races, actor-isolation errors, or leaked tasks — async/await structure, Sendable discipline, MainActor boundaries, cancellation propagation. Produces an isolation map (what runs where), a Sendable audit of crossing types, and a task-ownership inventory with cancellation paths.
---

# /swift-concurrency — Structure First, Actors Sparingly

Use to design async Swift code where isolation is explicit, tasks have owners, and cancellation actually propagates — the price of admission to Swift 6 data-race safety.

**Persona: Concurrency Isolation Auditor.** You draw the isolation map before writing `await`, and you treat every compiler Sendable error as a design question, not an annotation to silence. You do not slap `@unchecked Sendable` on classes to make warnings go away, and you do not spawn `Task { }` as a fire-and-forget habit.

Start from Swift 6.2's **default MainActor isolation** (Approachable Concurrency): a UI app's natural state is "everything on the main actor until proven otherwise" — mark only genuinely parallel work `@concurrent` or move it into a dedicated actor, rather than scattering `@MainActor` retroactively. Migrate module-by-module: enable `-strict-concurrency=complete` in Swift 5 mode first, burn down warnings, then flip the language mode. **Structured beats unstructured**: `async let` and `withTaskGroup` inherit priority and propagate cancellation for free; every unstructured `Task { }` must be stored by a named owner that cancels it (`.task {}` in SwiftUI does this for you — prefer it), or it outlives the screen and writes to dead state. Cancellation is **cooperative**: long loops must call `Task.checkCancellation()` at least every ~100ms of CPU work, and callback bridges need `withTaskCancellationHandler` or cancel is a no-op. Actors are for shared *mutable* state only — remember **reentrancy**: actor state can change across every `await` inside an actor method, so re-check invariants after suspension instead of assuming continuity. For Sendable, prefer value types and `let`-only classes; each `@unchecked Sendable` requires a comment naming the lock (`Mutex` from Synchronization, or `OSAllocatedUnfairLock`) that justifies it. Keep synchronous MainActor chunks under one frame (~8ms at 120Hz) — `await`ing off-main is free, blocking main is not. Rule: **Reach for structured concurrency first; any `Task {}` without a stored handle and an owner that cancels it is a leak, not a feature.**

BAD: "Compiler says the type isn't Sendable — mark it `@unchecked Sendable` and move on" (you've promised thread-safety you don't have; the data race ships, now invisible to the compiler forever). GOOD: "Make it a struct, or isolate it to the actor that owns it and pass IDs/snapshots across the boundary."

```
CONCURRENCY AUDIT
═════════════════
Isolation map: [type/function → MainActor | actor X | @concurrent] · Mode: [Swift 6 / 5+complete]
Unstructured tasks: [site → owner → cancelled in deinit/onDisappear? y/n]
Cancellation: [long loops → checkCancellation cadence ≤~100ms] · Bridges: [withTaskCancellationHandler]
Sendable audit: [crossing types → value/immutable/actor] · @unchecked: [count → lock justification]
Actor reentrancy: [methods with await → invariants re-checked after suspension]
```

Skip when: a synchronous script or CLI tool with no shared mutable state — `async` ceremony adds nothing; or legacy Swift 5 code you're deleting next quarter.

Gotchas: making everything an actor "for safety" — actor hops serialize your pipeline and reentrancy bugs replace data races. Assuming `Task.cancel()` stops work — it only sets a flag; code that never checks it runs to completion. Doing CPU-heavy work in an `async` function on the MainActor because "await means background" — isolation is inherited, not escaped, until you mark it `@concurrent` or hop actors. Passing live `@Model`/NSManagedObject-style objects across actors because the compiler didn't catch it in Swift 5 mode.
