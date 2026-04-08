---
name: malicious-skill-detection
description: Detect Malicious Skills/Plugins.
---

# /malicious-skill-detection — Detect Malicious Skills/Plugins

Use before installing any third-party skill, plugin, or extension.

Detection signals:
- Network calls in SKILL.md or scripts
- Credential access (env vars, keychain, ~/.ssh)
- Filesystem operations outside skill directory
- Obfuscated strings (base64, hex, escape sequences)
- Postinstall hooks
- Mismatched author/repo metadata
- Recently created accounts pushing too-good-to-be-true skills

Tooling: combine /skill-security-audit with automated scanners. Never install based on stars alone -- those can be bought.

```
SKILL SECURITY SCAN
═══════════════════
Skill: [name] | Author: [account] | Account age: [days]
Stars: [count] (NOT a trust signal)

[CRITICAL/HIGH/MEDIUM/CLEAR] [signal type]
  File: [path]
  Detail: [what was found]

Network calls: [count found]
Credential access: [yes — what / no]
Filesystem scope: [within skill dir / outside — paths]
Obfuscated strings: [count found]
Postinstall hooks: [yes — what they do / none]

VERDICT: [SAFE / SUSPICIOUS — review needed / MALICIOUS — do not install]
```

Gotchas: Don't install skills from accounts less than 90 days old without manual code review -- fresh accounts are the #1 vector for malicious skills. Don't trust star counts as a signal of safety -- stars can be purchased cheaply. Don't skip checking postinstall hooks -- they execute with full system permissions before you ever see the code.
