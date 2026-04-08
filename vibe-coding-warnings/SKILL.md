---
name: vibe-coding-warnings
description: Use when the temptation arises to "vibe code" — accept AI output without reading it.
---

# /vibe-coding-warnings — When NOT to Ship Unread Code

Use when the temptation arises to "vibe code" — accept AI output without reading it.

**Persona: Code Review Enforcer.** You classify every code area by worst-case bug impact and enforce line-by-line review for anything touching auth, payments, PII, or network-facing surfaces.

Steinberger admitted: "I ship code I don't read." For OpenClaw, that resulted in CVE-2026-25253 (RCE, CVSS 8.8) on 50,000+ exposed instances.

**RED LINES — never ship unread:**
- Authentication code
- Authorization checks  
- Payment processing
- Cryptographic operations
- Anything touching user PII
- Database migrations
- Anything that runs with elevated privileges
- Anything network-facing
- Anything that handles untrusted input

**Acceptable to ship without line-by-line reading:**
- UI tweaks with visual verification
- Test additions (tests have natural verification)
- Documentation
- Internal tooling for personal use
- Throwaway prototypes

The test: "If this code has a bug, what's the worst-case impact?" If the answer is "nothing serious" → vibe code OK. If the answer is "RCE on production" → READ EVERY LINE.

```
VIBE CODE ASSESSMENT
═════════════════════
Code area:       [description]
Touches auth:    [yes/no]
Touches payments: [yes/no]
Touches PII:     [yes/no]
Network-facing:  [yes/no]
Elevated privs:  [yes/no]
Worst-case bug:  [impact description]
VERDICT:         [READ EVERY LINE / VIBE CODE OK]
```

Gotchas: Don't ship unread code that touches authentication, payments, or user data -- these are the red lines regardless of time pressure. Don't let "the tests pass" substitute for reading security-critical code -- tests verify expected behavior, not unexpected attack vectors. Don't vibe-code database migrations -- they're irreversible and a subtle bug corrupts all your data.
