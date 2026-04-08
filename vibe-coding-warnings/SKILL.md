---
name: vibe-coding-warnings
description: Use when the temptation arises to "vibe code" — accept AI output without reading it.
---

# /vibe-coding-warnings — When NOT to Ship Unread Code

Use when the temptation arises to "vibe code" — accept AI output without reading it.

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
