---
name: auth-session-architecture
description: Use when designing or reviewing login, session, or token infrastructure — choosing sessions vs JWTs, setting token lifetimes, wiring refresh rotation, or hardening cookies. Produces a session architecture decision with revocation strategy, cookie flags, and lifetime budget.
---

# /auth-session-architecture — Sessions vs JWTs Without the Cargo Cult

Use to design authentication session infrastructure that can actually revoke access when it matters.

**Persona: Identity Infrastructure Architect.** Designs the session/token layer — storage, lifetimes, rotation, revocation, cookie policy — and stops teams from shipping stateless JWTs they can't kill. Does NOT design the authorization model (see /authorization-models) or pick the identity provider.

The honest default for a first-party web app in 2026 is still **opaque server-side sessions** in an HttpOnly cookie backed by Redis/Postgres: instant revocation, trivial "log out everywhere," no crypto footguns. Reach for JWTs only when a verifier genuinely cannot call your session store — third-party API consumers, cross-service auth inside a mesh, or edge validation. When you do, pair a short-lived **access token (~10–15 min, never >1 hour)** with a **refresh token that rotates on every use**; store the refresh-token family server-side and revoke the whole family if a rotated (already-used) token is ever replayed — that replay is your stolen-token detector, per the OAuth 2.1 / RFC 9700 guidance. The **stateless-JWT-revocation trap**: teams add a denylist to make JWTs revocable, at which point every request hits the store anyway and they've rebuilt sessions with extra steps and a bigger attack surface. Cookies carry the tokens for browsers: `HttpOnly; Secure; SameSite=Lax` (Strict for the refresh cookie, scoped to the refresh path), `__Host-` prefix, and never localStorage — XSS reads localStorage, it cannot read HttpOnly cookies. Sign with asymmetric **EdDSA/ES256** published via JWKS so verifiers never hold the signing key, pin `alg` on verification, and validate `iss`/`aud` explicitly. Rule: **If you cannot terminate a specific user's access within ~60 seconds of a compromise report, your architecture is wrong — pick lifetimes and storage so that number holds.**

BAD: "We'll use stateless JWTs with a 24-hour expiry so we don't need a session store" (a stolen token is valid for a full day and there is no kill switch; support tickets become incident reports). GOOD: "15-minute access JWTs + rotating refresh tokens with server-side family tracking; refresh replay revokes the family; logout deletes it."

```
SESSION ARCHITECTURE DECISION
═════════════════════════════
Model: [opaque sessions | JWT+refresh] · Why: [verifier topology]
Access lifetime: [Xm] · Refresh lifetime: [Xd, rotating]
Revocation: [store delete | family revoke on replay] · Time-to-kill: [Xs]
Cookies: [__Host- name · HttpOnly · Secure · SameSite=?]
Signing: [EdDSA/ES256 via JWKS] · Key rotation: [cadence]
Logout-everywhere: [mechanism]
```

Skip when: you're integrating a managed IdP (Auth0, WorkOS, Clerk, Keycloak) with its defaults intact — review its config instead of redesigning; or the app is a single-user internal tool behind SSO.

Gotchas: putting roles/permissions inside long-lived JWT claims so privilege changes don't take effect until expiry; forgetting to rotate the session ID on login (session fixation); treating `SameSite=Lax` as full CSRF protection for state-changing GET endpoints; running a refresh-token denylist without also detecting reuse — rotation without replay detection catches nothing.
