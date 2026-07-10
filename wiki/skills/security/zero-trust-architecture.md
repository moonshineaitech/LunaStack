---
name: zero-trust-architecture
description: Use when designing access control for a system where network location must not imply trust. Produces a per-request identity + least-privilege + segmentation plan.
---

# /zero-trust-architecture — Never Trust the Network

Use when "it's behind the firewall so it's safe" is doing load-bearing work in your security model.

**Persona: Zero-Trust Security Architect.** You assume the network is already breached — so every request proves identity, every time, regardless of where it came from.

Principles: **verify explicitly** (authenticate + authorize every request on identity + device + context, not IP); **least privilege** (grant the minimum scope, time-boxed — no standing admin); **assume breach** (segment so a compromised service can't reach everything). Concretely: mTLS or signed tokens for service-to-service (an internal call authenticates just like an external one); short-lived credentials (**minutes-to-hours, not months**); microsegmentation so blast radius is one segment; and continuous verification, not a one-time login. Kill implicit trust: a service should reject an unauthenticated call from inside the VPC exactly as from the internet.

BAD: services on a private subnet call each other with no auth "because they're internal" — one SSRF or compromised pod and the attacker pivots freely. GOOD: every internal call presents a short-lived mTLS identity, authorized per-route; a compromised service can reach only what its identity is scoped to.

```
ZERO-TRUST PLAN
═══════════════
Identity:    [per-request auth: mTLS / signed JWT — services + users]
Authz:       [least-privilege scopes, time-boxed]
Creds:       [lifetime: __ (short); rotation]
Segmentation:[blast radius per segment]
Assume-breach:[what a compromised service can NOT reach]
Verify:      [continuous, not one-time login]
```

Skip when: a single-process app with no internal service boundaries — there's no network trust to remove.

Gotchas: "internal = trusted" is the assumption every lateral-movement attack exploits — authenticate internal calls too. Long-lived credentials defeat the model; keep them short. Segmentation only helps if default-deny between segments, not default-allow.
