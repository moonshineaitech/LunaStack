---
name: oauth-implementation
description: Use when implementing OAuth2/OIDC login or authorization flows and wanting to avoid the classic, exploitable mistakes. Produces a flow choice + the required security parameters.
---

# /oauth-implementation — OAuth2/OIDC Done Right

Use when adding "Sign in with…" or delegated API access — the flow details are where the breaches hide.

**Persona: Identity & Access Engineer.** You know OAuth is easy to make *work* and easy to make *insecure*, and the difference is a handful of parameters most tutorials skip.

Choose the flow: **Authorization Code + PKCE** for everything with a UI (web, SPA, mobile) — never the deprecated Implicit flow; **Client Credentials** for machine-to-machine. Non-negotiable parameters: **PKCE** (`code_challenge`) on every public client; a **`state` parameter** validated on return (CSRF defense); **exact `redirect_uri` allow-listing** (no wildcards — open redirects become account takeover); validate the **ID token signature, `iss`, `aud`, and `exp`** (never trust an unverified JWT); request the **minimum scopes**. Store tokens correctly: refresh tokens server-side or in secure storage, access tokens short-lived (**~5-15 min**), and rotate refresh tokens on use.

BAD: SPA using the Implicit flow, dumping the access token in `localStorage`, redirect_uri with a wildcard — token theft via XSS and account takeover via open redirect, both trivial. GOOD: Auth Code + PKCE, exact redirect_uri, `state` validated, ID token fully verified, short-lived access token, refresh rotated.

```
OAUTH DESIGN
════════════
Flow:        [Auth Code + PKCE / Client Credentials — why]
PKCE:        [yes — required for public clients]
state/nonce: [CSRF + replay defense]
redirect_uri:[exact allow-list, no wildcards]
Token valid: [sig + iss + aud + exp verified]
Scopes:      [minimum requested]
Storage:     [access short-lived; refresh secure + rotated]
```

Skip when: a simple first-party session-cookie login with no third-party or delegated access — OAuth is overkill there.

Gotchas: the Implicit flow is deprecated and token-leaking — always Auth Code + PKCE. Wildcard redirect_uris turn into account takeover. An ID token you didn't verify (signature/iss/aud/exp) is just attacker-supplied JSON.
