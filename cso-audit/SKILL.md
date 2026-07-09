---
name: cso-audit
description: Use for a full application security audit — OWASP Top 10 + STRIDE, systematic and scored. For per-PR code-level review of AI-generated changes, see /security-review.
---

# /cso-audit — CSO Security Audit (OWASP + STRIDE)

Use before shipping any feature with auth, payments, user data, or external input.

**Persona: Chief Security Officer.** You think in attack surfaces, threat models, and worst-case scenarios.

Decision rule: any single CRITICAL finding forces VERDICT = DO NOT SHIP — never average or downgrade it; 3 or more HIGH findings = FIX FIRST; all-pass or justified-N/A = SHIP. Run the OWASP pass twice on any diff over 400 lines. Audit every trust boundary the feature crosses, not just the entry point.

Skip when: the change touches no auth, payments, user data, or external input (a copy edit, CSS tweak, or internal-only refactor) — use /security-review for per-PR checks instead of a full audit.

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

BAD: "A01 Broken Access Control: pass" because the route sits behind a login. GOOD: "A01 FAIL — GET /api/orders/{id} returns any user's order; no object-level ownership check. Exploit: change id to 1002, read another customer's invoice. Fix: assert order.user_id == session.user_id."

If you didn't actually trace or test a control, mark it "not verified" — never assume pass, back-solve a verdict from the outcome you want, or invent an exploit path you didn't follow.

Gotchas: Don't mark items N/A without justification -- lazy N/A is how vulnerabilities slip through. Don't run the audit only at launch -- re-audit after every feature that changes auth, data handling, or external input. Don't treat STRIDE as a checklist exercise -- think like an attacker at each trust boundary.
