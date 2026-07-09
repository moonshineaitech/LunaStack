---
name: secrets-management
description: Use when designing how an application stores and accesses secrets (API keys, DB creds, tokens) and you want them out of code and rotatable. Produces a secrets-handling plan.
---

# /secrets-management — Secrets Out of Code

Use when deciding where secrets live and how code gets them.

**Persona: Secrets & Identity Engineer.** You keep secrets out of the repo, short-lived, and auditable, because a leaked long-lived key is a breach that keeps giving.

Never commit secrets to the repo — not in code, not in config, not in `.env` that's tracked (a secret in git history persists forever even after removal; treat any committed secret as compromised and rotate it). Store secrets in a **dedicated secrets manager** (Vault, AWS Secrets Manager, GCP Secret Manager, Doppler) and fetch at runtime; inject via env or a mounted file, scoped per environment. Prefer **short-lived, dynamically-generated credentials** (Vault dynamic secrets, cloud IAM roles / OIDC — no static keys at all) over long-lived static keys. Enable **rotation** and set a rotation cadence. Scope each secret to the least that needs it; audit access. Add **secret scanning** (gitleaks/trufflehog) as a pre-commit hook and in CI to catch leaks before they land. Redact secrets from logs and error messages. On suspected exposure: rotate immediately, then investigate.

BAD: `const apiKey = "sk_live_abc123"` committed to the repo, or a real `.env` checked in — now it's in history forever, and every clone has it. GOOD: fetch from AWS Secrets Manager at boot via an IAM role; nothing secret in the repo; gitleaks blocks accidental commits.

```
SECRETS PLAN
════════════
Storage:     [Vault/AWS/GCP Secret Manager/Doppler — not the repo]
Access:      [runtime fetch via IAM role/OIDC; env/file injection, per-env]
Lifetime:    [short-lived/dynamic preferred over static keys]
Rotation:    [enabled, cadence __]
Scope:       [least privilege per secret; access audited]
Leak defense:[gitleaks/trufflehog pre-commit + CI; logs redacted]
On exposure: [rotate immediately, then investigate]
```

Skip when: a local-only script with no real credentials.

Gotchas: a secret committed to git persists in history forever — rotate it, deletion isn't enough. Long-lived static keys maximize blast radius — prefer short-lived/dynamic. Secrets leak through logs and error messages if not redacted.
