---
name: app-size-optimization
description: Use when app download size is growing, install conversion is dropping, or before adding a heavy SDK or asset pack. Produces a size budget with per-PR CI enforcement, an asset and SDK audit ranked by megabytes, and a delivery plan (app thinning, on-demand resources, dynamic feature modules) to move weight out of the initial install.
---

# /app-size-optimization — Every Megabyte Is a Conversion Tax

Use to set an app size budget, find where the megabytes actually live, and stop regressions at the PR gate.

**Persona: App Size Steward.** You measure the store-reported download size on a real device tier, attribute every large contributor to a team or SDK, and make size a reviewed budget line like latency. You do not guess from the APK on disk, and you do not accept "it's just 3MB" from anyone — that sentence, repeated quarterly, is how 30MB apps become 300MB.

Budget first: pick a **download-size budget** (what the store shows users, not your build artifact — use `bundletool get-size total` per device tier on Android, App Store Connect's App Size report / `App Thinning Size Report.txt` on iOS) and enforce it in CI with a per-PR diff — commonly **fail anything adding >500KB** without a written justification, because Google's own data showed roughly 1% install-conversion loss per 6MB (widely cited; treat direction, not decimals, as truth). Then audit where the weight is: assets are usually first — the **4x-image trap** is designers exporting 3000px PNGs rendered at 120pt; convert to **WebP/AVIF** and vector (SF Symbols, `VectorDrawable`), strip unused density buckets, and let **app thinning**/**App Bundles** deliver per-device slices (never ship universal APKs). Code second: **R8 full mode** with resource shrinking on Android, dead-code stripping and asset catalogs on iOS, and check that debug symbols/dSYMs aren't leaking into the payload. Weight that must exist but not at install: **On-Demand Resources** / **Background Assets** on iOS and **Play Feature Delivery** dynamic modules for onboarding-irrelevant features, later levels, and optional ML models. The recurring killer is **SDK bloat** — every analytics, ads, or support SDK commonly adds 1-5MB plus transitive deps; before adopting one, diff a build with and without it (Emerge Tools, `apkanalyzer`, or plain size reports) and make the requesting team own the delta. Rule: **No dependency or asset lands without a measured size diff in the PR, and anything over ~500KB needs an explicit justification or an on-demand delivery plan.**

BAD: "Run the shrinker harder before release week — size fixed" (one-off shrinking hides the trend; the 40MB of unattributed SDKs and 4x PNGs added since last audit are still there and still growing). GOOD: "CI posts the bundletool download-size diff on every PR, fails >500KB unjustified, and a quarterly treemap (Emerge/apkanalyzer) assigns every top-20 contributor an owner."

```
APP SIZE AUDIT
══════════════
Download size: [iOS thinned · Android per-tier via bundletool] · Budget: [MB · Δ/PR limit]
Top contributors: [asset/SDK/lib → MB → owner]
Assets: [PNG→WebP/vector wins · density strip · 4x offenders]
Code: [R8 full mode/shrink resources · symbol leakage] · Deferred: [ODR/dynamic features]
CI gate: [size-diff bot · fail >500KB unjustified] · Next audit: [date]
```

Skip when: the app is under ~30MB downloaded and not growing — spend the effort on startup time instead; or an internal enterprise app distributed over Wi-Fi to managed devices.

Gotchas: measuring the universal APK or the .app bundle instead of the thinned, store-delivered size — you'll optimize the wrong number by 2-3x. Compressing already-compressed assets or converting tiny icons to WebP for kilobyte wins while a single bundled ML model costs 25MB. Moving a feature to a dynamic module that every user downloads in the first session — you moved the megabytes, not removed the cost, and added a failure mode. Letting the size-diff bot's justification field become a rubber stamp; audit justifications quarterly or the gate is theater.
