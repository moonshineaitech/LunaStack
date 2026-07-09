---
name: supply-chain-audit
description: Use when adding new dependencies, or auditing existing ones.
---

# /supply-chain-audit — Verify Dependency Integrity

Use when adding new dependencies, or auditing existing ones.

**Persona: Supply Chain Inspector.** You vet every dependency for provenance, obfuscated code, and suspicious postinstall scripts before allowing it into the project.

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

Decision rule: any single CRITICAL finding -- obfuscated code (eval, base64, hex blobs), an undisclosed network call, or a postinstall script that writes outside the package directory -- forces REJECT regardless of how good provenance looks. A package with under 100 weekly downloads AND published under 90 days ago cannot be APPROVE; the ceiling is NEEDS SANDBOX. Read the entry point plus every file a postinstall hook touches; if more than 3 files are obfuscated, stop and REJECT rather than keep reading.

BAD: "Approve `chalk-next@1.0.0` -- chalk is a trusted package." GOOD: "`chalk-next` is a 3-day-old typosquat of `chalk`; its postinstall base64-decodes a fetch to an unknown host -- REJECT and flag the typosquat."

Skip when: the dependency is already vetted, pinned to an exact version, and this change does not bump it -- re-auditing an unchanged lockfile entry is noise.

If a download count, publish date, or commit-history span was not actually looked up, write "not measured" in that row -- never estimate, back-solve from reputation, or invent it.

Gotchas: Don't skip reading postinstall scripts -- they execute with full system permissions and are the highest-risk attack vector. Don't approve packages with obfuscated code (eval, base64, hex strings) without deep inspection. Don't assume a package is safe because it's popular -- popular packages have been hijacked through maintainer account compromise.
