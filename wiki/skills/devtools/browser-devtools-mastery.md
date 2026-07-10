---
name: browser-devtools-mastery
description: Use when diagnosing a slow, janky, or memory-leaking web page with browser DevTools — performance traces, heap snapshots, network throttling, or debugging minified production code. Produces a reproducible profiling workflow with honest throttling settings and evidence-backed findings instead of guesswork optimization.
---

# /browser-devtools-mastery — Profile Before You Touch a Line

Use to run disciplined DevTools investigations: performance traces, heap-snapshot leak hunts, honest throttling, and source-mapped production debugging.

**Persona: Frontend Performance Investigator.** Forms a hypothesis, records a trace, and names the exact function and milliseconds before proposing any fix. Does NOT optimize from vibes, profile on a dev build, or report unthrottled MacBook numbers as user experience.

Performance panel discipline: profile the **production build** (dev-mode React/Vite bundles are 2–10x slower and lie about hot paths), start recording *before* the interaction, keep traces short (one interaction, a few seconds), and read top-down — Chrome's Performance panel now overlays **LCP/CLS/INP** and long-tasks directly, so anchor on the interaction marker and walk the flame chart under it; anything holding the main thread **>50 ms** is a long task and your INP suspect, and `performance.mark()`/`measure()` plus your framework's tracks (React Profiler lanes) beat squinting at anonymous frames. Throttling honesty is non-negotiable: your dev machine is ~5–10x faster than the median phone, so calibrate with Chrome's CPU-throttling recommendation (commonly ~4–6x for a mid-tier Android) plus "Fast 4G" network, and treat local DevTools numbers as lab data to reconcile against field data (CrUX / your RUM p75) — if lab and field disagree, field wins. Memory leaks: use the **three-snapshot discipline** — snapshot, perform the suspect action ~5 times, snapshot, act 5 more, snapshot — then filter the comparison view for objects whose count grows linearly with actions (detached DOM nodes and listener closures are the usual culprits; check "Detached elements" explicitly). A sawtooth in the memory timeline that returns to baseline after forced GC is churn, not a leak — only a rising post-GC floor across snapshots convicts. For production debugging, ship source maps privately (upload to Sentry-class tooling or serve behind auth via `x_google_ignoreList`-aware builds) and use DevTools' ignore-list to hide framework frames so stacks show your code; logpoints and conditional breakpoints beat redeploying with `console.log`. Rule: **No optimization lands without a before/after trace of the same throttled scenario showing the specific frames that shrank.**

BAD: "Scrolling feels janky — probably React re-renders, let's memoize everything" (unverified guess; the trace often shows a forced synchronous layout or a 300 ms third-party script instead). GOOD: "Record the scroll at 4x CPU throttle: flame chart shows 120 ms `recalculateStyle` from a layout-thrashing loop — batch the reads, re-trace, long task gone."

```
DEVTOOLS INVESTIGATION
══════════════════════
Symptom: [slow load | janky input | rising memory] · Field signal: [CrUX/RUM p75 metric]
Setup: [prod build · 4–6x CPU throttle · Fast 4G · extensions off/incognito]
Trace: [interaction recorded] · Finding: [function · file:line · ms on main thread]
Heap (if leak): [3 snapshots · N actions between · growing class + retainer path]
Fix + proof: [change] · before: [ms/KB] → after: [ms/KB] · same scenario re-traced
```

Skip when: the slowness is server-side (check TTFB first — if it's >800 ms, DevTools' frontend panels aren't your bottleneck), or a Lighthouse pass already names an obvious unshipped basic (no compression, unoptimized images).

Gotchas: profiling with extensions enabled — ad-blockers and password managers pollute traces, use incognito or a clean profile; taking heap snapshots without forcing GC first, then chasing garbage as a "leak"; trusting the Network panel's timings while DevTools is open with cache disabled and calling it the user experience; optimizing a code path the trace shows costs 3 ms while a 400 ms font-blocking request sits unexamined in the same recording.
