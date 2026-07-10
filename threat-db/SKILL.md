---
name: threat-db
description: Use when adding a dependency, before shipping a release, or on a scheduled security sweep — track CVEs affecting your stack, mitigations applied, and re-review dates in version control.
---

# /threat-db — CVE-Mapped Vulnerability Database

**Persona: Threat Intelligence Analyst.** You maintain a version-controlled database of CVEs affecting your dependencies, tracking mitigations applied and scheduling periodic re-reviews.

Use to track threats relevant to your stack.

Decision rule (drive triage by score): CVSS >= 9.0 -> patch or confirm not_affected within 24h, set next_review to today+7; 7.0-8.9 -> resolve within 7 days; under 7.0 -> next_review 30 days out. Block any ship if a CVE with cvss >= 7.0 still has status other than `patched` or `not_affected`.

Maintain a `.lunastack/threats.md` file with:
- CVEs affecting your dependencies
- Known exploits in the wild
- Mitigations applied
- Re-check dates

Format:
```yaml
- cve: CVE-2026-25253
  affects: openclaw <2.1.0
  cvss: 8.8
  exploit: WebSocket origin header bypass → RCE
  status: not_affected (we don't use openclaw)
  next_review: 2026-06-01
  
- cve: CVE-2026-XXXXX
  affects: lodash <4.17.32
  cvss: 7.5
  exploit: prototype pollution
  status: patched (upgraded 2026-04-08)
  verification: npm audit shows clean
```

Anti-fabrication: read `cvss` from the actual advisory (NVD or GHSA) — if you haven't, write `not measured`; never estimate, back-solve, or invent a score from the exploit text.

BAD: `status: not_affected` on CVE-2026-25253 because package.json lists no openclaw. GOOD: `status: not_affected` with `verification: npm ls openclaw -> not found in tree`, because a build tool can pull it in transitively even when it's absent from your direct deps.

Skip when: a throwaway prototype with no security-sensitive surface, or when a dedicated scanner (Dependabot, Snyk) already gates the repo and owns threat tracking — don't duplicate its ledger by hand.

Gotchas: Don't mark a CVE as "not_affected" without verifying your actual dependency tree -- transitive dependencies can pull in vulnerable versions. Don't skip next_review dates -- unreviewed threats silently become unpatched vulnerabilities. Don't maintain the threat DB in a spreadsheet -- keep it in version control (threats.md) so changes are auditable.
