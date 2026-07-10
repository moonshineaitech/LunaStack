---
name: supply-chain-security
description: Use when hardening a project's dependency and build pipeline against malicious packages, tampered artifacts, and typosquats. Produces pinned-and-locked dependencies, a CI dependency-review gate, provenance verification (SLSA/Sigstore), a new-version quarantine policy, and an SBOM decision.
---

# /supply-chain-security — Trust Nothing You Didn't Pin

Use to make "npm install" (or pip, or a GitHub Action) stop being the most dangerous command in your repo.

**Persona: Supply Chain Hardener.** You lock, pin, verify, and gate what enters the build. You do NOT audit your own application code, and you do NOT promise to read every dependency's source — the controls must work without heroics.

Baseline in an afternoon: commit **lockfiles** and install with `npm ci` / `pip install --require-hashes` / frozen-lockfile equivalents so builds are byte-reproducible from the lock; pin **GitHub Actions by full commit SHA** (tags are mutable — `@v4` is a trust-me, `@sha` is a fact); run package installs with **`--ignore-scripts`** where the ecosystem allows, since install-time lifecycle scripts are the #1 malware delivery lane. The post-Shai-Hulud lesson: enforce a **release-age quarantine** — refuse dependency versions younger than ~7 days (pnpm `minimumReleaseAge`, Renovate `minimumReleaseAge`), because worm-published malicious versions are almost always yanked within days. Gate PRs with **dependency review** (GitHub `dependency-review-action` or Socket) that blocks known-vuln and anomalous packages — new maintainer + new install script + network access is a typosquat/takeover signature; also block lookalike names at review time, humans don't catch `reqeusts`. Verify **provenance** where it exists: npm provenance attestations and **Sigstore/cosign** signatures tie an artifact to its source repo and builder — require **SLSA Build L2+** for anything you deploy, and produce it for anything you publish (`gh attestation`, cosign keyless in CI). Generate an **SBOM** (CycloneDX or SPDX, at build time, per artifact) when a customer, regulator (EU CRA-class obligations), or your own incident response needs to answer "do we ship log4j?" in minutes — otherwise it's shelfware. Rule: **no dependency update merges without passing the review gate, and no version younger than ~7 days installs anywhere, including CI.**

BAD: Dependabot auto-merging a patch bump 2 hours after publish (that's exactly the window compromised-maintainer malware lives in). GOOD: Renovate with a 7-day minimum release age, dependency-review gate on the PR, Actions pinned by SHA, and cosign-verified base artifacts.

```
SUPPLY CHAIN POSTURE
════════════════════
Lockfiles: [committed · CI uses frozen install] · scripts: [--ignore-scripts?]
Pinning: [Actions by SHA · base images by digest]
Quarantine: [min release age ~7d · tool enforcing it]
PR gate: [dependency-review/Socket · blocks: vulns · anomalies · typosquats]
Provenance: [verify: npm attestations/cosign · produce: SLSA L__]
SBOM: [CycloneDX/SPDX per build · consumer: __] or [deferred — no consumer]
```

Skip when: a throwaway prototype with no deploy target — lockfile it and move on; the full gate stack earns its keep on things you ship.

Gotchas: pinning direct deps but floating transitives — the lockfile is the control, version ranges in the manifest are just preferences. Treating an SBOM as security — it's an inventory; without someone querying it against advisories it protects nothing. SHA-pinning Actions once and never updating — pair pins with Renovate or you've traded takeover risk for permanent staleness. Assuming a signed artifact is a safe artifact — Sigstore proves who built it, not that it's benign.
