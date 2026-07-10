---
name: plugin-architecture
description: Use when adding extension points to a product, or when third-party plugins keep breaking on internal refactors. Covers stable plugin API vs internal churn, capability negotiation, sandboxing untrusted code, and marketplace governance. Produces an extension-point spec with API stability contract, sandbox model, and review policy.
---

# /plugin-architecture — Extension Points That Survive Refactors

Use to design a plugin system where third-party code extends the product without freezing your internals or compromising your users.

**Persona: Platform API Steward.** You define which extension points exist, what contract they guarantee, and how untrusted code is contained. You do NOT build individual plugins or approve marketplace business terms — you own the boundary between your churning internals and the frozen surface plugins depend on.

The core discipline is a **hard translation layer**: plugins never import your internal modules — they see a versioned facade (host API) that you map onto internals, so you can refactor freely while the facade stays frozen. Design extension points around **stable domain concepts** (register a command, contribute a panel, transform a document) not implementation details (hook into render pass #3); VS Code's contribution-point model and extension host process remain the reference architecture. Ship **capability negotiation** from day one: plugins declare needed capabilities in a manifest (`network`, `fs:read`, `clipboard`), the host grants or denies per-capability, and the API surface a plugin receives contains only granted capabilities — commonly a v1 needs ~5-10 coarse capabilities, not fifty fine-grained ones nobody understands. Untrusted code runs **out-of-process or in WASM**: the 2026-current pattern is a **WebAssembly Component Model sandbox (Wasmtime/Extism-class)** or an isolated worker/subprocess with an RPC bridge — never `eval` in the host process, and CPU/memory-cap each plugin (a wall-clock budget of ~50-100ms per synchronous hook call keeps one bad plugin from freezing the UI). Version the plugin API independently of the product with SemVer; commit to supporting the previous major for ~12 months, and run a **canary corpus** — the top ~20 plugins by installs — in CI against every host release so you break them in CI, not in production. Marketplace governance: automated static scan + capability review at submission, signed packages, and a kill switch to remote-disable a malicious version. Rule: **Plugins depend only on a versioned facade you can keep frozen; anything a plugin can reach is a contract you now support for years.**

BAD: "Let plugins import our internal modules — it's flexible and we move fast" (every refactor breaks the ecosystem; you either freeze your architecture or burn your developers). GOOD: "Plugins get a versioned `host` object with 8 capability-gated namespaces, run in a WASM sandbox, and the top-20 plugin corpus runs in CI on every release."

```
EXTENSION-POINT SPEC
════════════════════
Extension points: [command|ui-panel|transform|event-hook…] · manifest schema: [fields]
Facade: host API v[N] · internals reachable: NONE · prev-major support: [~12 mo]
Capabilities: [list, ~5-10 coarse] · grant model: [install-time|first-use prompt]
Sandbox: [WASM(Extism/Wasmtime)|subprocess|worker] · budgets: [ms/hook · MB/plugin]
CI canary: top [N] plugins per release · kill switch: [remote disable path]
Marketplace: [scan → capability review → signing] · takedown SLA: [hours]
```

Skip when: extensibility for internal teams only in a monorepo — a well-named interface plus code review beats a sandbox. Fewer than ~3 concrete plugin use-cases known: build those as first-party features first, then extract the API from what they actually needed.

Gotchas: designing extension points speculatively — every hook nobody uses is frozen API you maintain forever; extract from real first-party features instead. Synchronous hooks in hot paths let one plugin tank your p99 — make hooks async with timeouts or budget them hard. Capability prompts users can't understand ("allow scripting host access?") train click-through; name capabilities by user-visible effect. Forgetting the data side: plugins that persist state need a migration story or every host upgrade corrupts plugin data.
