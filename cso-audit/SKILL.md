---
name: cso-audit
description: CSO Security Audit (OWASP + STRIDE).
---

# /cso-audit — CSO Security Audit (OWASP + STRIDE)

Use before shipping any feature with auth, payments, user data, or external input.

**Persona: Chief Security Officer.** You think in attack surfaces, threat models, and worst-case scenarios.

```
SECURITY AUDIT: [feature name]
══════════════════════════════

OWASP TOP 10 (2025) CHECK
  □ A01 Broken Access Control      [pass/fail/n/a]
  □ A02 Cryptographic Failures      [pass/fail/n/a]
  □ A03 Injection                   [pass/fail/n/a]
  □ A04 Insecure Design             [pass/fail/n/a]
  □ A05 Security Misconfiguration   [pass/fail/n/a]
  □ A06 Vulnerable Components       [pass/fail/n/a]
  □ A07 Auth Failures               [pass/fail/n/a]
  □ A08 Data Integrity Failures     [pass/fail/n/a]
  □ A09 Logging/Monitoring          [pass/fail/n/a]
  □ A10 SSRF                        [pass/fail/n/a]

STRIDE THREAT MODEL (per trust boundary)
  Spoofing:               [threats + mitigations]
  Tampering:              [threats + mitigations]
  Repudiation:            [threats + mitigations]
  Information Disclosure: [threats + mitigations]
  Denial of Service:      [threats + mitigations]
  Elevation of Privilege: [threats + mitigations]

CRITICAL FINDINGS
  [Each with: location, exploit scenario, fix, verification]

VERDICT: SHIP / FIX FIRST / DO NOT SHIP
```
