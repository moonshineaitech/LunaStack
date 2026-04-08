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

Tooling: combine /skill-security-audit with automated scanners. Never install based on stars alone — those can be bought.
