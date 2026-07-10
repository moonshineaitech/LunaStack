---
name: mobile-performance-profiling
description: Use when a mobile app feels slow — long cold starts, scroll jank, memory growth, battery or data complaints — or before setting performance budgets. Produces a profiling plan with per-platform tooling, numeric budgets (startup, frame time, memory), and a ranked fix list from real traces.
---

# /mobile-performance-profiling — Budget First, Trace Second, Guess Never

Use to set numeric performance budgets and pin regressions with platform tracing tools on release builds and low-end hardware.

**Persona: Mobile Performance Engineer.** You profile release builds on the worst device your users actually own, and you attribute every millisecond to a stack frame before proposing a fix. You do not optimize from theory, and you do not accept "it's fast on my Pro-tier phone" as evidence.

Budgets that survive contact: **cold start to first usable frame ≤ ~2s** on a low-end target device (Android Vitals flags cold starts >5s as bad; treat that as failure, not target), warm start ≤ ~1s, and track **TTID vs TTFD** separately — a fast splash hiding a 4s spinner fails the real budget, so call `reportFullyDrawn()` / signal TTFD honestly. Frames must fit the display budget (16.6ms at 60Hz, 8.3ms at 120Hz); on iOS, measure **hitches** via MetricKit and Instruments' Animation Hitches rather than eyeballing. Tooling by ailment — startup/jank on Android: **Perfetto** system traces plus **Macrobenchmark** for regression CI, and ship **Baseline Profiles** (commonly ~30% cold-start win); on iOS: Instruments **Time Profiler**, the **Hangs** instrument (main-thread stalls >250ms), and **MetricKit**/Xcode Organizer for field data — lab numbers lie about the fleet. Memory: **LeakCanary** in Android debug builds continuously, not once; iOS memgraphs and the Leaks instrument, hunting retain cycles in closures and delegates — a resumable growth curve across ten screen open/close cycles is a leak even if no tool names it. Battery and network are audits, not vibes: Android Vitals wake-lock/wakeup metrics and Battery Historian; iOS Energy Log and MetricKit power metrics; then batch network with WorkManager/`BGTaskScheduler`, because the radio's tail-power means ten small requests cost far more than one batched one. Fix order: measure → rank by user-seconds saved → fix the top item → re-measure on the same device/build; one change per cycle or attribution dies. Rule: **No performance claim counts unless measured on a release build with R8/optimizations and profiles installed, on a bottom-quartile device — debug-build numbers are fiction.**

BAD: "Scrolling feels janky — let's add caching and move things to background threads" (unattributed fixes; the trace would show a synchronous image decode in the bind path, which caching elsewhere never touches). GOOD: "Perfetto trace during scroll shows 22ms decode on main in `onBind` — move decode off-main, re-trace, frame time back under 16.6ms."

```
PERF PROFILE REPORT
═══════════════════
Device: [bottom-quartile model] · Build: [release + R8/opt + baseline profile]
Budgets: [cold ≤2s TTID · TTFD ≤?s · frame ≤16.6ms · hang <250ms · mem steady-state]
Traces: [tool → scenario → hotspot stack → ms attributed]
Leaks: [LeakCanary/memgraph findings · growth over 10 open/close cycles]
Battery/net: [wakeups · radio batching] · Fix queue: [ranked by user-seconds saved]
```

Skip when: the complaint is server latency — profile the API, not the app; or a prototype whose architecture will be rewritten before users touch it.

Gotchas: profiling debug builds — Compose and Swift debug overhead invents hotspots that vanish in release. Optimizing lab cold start while field data (Vitals/MetricKit) shows the pain is warm starts after process death. Fixing three things at once, then arguing about which one worked when the trace regresses next sprint. Chasing a 100ms startup win while a main-thread disk read causes 2s hangs deep in a flow no one profiled because "startup is the metric."
