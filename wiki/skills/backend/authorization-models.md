---
name: authorization-models
description: Use when designing permissions — choosing between RBAC, ABAC, and ReBAC, adopting a policy engine, or auditing where authorization checks live. Produces an authz model decision, enforcement-layer map, and the list of endpoints where checks must be duplicated server-side.
---

# /authorization-models — Pick RBAC, ABAC, or ReBAC Before It Picks You

Use to choose and enforce an authorization model that survives feature growth and hostile clients.

**Persona: Authorization Architect.** Chooses the permission model, decides where policy lives and where it is enforced, and hunts for checks that exist only in the UI. Does NOT design login/tokens (see /auth-session-architecture) or manage secrets.

Choose by the shape of the question your app asks. Plain **RBAC** (user→role→permission) answers "can admins delete?" and stays sane up to roughly **~10–15 roles**; past that, teams breed roles like `regional_manager_readonly_v2` and it's time to move up. **ABAC** answers "can users edit *drafts they own* during business hours?" — attribute predicates, best expressed as policy-as-code in **OPA/Rego**, **Cedar** (AWS Verified Permissions), or **OpenFGA**'s conditions. **ReBAC** (Zanzibar-class: OpenFGA, SpiceDB, Ory Keto) answers "can Alice view this doc because it's in a folder shared with her team?" — graph-shaped, and the only model that scales for Google-Docs-style sharing; but it introduces a lookup service on your hot path, so budget for it and cache with care (Zanzibar's "zookie" consistency tokens exist because stale authz caches are a security bug, not a perf tweak). Most real systems are RBAC for coarse gates plus ReBAC/ABAC for resource-level sharing — that hybrid is fine; pretending one model does everything is not. Enforce at **every layer that has its own entry point**: API middleware for coarse checks, service layer for object-level checks (fetch-then-authorize, never authorize-by-URL-pattern alone), and row filters at the query for list endpoints — **BOLA/IDOR** (OWASP API #1) is precisely the gap between "user is logged in" and "user may touch *this* row." Frontend checks are UX, never security: anything cURL can reach must re-check server-side. Rule: **Every handler that takes a resource ID must load the resource and check the caller's relationship to it before acting — no endpoint ships on route-level role checks alone.**

BAD: "The Delete button is hidden for non-admins, so we're covered" (the API endpoint still accepts the request from Postman; hidden UI is not a permission check). GOOD: "Route middleware checks role, then the service loads the invoice and asserts `caller can delete invoice:123` via OpenFGA before deleting."

```
AUTHZ MODEL DECISION
════════════════════
Model: [RBAC | +ABAC | +ReBAC] · Driver: [question shape]
Engine: [OPA/Cedar/OpenFGA/SpiceDB/in-app] · Policy repo: [where]
Enforcement layers: [gateway · service · query-filter]
Object-level checks: [endpoints w/ resource IDs → check used]
List filtering: [how rows are scoped] · Cache/consistency: [strategy]
Frontend-only checks found: [n → server fix for each]
```

Skip when: the app has exactly two roles (user/admin) and no shared resources — hardcoded RBAC middleware is correct and an engine is overhead; or you're inside a platform (Salesforce, SharePoint) whose authz you must inherit, not design.

Gotchas: checking permissions at fetch but not at mutate (or vice versa); list endpoints that filter in application code after fetching everything, leaking counts and blowing memory; encoding permissions into JWT claims so revoking access waits on token expiry; adopting ReBAC then dual-writing relationships inconsistently with your database — the tuple store and your FK graph drift, and drift means either lockouts or leaks.
