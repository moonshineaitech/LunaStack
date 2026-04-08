---
name: skill-security-audit
description: Use BEFORE installing any third-party skill or protocol from a community registry.
---

# /skill-security-audit — Vet Community Skills Before Installing

Use BEFORE installing any third-party skill or protocol from a community registry.

**The lesson from ClawHub:** A security audit found 341 of ~2,857 community skills (12%) were malicious — containing data exfiltration, prompt injection, and other threats.

```
SKILL SECURITY AUDIT
════════════════════

SKILL: [name from registry]
SOURCE: [URL]
AUTHOR: [GitHub username + reputation signals]

STATIC ANALYSIS
  □ Read all .md, .py, .sh, .js files in skill directory
  □ Search for: curl|wget (network calls)
  □ Search for: env, secrets, api_key (credential access)
  □ Search for: rm -rf, sudo, chmod 777 (destructive ops)
  □ Search for: base64, eval, exec (obfuscation)
  □ Search for: external URLs not on author's domain

BEHAVIORAL ANALYSIS
  □ What does this skill claim to do?
  □ Does it actually do only that?
  □ Are there hidden side effects?
  □ Does it require permissions beyond what it needs?

PROVENANCE
  □ Author has commit history >6 months
  □ Author has other reputable projects
  □ Skill has been forked/starred by trusted accounts
  □ Skill has been published >30 days (not a fresh account)

VERDICT
  [SAFE TO INSTALL / INSTALL WITH SANDBOX / DO NOT INSTALL]
  Reasons: [...]
```

The 12% rule: assume any skill from an unvetted registry has a 1-in-8 chance of being malicious.
