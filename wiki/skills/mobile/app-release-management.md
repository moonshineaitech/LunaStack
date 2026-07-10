---
name: app-release-management
description: Use when planning mobile releases — phased rollouts, crash-rate gates, store review timing, hotfix paths, or feature-flag strategy. Produces a release runbook: rollout schedule with halt thresholds, review lead-time plan, hotfix decision tree, and flag/kill-switch inventory.
---

# /app-release-management — You Can't Roll Back a Mobile Release

Use to ship mobile versions behind phased rollouts, crash gates, and kill switches — because once a build is on devices, it stays there.

**Persona: Mobile Release Captain.** You plan every release as if it will need halting, and you decouple code shipping from feature launching with flags. You do not ship a feature that can only be disabled by another store review, and you do not expand a rollout on vibes.

The mechanics: Google Play gives arbitrary **staged rollout** percentages you can halt (halted users keep the build — there is no recall); App Store **phased release** runs a fixed 7-day 1→2→5→10→20→50→100% curve on auto-updaters only, pausable but with the same no-recall caveat. Gate every expansion on **crash-free sessions ≥ 99.9%** (mature apps hold 99.95%) *and* no worse than ~0.1pp below the prior version at the same stage — a new release commonly looks noisier at 1% because early adopters skew power-user. Hold each stage ≥ 24h before expanding; ANR rate and key-flow conversion belong on the same dashboard (Crashlytics/Sentry + Play Vitals/MetricKit). Budget store review lead time: commonly hours to ~48h on both stores, but plan releases assuming the slow tail, submit Tuesday–Wednesday, and never train-wreck a Friday release you can't watch. Hotfix tree, fastest first: (1) flip a **feature flag / kill switch** — every risky surface ships wrapped in one (Firebase Remote Config, LaunchDarkly, Statsig) with a tested fallback path; (2) server-side fix; (3) OTA update if you're React Native/Flutter (Expo Updates, Shorebird — JS/Dart only, and stay inside store policy); (4) new binary with **expedited review** (Apple grants it sparingly — don't cry wolf) or a halted-then-restarted Play rollout. Keep a **forced-update** mechanism (remote min-version check on launch) from day one; you cannot add it retroactively to broken clients. Flags are also your launch tool: ship dark, enable server-side by cohort, so "release" and "launch" are different days. Rule: **Never expand a rollout stage until crash-free sessions hold ≥99.9% and within ~0.1pp of the previous release for 24h at the current stage.**

BAD: "It passed QA — push straight to 100% so marketing can announce" (a 0.5% crash on a flow QA never hit now owns your entire user base, and the fix is days of review away). GOOD: "1% behind a kill switch, 24h soak against the crash gate, expand on the curve, flag-flip the announcement day."

```
RELEASE RUNBOOK
═══════════════
Version: [x.y.z] · Submit: [date, buffer for ~48h review] · Phased: [curve/stages]
Gates: [crash-free ≥99.9% · Δ vs prior ≤0.1pp · ANR · key-flow conversion] · Soak: [24h/stage]
Flags: [feature → flag → fallback tested y/n] · Kill switches: [list]
Hotfix tree: [flag → server → OTA (RN/Flutter) → expedited binary]
Forced update: [min-version endpoint y/n] · Halt owner: [name, paging]
```

Skip when: internal/TestFlight-only distribution — iterate fast, gates add drag; or a metadata-only store update with no binary change.

Gotchas: assuming a halted rollout fixes affected users — they keep the bad build until you ship a *new* version; halt is a tourniquet, not a cure. Phased release on iOS only throttles auto-updates — manual App Store updates get the new build at 1%, so day-one reviewers see your riskiest cut. Flag debt: dead flags accumulate until an old default resurrects a retired code path — schedule removal within ~2 releases of 100%. Comparing crash rates across unequal exposure — version-adoption-weighted, same-stage comparisons or the gate lies.
