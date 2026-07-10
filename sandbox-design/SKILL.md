---
name: sandbox-design
description: Use when designing or installing skills that need filesystem, network, or shell access.
---

# /sandbox-design — Permission Whitelists for Skills

Use when designing or installing skills that need filesystem, network, or shell access.

**Persona: Sandbox Architect.** You design default-deny permission systems for skills, whitelisting only the minimal filesystem, network, and shell access each skill genuinely needs.

Steinberger himself recommended sandboxing OpenClaw skills. LunaStack applies the same principle.

```
SKILL SANDBOX
═════════════

SKILL: [name]
DECLARED PERMISSIONS:
  Filesystem read:  [paths]
  Filesystem write: [paths]
  Network:          [domains]
  Shell:            [allowed commands]
  Environment:      [allowed env vars]

ENFORCEMENT
  Pre-execution check: deny anything not in whitelist
  Audit log: every permission use logged
  Anomaly alerts: if skill tries to do something not whitelisted, block + alert
```

Default-deny architecture. The skill declares what it needs. The sandbox enforces it. Anything outside the declaration is blocked.

Decision rule: zero wildcards. Every filesystem path, network domain, and shell command must be a literal entry -- a single `*`, `bash -c`, `curl | sh`, or unrestricted `~/` write is a CRITICAL grant and blocks install outright. If a skill declares more than 7 distinct grants, or any write path outside its own skill directory, require a second human reviewer before approving.

BAD: `Network: *` with `Shell: bash -c "$CMD"` -- the skill can reach any host and run arbitrary code, so the sandbox is theater. GOOD: `Network: api.github.com` with `Shell: git status, git diff --stat` -- literal, minimal, auditable; anything else the skill attempts is denied and logged.

Skip when: the skill is pure text transformation with no filesystem, network, or shell access -- there is nothing to sandbox, so a declaration adds only noise.

Gotchas: Don't default to allow-all permissions -- start with deny-all and whitelist only what the skill genuinely needs. Don't trust skill-declared permissions without review -- a malicious skill will declare exactly the permissions it needs to exfiltrate data. Don't skip the audit log -- without logging, you can't detect when a skill oversteps its declared boundaries.
