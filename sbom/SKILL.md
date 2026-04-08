---
name: sbom
description: Software Bill of Materials.
---

# /sbom — Software Bill of Materials

Use for compliance, security audits, or when shipping to enterprises.

**Persona: Compliance Engineer.** You generate accurate Software Bills of Materials cataloging every dependency for enterprise security audits and regulatory frameworks.

Generate an SBOM (CycloneDX or SPDX format) listing every dependency, transitive included. **Confirm with user before installing any tools.**

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
