# Skill Wiki — Build Roadmap

The build plan for the verified skill library. Skills are generated in
**draft → adversarial-verify → structural-validate** waves; only skills that
pass both gates are committed. See [README.md](README.md) for how the library
is organized and [INDEX.md](INDEX.md) for the live, generated catalog.

**Status:** 380+ verified wiki skills across 23 domains (see INDEX.md for the
exact live count — it's generated, this file is narrative). All skills pass
`tests/validate_wiki_skills.sh`; the 100-skill health domain additionally
passes the `tests/validate_health_skills.sh` safety gate.

---

## Completed waves

| Wave | Scope | Skills | Landed |
|---|---|---:|---|
| 1 | Infra/backend/data/AI/security gaps | 40 | ✓ |
| 2 | Language experts | 39 | ✓ |
| 3 | Frameworks & libraries | 25 | ✓ |
| 4 | Testing & QA core | 8 | ✓ |
| 5 | Cloud & DevOps core | 8 | ✓ |
| H1–H7 | **Personal health** (safety-gated) — tracking, visits, clinical action, condition management, prevention, life stages, emergency readiness, home diagnostics | 100 | ✓ |
| G1 | **Gamedev** incl. health×games safety (LunaCelsus) | 9→16 | ✓ |
| F1 | 14-agent fleet: frontend/ai/security/data/ops/backend/mobile/design/growth/product/engineering/cloud | 86 | ✓ |
| F2 | 10-agent fleet: testing/databases/architecture/devtools/docs/leadership/business + gamedev/frameworks/ai expansion | 64 | ✓ |

## Organization (post-reorg)

- `testing/` split out of `engineering/` (engineering keeps process skills).
- New domains: `mobile`, `databases`, `architecture`, `devtools`, `docs`,
  `leadership`, `business`, `testing`.
- Grouping: **Build** (languages/frameworks/frontend/backend/mobile/gamedev/ai) ·
  **Run** (cloud/ops/databases/data/security/testing) · **Design & decide**
  (architecture/design/docs/devtools/engineering) · **Grow & lead**
  (product/growth/business/leadership) · **Live** (health).

## Remaining frontier (next waves)

- **Per-vendor/version depth**: `react-19-patterns`, `next-app-router-deep`,
  `postgres-17-features` — drawn from [../registries.md](../registries.md).
- **Testing & QA tier 2**: fuzz-testing, visual-regression, api-mocking,
  bdd-cucumber, appium-mobile, coverage-strategy.
- **AI/ML tier 2**: rlhf/dpo-alignment, model-serving (vLLM-class), gpu
  optimization, feature stores, experiment tracking, drift detection.
- **Domain-specialized**: fintech-compliance, payments-pci, geospatial-gis,
  webrtc-media, crdt-collaboration, browser-extensions, sdk-design,
  plugin-architecture, open-source-governance.
- **Health tier 2** (all safety-gated): condition-specific adherence packs
  (COPD, heart-failure daily weights, epilepsy seizure logs), accessibility &
  disability navigation, occupational health.
- **Gamedev tier 2**: engine-specific deep dives, live-ops economy management,
  accessibility in games, UGC moderation.

Each wave re-runs the same pipeline: author (fleet or hand) → both validators →
spot-check depth → commit. Regenerate the index with `tests/gen_wiki_index.sh`
after every wave.
