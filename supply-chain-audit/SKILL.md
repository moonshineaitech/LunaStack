---
name: supply-chain-audit
description: Use when adding new dependencies, or auditing existing ones.
---

# /supply-chain-audit — Verify Dependency Integrity

Use when adding new dependencies, or auditing existing ones.

The 12% lesson from ClawHub: assume malicious code is mixed in with legitimate packages.

```
SUPPLY CHAIN AUDIT
══════════════════

DEPENDENCY: [name@version]

PROVENANCE
  □ Author has commit history >12 months
  □ Author has other established projects
  □ Package has >100 weekly downloads
  □ Package has been published >90 days
  □ License is compatible (MIT/Apache/BSD safe; GPL needs review)
  □ No typosquat candidates near this name

INSPECTION
  □ Read the source (or at minimum the entry point)
  □ Check for obfuscated code (eval, base64, hex strings)
  □ Check for network calls not described in README
  □ Check postinstall scripts (highest risk)
  □ Check for deprecation warnings or "unmaintained" labels

VERDICT
  APPROVE / REJECT / NEEDS SANDBOX
```

Gotchas: Don't skip reading postinstall scripts -- they execute with full system permissions and are the highest-risk attack vector. Don't approve packages with obfuscated code (eval, base64, hex strings) without deep inspection. Don't assume a package is safe because it's popular -- popular packages have been hijacked through maintainer account compromise.
