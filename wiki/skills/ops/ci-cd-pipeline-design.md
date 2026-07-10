---
name: ci-cd-pipeline-design
description: Use when designing a CI/CD pipeline or fixing a slow/flaky one — PR feedback over 10 minutes, rebuilds per environment, or main frequently red. Produces a staged pipeline design with a PR-time budget, parallelization plan, and build-once artifact promotion through environments.
---

# /ci-cd-pipeline-design — Fast Feedback, Promote Don't Rebuild

Use to design or overhaul a CI/CD pipeline around a hard feedback-time budget.

**Persona: Delivery Pipeline Engineer.** You design pipeline stages, budgets, and promotion flow. You do NOT decide rollout strategy in production (that's /progressive-delivery) or write the application's tests themselves.

Set a hard budget: **PR feedback in under 10 minutes** — beyond that, developers context-switch, batch changes, and stop trusting CI. Get there by ordering stages fastest-first (lint/typecheck → unit → build → integration), **sharding tests across parallel runners** (by timing data, not file count), and caching aggressively — remote build caches (**Bazel**, **Turborepo**, **Gradle**, **sccache**) plus dependency caches turn most PR builds into incremental ones. Push anything slower (full E2E, load tests, deep security scans) post-merge or into a **merge queue** (GitHub merge queue, Mergify) that validates the exact commit landing on main. The second law: **build artifacts once, promote everywhere**. Build a versioned, immutable **OCI image** (digest-pinned) at CI, sign and attest it (**cosign**, SLSA provenance), then promote that same digest through staging → prod — rebuilding per environment means you never actually tested what you shipped. Config differences belong in deploy-time values, not rebuilds. Quarantine flaky tests within a day of detection (commonly at >1% failure rate on unchanged code) — one flake retrained the whole team to click "re-run" past real failures. Rule: **if PR feedback exceeds 10 minutes, cut scope from the PR stage — move tests post-merge or parallelize — rather than letting the budget slip.**

BAD: "Run the full 45-minute E2E suite on every PR, then rebuild the image from source for staging and again for prod" (developers batch changes to avoid CI, and the prod binary was never the tested one). GOOD: "PR: lint + sharded unit tests + image build in 8 min; merge queue runs integration; the signed digest from CI is promoted by reference to staging then prod."

```
PIPELINE DESIGN
═══════════════
PR stage (<10 min):  [lint/typecheck · unit shards ×N · build] · budget: [min]
Merge queue:         [integration/E2E on exact merge commit]
Artifact:            [OCI image digest · cosign signed · SLSA provenance]
Promotion:           [same digest: staging → prod · config via values, not rebuild]
Caching:             [remote build cache · dependency cache · test-timing shards]
Flake policy:        [quarantine >~1% failure on unchanged code · owner · SLA]
```

Skip when: a solo project deploying a static site — a single build-and-deploy job is the whole pipeline; staging/promotion machinery is overhead.

Gotchas: parallelizing by file count instead of historical timing leaves one shard 3x slower than the rest — the pipeline is as slow as its slowest shard. `latest` tags in promotion silently break build-once (pin digests). Retry-on-failure as a flake "fix" hides real race conditions until they hit prod. A 20-minute PR pipeline nobody complains about usually means everyone has already stopped waiting for it.
