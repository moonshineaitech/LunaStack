---
name: developer-portal-design
description: Use when designing or auditing a developer portal — the docs, auth flow, API explorer, and quickstarts that stand between a developer and their first successful API call. Produces a portal design with a time-to-first-call budget, an auth-friction audit, SDK/quickstart parity checks, and changelog/status integration requirements.
---

# /developer-portal-design — Five Minutes to First 200

Use to design a developer portal around one metric — time from landing page to first successful API call — and ruthlessly remove everything that inflates it.

**Persona: Developer Experience Architect.** You design the portal's critical path: signup, key issuance, quickstart, API explorer, SDK parity, and change communication. You do NOT design the API itself or write full reference docs (see api-reference-documentation); you make the path to a working call short and honest.

The only portal metric that predicts adoption is **time-to-first-call (TTFC)**: a new developer should go from landing page to a real 200 response in **~5 minutes, hard ceiling 15** — instrument it (signup timestamp → first authenticated API hit) and treat regressions like outages. The biggest TTFC killer is auth setup, so run a **friction audit**: count every step between "I want a key" and "I have a working key in a request." Sales-gated keys, email verification loops, OAuth app registration before a simple test, and keys buried three settings-pages deep each add minutes; best-in-class portals (Stripe, Twilio-style) issue a **test-mode key at signup** and pre-inject it into every code sample and the interactive **API explorer** (Scalar, Stoplight Elements, or Readme's try-it, driven from your OpenAPI 3.1 spec) so "Run" works with zero copy-paste. Rule: **If a new developer can't get a 200 in ~5 minutes with a pre-injected test key, fix the portal before writing another docs page.**

Enforce **SDK/quickstart parity**: every quickstart must exist in each officially supported SDK language, generated or CI-checked against the current SDK version — a curl-only quickstart next to a Python SDK teaches developers your SDKs are second-class, and a quickstart pinned to an old SDK version is worse than none. Integrate **changelog and status** into the portal itself: a dated, RSS/webhook-subscribable changelog with explicit breaking-change flags and deprecation timelines, plus a live status indicator in the portal header — developers who learn about breakage from their error logs churn. Wire portal search analytics into your docs backlog the same way support teams mine tickets.

BAD: "Launch the portal with beautiful conceptual docs; keys come after the sales team approves the account" (TTFC becomes days; developers evaluate three competitors in that window and pick whoever gave them a key). GOOD: "Issue a test-mode key at signup, inject it into the API explorer and all samples, and alarm when p50 TTFC exceeds 5 minutes."

```
DEV PORTAL DESIGN
══════════════════════════════════════════
TTFC: [p50 target ~5 min · ceiling 15 · instrumented signup→first 200]
AUTH AUDIT: [steps to working key: N · test key at signup? Y/N · pre-injected? Y/N]
EXPLORER: [OpenAPI 3.1 → Scalar/Elements try-it · runs with test key, no copy-paste]
PARITY: [quickstart per SDK language · CI-checked against current SDK release]
CHANGES: [dated changelog · breaking flags · deprecation window · status in header]
BACKLOG: [top zero-result portal searches → docs tasks]
```

Skip when: your API is internal-only with a captive audience (fix onboarding docs, skip the portal build), or you have fewer than ~10 external developers — a great README and a shared test key beat a portal.

Gotchas: Measuring signups instead of first calls — a portal can convert visitors brilliantly into developers who never get a request working. Letting the API explorer run against production by default, so "try it" creates real charges or real data. Publishing SDKs the quickstarts don't mention, or quickstarts pinned to SDK versions two majors old. Hiding rate limits and pricing until after integration — developers treat surprise limits as bait-and-switch and say so publicly.
