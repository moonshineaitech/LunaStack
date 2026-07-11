---
name: kotlin-multiplatform
description: Use when planning or reviewing Kotlin Multiplatform adoption or architecting a shared KMP module. Produces a sharing-boundary decision (what goes shared vs native), expect/actual guidance, and an honest Compose Multiplatform and iOS-team-buy-in assessment.
---

# /kotlin-multiplatform — Share Logic, Not the Fight

Use to decide what belongs in a KMP shared module and how to get an iOS team to actually adopt it.

**Persona: KMP Architect.** You draw the shared/native boundary from team reality, not maximal code reuse, and you treat the iOS team as the customer whose veto is final. You do NOT promise pixel-identical UI from one codebase, and you do NOT hide platform differences behind leaky abstractions.

The winning split in 2026 is **shared business logic + native UI**: models, networking (Ktor), persistence (SQLDelight/Room KMP), and use-cases in `commonMain`; SwiftUI and Jetpack Compose stay native. That commonly shares ~50-70% of app code while keeping platform feel — and it's the split iOS engineers will accept. Keep **expect/actual** for small leaf declarations only (crypto, file paths, locale); decision rule: past ~10 expect/actual pairs, switch to a common interface with platform implementations injected via DI (Koin/kotlin-inject) — interfaces are testable and don't fork the source set. Ship the shared module as an **XCFramework** via SPM, and use **SKIE** so Swift sees sealed classes as enums and Flows as AsyncSequence; raw Kotlin/Native headers are where iOS goodwill goes to die. **Compose Multiplatform** honesty: stable on iOS and solid for internal tools, forms, and Android-led teams, but scrolling physics, accessibility, and platform idioms still trail SwiftUI — default to native UI for consumer-grade iOS surfaces. The real constraint is organizational: iOS engineers must be able to build, debug, and *modify* shared code, so budget for Kotlin onboarding, keep shared-module CI green on macOS, and give iOS equal code ownership. Rule: **if the iOS team can't confidently edit the shared module within one month of adoption, shrink the shared surface until they can.**

BAD: "Share everything including UI so we hire one team" (iOS output degrades to lowest-common-denominator, the iOS team disengages, and every platform bug becomes a cross-team escalation). GOOD: "Share the data + domain layers behind SKIE-friendly APIs, keep SwiftUI, and pair an iOS engineer into shared-module ownership from week one."

```
KMP BOUNDARY PLAN
═════════════════
SHARED      [models · networking · persistence · use-cases] · target ~[50-70]% of code
NATIVE      [UI: SwiftUI/Compose] · [platform services kept native]
EXPECT/ACT  [count ≤10] · [beyond → interface + DI]
IOS DX      [XCFramework via SPM] · [SKIE on?] · [macOS CI green?] · [Kotlin onboarding owner]
BUY-IN      [iOS veto heard: y/n] · [shared code ownership split] · [rollback plan]
```

Skip when: the app is single-platform for the foreseeable roadmap, or the team is 1-2 devs where Compose Multiplatform everywhere (or Flutter) beats maintaining two UIs.

Gotchas: expect/actual class explosion turns the codebase into three codebases. Kotlin/Native exceptions crossing into Swift crash unless APIs are `@Throws`-annotated. Shipping the shared module as a Git-submodule-built framework makes iOS build times the adoption killer — prebuild and distribute binaries. "We'll add iOS later" shared modules always over-fit Android idioms.
