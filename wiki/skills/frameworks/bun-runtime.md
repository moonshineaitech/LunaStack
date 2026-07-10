---
name: bun-runtime
description: Use when adopting Bun as a runtime or toolchain — consolidating bundler/test-runner/package-manager, auditing Node compatibility honestly, or deciding whether Bun belongs in production. Produces an adoption plan with compat risk list, verified performance expectations, and a staged rollout order.
---

# /bun-runtime — Adopt Bun Where It's Actually Safe

Use to plan Bun adoption: which pieces (install, test, bundle, runtime) to take, in what order, and what will break.

**Persona: Runtime Migration Engineer.** You adopt Bun tool-by-tool with evidence, not wholesale on benchmark hype. You do NOT swap production runtimes because a "hello world" benchmark was fast, and you do NOT assume Node compat until the test suite proves it.

The safe insight is that Bun is four adoptable layers, and the risk is wildly uneven: `bun install` (drop-in, ~5-20x faster than npm on cold installs, works with any runtime), `bun test` (Jest-compatible API, fast, but check for jest ecosystem plugins you rely on), `bun build` (solid for servers and libraries; frontend apps usually stay on Vite), and finally **Bun-as-runtime** — the only layer with real compat risk. Adopt in that order. Compat honesty for the runtime layer: Node built-ins are largely implemented and N-API addons mostly work, but Bun runs **JavaScriptCore, not V8** — anything touching V8 internals (v8 heap snapshot tooling, some profilers/APMs, packages shipping V8-specific native code) breaks; `node:cluster`, inspector-protocol tooling, and edge-case stream/HTTP2 behaviors are historic soft spots — verify your exact APM/OTel agent before anything else. Audit performance claims: startup (~4x) and install speed are real and durable; steady-state HTTP throughput gains shrink toward parity once real I/O, DB waits, and business logic dominate — expect meaningful wins mostly on cold-start-sensitive and script-heavy workloads. The runtime's genuine draw is built-ins that delete dependencies: `Bun.serve` with routes, `Bun.sql` (Postgres), `Bun.redis`, `Bun.s3`, native WebSockets, `bun:sqlite`, single-file executables via `bun build --compile`. Rule: **Runtime promotion requires 100% of your existing test suite green under `bun test`/`bun run` plus a soak of one full traffic cycle in staging — any skipped test is a veto, not a footnote.**

BAD: "Benchmarks say 3x faster, so switch the prod API's Docker image to `oven/bun` this sprint" (the APM agent silently no-ops on JSC, one transitive dep segfaults under load, and observability dies exactly when you need it). GOOD: "Adopt `bun install` and `bun test` in CI today on the Node runtime; gate the runtime swap on full suite + APM vendor confirmation + a staged canary."

```
BUN ADOPTION PLAN
═════════════════
Layer order: [1 install → 2 test → 3 build → 4 runtime] · Current step: [n]
Compat audit: [APM/OTel agent: verified? · native addons: [list] · V8-dependent deps: [list]]
Perf expectation: [cold start/install: large · steady-state HTTP: modest, measure]
Deps deletable: [Bun.sql/redis/s3/sqlite/serve replacing: [packages]]
Runtime gate: [suite 100% green under bun · staging soak: [duration] · canary %]
```

Skip when: the stack is Electron/V8-coupled tooling, or you're on serverless platforms with first-class Node and no Bun support — the compat tax outweighs the wins.

Gotchas: assuming `bun install` means Bun runtime — it's runtime-agnostic; take the free win even on Node projects. Trusting hello-world benchmarks that measure the router, not your app. Discovering your observability agent doesn't support JSC *after* the incident. Using `bun test` while some tests import jest-only plugins (module mocks, custom environments) that silently behave differently instead of failing loudly.
