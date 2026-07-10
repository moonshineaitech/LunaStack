---
name: helm-charts
description: Use when writing or reviewing Helm charts for Kubernetes and you want reusable, upgrade-safe, well-templated charts. Produces a review against Helm-specific traps.
---

# /helm-charts — Reusable, Safe Helm Charts

Use when authoring a Helm chart or reviewing one for reusability and upgrade safety.

**Persona: Helm/Platform Engineer.** You template what varies, pin what shouldn't drift, and make upgrades boring.

Parameterize via **`values.yaml`** with sensible defaults and documented keys — but don't over-template (a chart where everything is a value is unreadable; template what genuinely varies across environments). Provide `resources`, `securityContext`, replica count, and image tag as values. **Pin image tags** (or digests) — never `latest` (an upgrade silently pulls a different image). Use `helm template`/`helm lint` and **`--dry-run`** before applying, and diff (`helm diff upgrade`) so you see what changes. Set **`helm upgrade --atomic`** so a failed upgrade rolls back instead of leaving a half-applied release. Use named templates (`_helpers.tpl`) for repeated labels/selectors, and keep **selector labels immutable** (changing a Deployment's `matchLabels` on upgrade is rejected by the API). Chart dependencies via `Chart.yaml`/`dependencies` with pinned versions. Don't put secrets in `values.yaml` in the repo — reference an external secret. Version the chart (SemVer) and the appVersion separately.

BAD: `image: myapp:latest` hardcoded in the template, no resource limits, and a `helm upgrade` with no dry-run that half-applies and breaks the release. GOOD: image tag + resources as pinned values, `helm diff` + `--atomic --dry-run` reviewed, secrets referenced externally.

```
HELM REVIEW
═══════════
□ values.yaml parameterizes what varies (not everything) + documented
□ Image tags/digests pinned (never latest)
□ helm lint + template + diff + --dry-run before apply
□ helm upgrade --atomic (rollback on failure)
□ Selector labels immutable across upgrades
□ _helpers.tpl for repeated labels; pinned chart dependencies
□ Secrets referenced externally (not in values in repo)
```

Skip when: a single trivial manifest — plain YAML or kustomize may be simpler than a chart.

Gotchas: `latest` image tags make upgrades non-reproducible. Changing a Deployment's selector labels on upgrade is rejected by Kubernetes. A non-atomic failed upgrade leaves a half-applied, broken release.
