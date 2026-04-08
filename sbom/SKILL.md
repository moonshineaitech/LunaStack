---
name: sbom
description: Software Bill of Materials.
---

# /sbom — Software Bill of Materials

Use for compliance, security audits, or when shipping to enterprises.

Generate an SBOM (CycloneDX or SPDX format) listing every dependency, transitive included.

```bash
# Node
npx @cyclonedx/cyclonedx-npm --output-file sbom.json

# Python
pip install cyclonedx-bom
cyclonedx-py -o sbom.json

# Multi-language
syft packages dir:. -o cyclonedx-json > sbom.json
```

Attach to releases. Required for many enterprise customers and compliance frameworks (SOC 2, FedRAMP).
