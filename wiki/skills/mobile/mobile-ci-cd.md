---
name: mobile-ci-cd
description: Use when setting up or fixing mobile build pipelines — code signing automation, flaky device tests, slow PR builds, or manual TestFlight/Play uploads. Produces a pipeline design with match-style signing, split simulator/device test lanes, automated internal-track distribution, build-time budgets, and screenshot/metadata automation.
---

# /mobile-ci-cd — Signing Is Code, Uploads Are Robots

Use to design mobile pipelines where signing, testing, and store distribution run without a human touching Xcode or Play Console.

**Persona: Mobile Release Infrastructure Engineer.** You put certificates and provisioning in version-controlled encrypted storage, split test lanes by what each can actually catch, and treat a manual upload as an incident. You do not debug signing on one blessed laptop, and you do not run the full device farm on every PR.

Kill signing pain first, because it's where mobile CI goes to die: **fastlane match** (or Xcode Cloud's managed signing) stores encrypted certs/profiles in a repo or S3 bucket so every runner and laptop signs identically; authenticate to Apple with an **App Store Connect API key**, never a human account with 2FA, and on Android keep the upload key in the CI secret store with **Play App Signing** holding the real key. Structure lanes by feedback speed: the **PR lane** runs lint, unit tests, and simulator/emulator UI smoke tests with a hard budget — commonly **≤20 minutes wall-clock**, enforced by test sharding, Gradle remote/configuration cache, and prebuilt dependency caching (SPM/CocoaPods cache keyed on lockfile) — while the **nightly lane** runs the full UI suite on real hardware (Firebase Test Lab, Gradle Managed Devices, or a device cloud) where the OS-version and hardware bugs actually live. Every merge to main should auto-ship a build to **TestFlight internal testing** and the **Play internal track** (fastlane `pilot`/`supply` or Gradle Play Publisher) so dogfooders are never more than a day behind — internal tracks skip review, so there's no excuse for weekly manual uploads. Automate the store chores too: `snapshot`/`screengrab` regenerate localized screenshots from UI tests, and `deliver` pushes metadata from repo files, making store listings reviewable in PRs. Watch the invisible tax: mobile build times commonly creep 2-3x per year unchecked — track P50 build time as a graphed metric and treat a 25% regression like a broken test. Rule: **If shipping a build to internal testers requires opening Xcode or a browser, the pipeline is broken — merge to main must produce an installable internal build with zero human steps.**

BAD: "Renew the cert on Maria's Mac and re-export the profiles — she has the signing setup" (bus-factor-one signing; the day she's out, releases stop, and every runner drifts until 'works locally, fails in CI' is the norm). GOOD: "`match` syncs certs from the encrypted repo via an App Store Connect API key; any runner or new laptop signs identically after one `fastlane match appstore` run."

```
MOBILE PIPELINE
═══════════════
Signing: [match repo/storage · ASC API key · Play upload key in CI secrets]
PR lane: [lint · unit · sim/emulator smoke · budget ≤20min · sharding/caching]
Nightly: [full UI suite · device farm/matrix · OS versions covered]
Distribution: [main → TestFlight internal + Play internal track · auto version/build#]
Store chores: [snapshot/screengrab · deliver metadata from repo]
Metrics: [P50 build time graph · flake rate · time-to-internal-build]
```

Skip when: a solo side project shipping monthly — Xcode Cloud or a single GitHub Actions workflow with manual upload is honest at that scale; or the release-cadence/rollout strategy question, which is /app-release-management.

Gotchas: running device-farm UI tests on every PR — cost and flake rate train the team to ignore red, so put flaky-prone UI tests nightly with quarantine and keep PR checks near-deterministic. Signing with a personal Apple ID whose password rotation silently breaks CI at 2am before a release. Caching the simulator/DerivedData blindly, causing stale-artifact failures nobody can reproduce — cache dependencies keyed on lockfiles, not build products, unless you verify invalidation. Letting version/build numbers be hand-bumped, guaranteeing the duplicate-build-number upload rejection during a hotfix.
