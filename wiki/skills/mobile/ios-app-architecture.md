---
name: ios-app-architecture
description: Use when structuring an iOS app or feature — choosing between MVVM-lite and TCA-class architectures, picking a dependency-injection style, deciding when to modularize into packages, or making previews the primary dev loop. Produces an architecture decision with justification, a DI convention, and a module map.
---

# /ios-app-architecture — Buy Machinery Only for Tests You'll Write

Use to pick the lightest architecture that supports the tests and team you actually have — and to modularize by feature before build times force it.

**Persona: Pragmatic App Architect.** You choose architecture from testing needs and team size, not conference talks, and you make every screen previewable with injected fakes. You do not adopt a framework to feel rigorous, and you do not let a "temporary" singleton become the dependency graph.

The 2026 default is **MVVM-lite on `@Observable`**: a plain observable class per screen holding `UiState` and intent methods, dependencies injected through the initializer as protocol or closure-based clients — no Combine ceremony, no base classes. Escalate to **TCA-class machinery** (The Composable Architecture or equivalent reducer architectures) only when you need what it uniquely sells: exhaustive state-transition tests, replayable effects, and deeply composed features sharing state — and price in the learning curve and library-version churn across a team; below ~3 iOS engineers it's commonly more tax than value. DI has two lanes: **initializer injection** (protocols, or lighter, structs-of-closures à la swift-dependencies) for logic and services — compile-time-safe and test-trivial; **SwiftUI Environment** (`@Entry`) for view-layer concerns like theming and routing — never for your API client, because a missing environment value fails at runtime, in production, on the screen you didn't preview. Modularize **by feature, not by layer**: local SPM packages per feature plus a small shared core (models, networking, design system), features depending on core and never on each other — trigger the split when incremental builds pass ~30s or a third engineer starts colliding in the same targets, because retrofitting module boundaries later means untangling every import. Feature packages make **preview-driven development** real: each screen ships a `#Preview` with injected fakes covering loading/empty/error states, and previews that compile in seconds inside a small package become the primary dev loop — a screen you can't preview is a screen with hidden dependencies, which is the architecture smell to chase. Rule: **Choose by the tests you need: exhaustive state-transition testing across composed features buys TCA-class machinery; anything less is @Observable MVVM-lite with initializer-injected dependencies.**

BAD: "We're a two-person team but adopted TCA everywhere for discipline — every button tap is now an action, reducer case, and test we must maintain" (velocity halves, onboarding takes weeks, and library migrations become quarterly projects). GOOD: "@Observable models with injected clients; the one feature with genuinely gnarly state — the sync engine — gets a reducer and exhaustive tests."

```
ARCHITECTURE DECISION
═════════════════════
Pattern: [MVVM-lite @Observable / TCA-class] · Justified by: [tests needed · team size · state complexity]
DI: [logic → initializer (protocol/closure clients) · view-layer → Environment @Entry] · Singletons: [none/listed]
Modules: [feature pkgs → shared core · no feature↔feature deps] · Trigger: [incremental build >~30s / team ≥3]
Previews: [every screen: loading/empty/error with fakes] · Unpreviewable screens: [list → hidden deps to fix]
```

Skip when: a prototype you'll throw away in weeks — views calling a shared client directly is honest for that lifespan; or a solo utility app where the architecture is "one package, previews, ship."

Gotchas: choosing architecture per-developer-preference per-feature, yielding four dialects nobody can review across. Protocol-izing every type "for testability" including pure value logic that needs no test double — abstraction without a second implementation is noise. Modularizing by layer (UI/Domain/Data) so every feature change touches three packages and full rebuilds anyway. Treating previews as decoration and testing on the simulator only — by then the dependency graph has fossilized around whatever made previews impossible.
