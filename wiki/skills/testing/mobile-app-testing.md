---
name: mobile-app-testing
description: Use when a mobile app (iOS/Android/React Native/Flutter) needs automated UI testing or the existing device suite is flaky and slow. Designs the emulator-vs-real-device matrix, picks the right driver tier (Maestro, Appium, XCUITest/Espresso, Detox/Patrol), controls mobile-specific flake, and covers deep links, permissions, and lifecycle events. Produces a device matrix, suite architecture, and flake-control checklist.
---

# /mobile-app-testing — Device Testing Without the Flake Spiral

Use to build a mobile UI test suite with a deliberate emulator/real-device split and mobile-specific flake controls baked in from day one.

**Persona: Mobile Test Automation Lead.** Chooses the cheapest driver that reaches the behavior under test, budgets real-device minutes like money, and treats every flaky test as a defect with a root cause. Does NOT run the full suite on a 20-device cloud matrix per PR, and does not sleep()-and-pray around async UI.

Pick drivers by layer, not fashion: **Maestro** (declarative YAML flows, built-in tolerance for async UI) or native **XCUITest/Espresso** for speed and stability; **Appium 2** with UiAutomator2/XCUITest drivers when you need cross-platform reach, WebView contexts, or vendor-cloud integration (BrowserStack/Sauce/Firebase Test Lab); **Detox** or Flutter's **Patrol/integration_test** for gray-box RN/Flutter suites. Structure the matrix as a pyramid: PRs run the smoke suite on 1-2 emulators/simulators (pinned OS images, cold-booted from snapshots — commonly under ~15 minutes wall-clock); nightly runs the full suite on emulators plus ~3-5 real devices chosen from your analytics' top OS-version × manufacturer cells (always include one low-RAM Android and the oldest OS you support); real devices exist to catch what emulators can't — thermal throttling, OEM skins (Samsung/Xiaomi permission dialogs), real push, camera/biometrics — not to re-run everything. Flake control is mostly determinism engineering: disable animations (`adb shell settings put global *_animation_scale 0`, simulator reduce-motion), use idling/synchronization (Espresso idling resources, Detox sync, Maestro's auto-wait) instead of hard sleeps, stub network at the boundary, reset app state per test (`fastboot`-fresh emulator snapshots beat uninstall/reinstall), and quarantine any test that fails twice in 50 runs until fixed. Cover the mobile-only surface explicitly: **deep links** (cold-start vs warm-start via `adb shell am start -W -a android.intent.action.VIEW` and `xcrun simctl openurl`, plus deferred links post-install), **permission flows** (grant, deny, deny-twice/"don't ask again", revoke-while-running via appops), and **lifecycle** (backgrounding mid-flow, process death restore, rotation). Rule: **Run PRs on pinned emulators only and reserve real devices for a nightly top-5-device matrix — a real-device-per-PR policy buys 10x cost and flake for coverage the nightly already gives you.**

BAD: "Full Appium suite on 15 BrowserStack devices per PR with sleep(5) after every tap" (hours of queue time, sleeps mask sync bugs, and OEM quirks make half the failures unreproducible — the team starts ignoring red). GOOD: "Maestro smoke on 2 pinned emulators per PR in ~12 minutes, nightly full run on 5 analytics-chosen real devices, zero hard sleeps, flaky tests quarantined within a day."

```
MOBILE TEST MATRIX
══════════════════════════════════════════
DRIVERS: [smoke: Maestro/native] · [cross-platform: Appium 2] · [gray-box: Detox/Patrol]
PR TIER: [n emulators · OS images pinned · target ≤15 min]
NIGHTLY TIER: [real devices: model×OS from analytics · incl. low-RAM + oldest OS]
FLAKE CONTROLS: animations off · sync not sleep · network stubbed · state reset via [snapshot]
MOBILE-ONLY COVERAGE: deep links [cold/warm/deferred] · permissions [grant/deny/never/revoke] · lifecycle [bg/kill/rotate]
```

Skip when: the app is a thin WebView shell — test the web app with Playwright and keep only a handful of native-shell smoke flows; or pre-launch with one target device, where manual exploratory testing outruns automation setup.

Gotchas: emulators pass while Samsung/Xiaomi devices fail on OEM permission dialogs and aggressive battery killers — if Android matters, one Samsung in the nightly matrix is non-negotiable; testing deep links only from a warm app misses the cold-start crash class entirely; shared cloud devices leak state (leftover accounts, granted permissions) so never assume a clean slate; and iOS simulator "passes" for push and camera flows are vacuous — simulators can't exercise them, so those tests silently assert nothing.
