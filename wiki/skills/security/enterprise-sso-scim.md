---
name: enterprise-sso-scim
description: Use when building enterprise SSO (SAML/OIDC) and SCIM provisioning into a SaaS product — per-tenant IdP config, IdP-initiated flow risks, clock skew, deprovisioning lag, and SSO pricing decisions. Produces an implementation checklist covering the auth traps, the offboarding SLA, and the packaging call.
---

# /enterprise-sso-scim — Enterprise Auth Without the Classic Traps

Use to ship SSO and SCIM that pass an enterprise security review — and to make the deliberate packaging decision instead of stumbling into the SSO tax.

**Persona: Enterprise Auth Engineer.** Implements per-tenant SAML/OIDC and SCIM with the failure modes designed out. Does NOT hand-roll XML signature validation, treat SSO as a session bolt-on, or leave deprovisioning to nightly batch jobs.

Prefer **OIDC** when the customer's IdP supports it and never hand-roll SAML — use a maintained library or an auth layer (**WorkOS**, **Auth0/Okta CIC**, **Stytch**, or open-source **SSOReady/BoxyHQ**) because XML signature-wrapping bugs still recur in DIY validators. The classic SAML traps: **IdP-initiated flows** ship an unsolicited assertion with no way to bind it to a request (no `InResponseTo`), so either disable them or accept them only with single-use assertion-ID replay caching and tight conditions; validate `NotBefore`/`NotOnOrAfter` with **~3-5 minutes of clock-skew tolerance** (zero tolerance breaks real customers whose AD FS clocks drift; more invites replay); pin each tenant to *its own* IdP certificate and entity ID, and key user matching on **tenant + immutable IdP identifier (`NameID`/`sub`)** — matching on email alone lets a hostile or misconfigured tenant's IdP assert its way into another tenant's accounts. SCIM is where enterprises actually get burned: the risk is **offboarding lag**, where a fired employee's IdP account is disabled but your app session and API tokens live on — so on a SCIM deactivate (`active: false`), revoke sessions and tokens immediately and target **access fully dead within ~15 minutes**, backstopped by short session TTLs with re-validation for SSO-governed users. Support both deactivate and hard `DELETE`, return correct `PATCH` semantics (Entra ID's SCIM client is notoriously strict), and log every provisioning event for the customer's auditors. On pricing: gating bare-minimum SSO behind a 2-3x enterprise tier is the resented **SSO tax** (see sso.tax); the defensible pattern in 2026 is SSO available on mid tiers or as a modest add-on, while **SCIM, audit-log export, and custom role mapping** anchor the enterprise tier — those genuinely cost you support effort and map to enterprise-only needs. Rule: **A SCIM deactivation must kill all sessions and tokens within ~15 minutes — if offboarding waits for token expiry or a nightly sync, the feature fails its buyer's security review.**

BAD: "Match SAML assertions to users by email address to keep provisioning simple" (any IdP a tenant controls can assert ceo@othercustomer.com — cross-tenant account takeover). GOOD: "Bind users to tenant + immutable NameID/sub at first login, treat email as a mutable display attribute, and reject assertions whose issuer cert doesn't match that tenant's pinned config."

```
ENTERPRISE SSO/SCIM CHECKLIST
═════════════════════════════
Protocols: [OIDC preferred · SAML via lib/vendor: …] · IdP-initiated: [disabled / replay-cached]
Per-tenant: [cert + entityID pinned · domain verification · test-before-enforce toggle]
Identity key: [tenant + NameID/sub] · email: [display only] · JIT provisioning: [rules]
Clock skew: [±3-5 min] · assertion replay cache: [TTL]
SCIM: [deactivate → sessions/tokens revoked ≤15 min · DELETE supported · Entra PATCH quirks tested]
Audit: [SSO+SCIM events exportable] · Packaging: [SSO tier · SCIM/audit as enterprise anchor]
```

Skip when: no enterprise deal requires it yet and you're pre-product-market-fit — social/email auth plus TOTP is fine; revisit at the first security questionnaire that asks.

Gotchas: Shipping SSO without a per-tenant "test before enforce" mode, so one bad cert paste locks an entire customer org out — always keep a break-glass admin path outside SSO. Verifying the SAML signature on the response but not the assertion (or vice versa), the exact gap signature-wrapping attacks exploit. Building SCIM create/update and skipping deactivate because "the IdP blocks login anyway" — API keys, PATs, and mobile sessions don't route through the IdP. Announcing SSO support after testing only Okta — Entra ID, Google Workspace, and OneLogin each have quirks, and the deal-closing customer always runs the one you skipped.
