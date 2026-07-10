---
name: github-actions-cicd
description: Use when writing or reviewing GitHub Actions workflows and you want secure, fast, correctly-permissioned pipelines. Produces a review against Actions-specific traps.
---

# /github-actions-cicd — Secure, Fast GitHub Actions

Use when authoring a workflow or reviewing it for security and speed.

**Persona: CI/CD Engineer.** You pin your actions, scope your tokens, and never let an untrusted PR run with your secrets.

Security first: **pin third-party actions to a full commit SHA**, not a mutable tag (`@v4` can be force-moved to malicious code) — supply-chain defense. Set **least-privilege `permissions:`** at the workflow/job level (default the token to `contents: read`; grant more only where needed). Never use **`pull_request_target`** with a checkout of the PR head + secrets — that's the classic exfiltration hole (untrusted code running with write token/secrets); use `pull_request` for untrusted contributions. Don't interpolate untrusted input (`github.event.*.title/body`) directly into a `run:` shell — it's script injection; pass via `env:` and quote. Speed: cache dependencies (`actions/cache` or setup-action caching), run independent jobs in parallel, use path filters and concurrency groups to cancel superseded runs. Keep secrets in encrypted secrets/OIDC (no long-lived cloud keys — use OIDC to assume a role). Fail the pipeline on real failures (don't `continue-on-error` the tests).

BAD: `uses: some/action@v3` (mutable), `permissions: write-all`, and `run: echo "${{ github.event.issue.title }}"` — supply-chain risk, over-permissioned, and shell injection via the title. GOOD: SHA-pinned action, `permissions: {contents: read}`, and the title passed through `env:` and quoted.

```
ACTIONS REVIEW
══════════════
□ Third-party actions SHA-pinned (not mutable tags)
□ Least-privilege permissions: (default contents: read)
□ No pull_request_target + PR-head checkout + secrets (exfil hole)
□ Untrusted input via env:, never interpolated into run: (injection)
□ Dependency caching; parallel jobs; concurrency cancel-in-progress
□ OIDC to assume cloud roles (no long-lived keys)
□ Real failures fail the pipeline (no blanket continue-on-error)
```

Skip when: a trivial one-step workflow with no secrets or untrusted input.

Gotchas: mutable action tags can be force-moved to malicious code — pin to SHA. `pull_request_target` + PR checkout + secrets exfiltrates secrets to fork PRs. Interpolating `github.event` text into `run:` is shell injection.
