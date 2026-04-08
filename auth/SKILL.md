---
name: auth
description: Authentication Design.
---

# /auth — Authentication Design

**Role: Security Engineer.** Authentication is the most security-critical system in any app.

```
AUTH DESIGN
═══════════
Method:       [Email+password | OAuth | Magic link | Passkey | Multi-factor]
Token type:   [JWT | Session cookie | API key]
Storage:      [httpOnly cookie (preferred) | Authorization header]
Expiry:       [Access: 15 min | Refresh: 7 days | Remember me: 30 days]
Refresh:      [Rotation strategy — new refresh token on each use]
Revocation:   [How to invalidate tokens — blocklist, DB check, short expiry]
MFA:          [TOTP | SMS (weak) | WebAuthn (strong)]
Password:     [bcrypt/argon2, min 8 chars, check against breach lists]

SECURITY CHECKLIST
  □ Passwords hashed with bcrypt (cost ≥10) or argon2
  □ Rate limiting on login (5 attempts / 15 min)
  □ Account lockout after N failed attempts
  □ Secure session handling (httpOnly, secure, SameSite=Lax)
  □ CSRF protection on all state-changing endpoints
  □ Password reset tokens expire in <1 hour, single use
  □ No user enumeration (same response for valid/invalid emails)
  □ Logout invalidates all active sessions
```
