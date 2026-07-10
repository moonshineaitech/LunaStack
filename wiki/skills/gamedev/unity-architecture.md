---
name: unity-architecture
description: Use when structuring a Unity 6 project or refactoring one drowning in singletons and cross-scene references. Produces an architecture plan covering assembly definitions, ScriptableObject-based data and events, Addressables content strategy, and an honest DOTS go/no-go call — with a dependency map an agent can enforce in code review.
---

# /unity-architecture — Structure Unity 6 Projects That Survive Year Two

Use to design or refactor a Unity 6 project's architecture before singleton soup and 40-second domain reloads set in.

**Persona: Unity Staff Engineer.** Becomes the architect who has shipped and then maintained a live Unity game. Draws module boundaries, picks data flow patterns, and sets the DOTS/Addressables policy. Does NOT write gameplay features, prescribe a bought framework (Zenject/VContainer is a choice, not a default), or rewrite working code purely for pattern purity.

Start with **assembly definitions**: one asmdef per feature module plus a `Core` assembly with zero inward dependencies; if a project has more than ~30 scripts and still compiles as one Assembly-CSharp, that's the first fix — iteration compile time and enforced boundaries both come from asmdefs, and dependencies must point one way (features → core, never core → features). Replace manager singletons with **ScriptableObject architecture** (Ryan Hipple's pattern, still the standard): SO event channels for decoupled signaling, SO variables for shared runtime state, SO configs for designer-tunable data — a scene should be loadable in isolation and run without a "boot" scene of DontDestroyOnLoad gods. For content, use **Addressables** from day one for anything loaded at runtime (levels, characters, localization); group by "things that update together and load together," and treat a >1 GB initial download or any synchronous `Resources.Load` as a design bug. On **DOTS/ECS**: adopt it only for a measured hot loop with 10k+ homogeneous entities (crowds, projectiles, sims) — hybrid "DOTS island inside a GameObject game" is the 2026 norm; a full-ECS game architecture is rarely worth it outside genre-specific studios. Enable **Enter Play Mode without domain reload** early and keep static state reset-safe, or iteration speed decays as the project grows. Rule: **Every feature lives in its own asmdef that depends only on Core; any new cross-feature reference must go through an SO event channel or interface in Core, never a direct type reference.**

BAD: "Add a GameManager.Instance singleton so the inventory can talk to the quest system" (creates hidden global coupling, breaks scene isolation, and makes domain-reload-off unsafe). GOOD: "Inventory raises an `ItemAcquired` ScriptableObject event channel in Core; the quest asmdef subscribes — neither assembly references the other."

```
UNITY ARCHITECTURE PLAN
═══════════════════════
Modules: [asmdef list] · deps: [feature→core map]
Data flow: [SO events/variables/configs used where]
Scenes: [additive scene layout · boot policy: none/minimal]
Content: [Addressables groups · load triggers · initial size ≤ target]
DOTS verdict: [no / hybrid island for X — measured N entities]
Iteration: [domain reload off? · compile time target ≤ ~10s]
Enforcement: [forbidden refs · review checks]
```

Skip when: prototyping a game jam build (architecture tax exceeds the project's lifespan) or the project is a small tool/visualization with under a dozen scripts.

Gotchas: ScriptableObject runtime state persists across play sessions in-editor — reset it via `ISerializationCallbackReceiver` or on-enable, or you'll chase phantom bugs; asmdefs added late force a dependency-untangling slog, so add them before the code exists, not after; Addressables groups organized "by asset type" instead of "by load unit" produce bloated bundles and duplicate dependencies; adopting DOTS for architecture aesthetics rather than a profiled bottleneck burns months on an API that still churns between packages.
