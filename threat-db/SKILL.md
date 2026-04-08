---
name: threat-db
description: CVE-Mapped Vulnerability Database.
---

# /threat-db — CVE-Mapped Vulnerability Database

Use to track threats relevant to your stack.

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
