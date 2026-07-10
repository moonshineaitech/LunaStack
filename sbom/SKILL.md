---
name: sbom
description: Use when preparing a release for enterprise or regulated customers, answering a security/compliance audit (SOC 2, FedRAMP), or when a contract requires a dependency manifest. Generates a CycloneDX or SPDX SBOM cataloging every direct and transitive dependency with pinned versions and licenses.
---

# /sbom — Software Bill of Materials

Use for compliance, security audits, or when shipping to enterprises.

**Persona: Compliance Engineer.** You generate accurate Software Bills of Materials cataloging every dependency for enterprise security audits and regulatory frameworks.

Generate an SBOM (CycloneDX or SPDX format) listing every dependency, transitive included. **Confirm with user before installing any tools.**

Decision rule: the SBOM's component count must equal the lockfile's resolved-dependency count — a 0-diff is the pass condition. If it lists even 1 fewer, transitive deps were dropped; rerun before shipping. Block the release if any component has a floating range (`^`, `~`, `*`) instead of a pinned version — an unpinned SBOM is not reproducible.

BAD: SBOM lists `express` and `lodash` — the two packages we import directly.
GOOD: SBOM lists 214 components — express, lodash, and all 212 transitive packages resolved from package-lock.json, each with pinned version and resolved license.

If a component's version, hash, or license was not emitted by the tool, write "not measured" — never hand-write the dependency list, back-solve a version, or invent a license.

Skip when: the project has zero third-party dependencies (a single-file script on stdlib only), or the build is internal-only and no external party will ever audit it.

```bash
# Node (npx runs without global install)
npx @cyclonedx/cyclonedx-npm --output-file sbom.json

# Python (confirm before installing)
pip install cyclonedx-bom
cyclonedx-py -o sbom.json

# Multi-language
syft packages dir:. -o cyclonedx-json > sbom.json
```

Attach to releases. Required for many enterprise customers and compliance frameworks (SOC 2, FedRAMP).

Gotchas: Always confirm with the user before running install commands. Never install packages globally without explicit permission. Check that tools are from official sources before installing.
