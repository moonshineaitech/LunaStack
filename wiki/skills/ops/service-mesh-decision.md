---
name: service-mesh-decision
description: Use when someone proposes adopting (or removing) a service mesh, or when mTLS/traffic-policy requirements surface. Produces an honest adopt/defer verdict weighing ambient-mode economics against operational tax, plus a lighter-weight alternative if the answer is no.
---

# /service-mesh-decision — Mesh Honesty Before Mesh Adoption

Use to decide whether a service mesh earns its operational tax — or whether you need three of its features and none of its platform.

**Persona: The Mesh Skeptic Who Runs One.** A platform engineer who has operated Istio in production for years and therefore recommends it rarely. Evaluates the actual requirement (mTLS? retries? traffic split? authz?) against cheaper substitutes first. Does NOT install a mesh to "future-proof," and does not treat CNCF adoption charts as evidence your team needs one.

Most teams asking for a mesh want exactly three things: **mTLS everywhere**, retry/timeout policy without code changes, and canary traffic splitting. Each has a cheaper substitute — Cilium's WireGuard/IPsec **transparent encryption** or SPIFFE/SPIRE identities for mTLS, a gateway implementing the **Gateway API** (Envoy Gateway, Cilium Gateway) for north-south policy, and Argo Rollouts or Flagger for canaries. The mesh becomes worth it when you need *east-west* L7 policy across many teams: per-route authz between dozens of services, org-wide traffic shaping, multi-cluster identity. **Istio ambient mode** (GA since 1.24) changed the math: the ztunnel node proxy gives you mTLS and L4 authz with no sidecar CPU/memory tax and no pod restarts on upgrade — commonly ~90% cheaper at baseline than sidecars — while **waypoint proxies** are added per-namespace only where L7 policy is actually needed. Linkerd remains the simplicity pick but its sidecar model and Buoyant's stable-release licensing are real considerations. Sizing heuristic: below ~20 microservices or without a dedicated platform owner (≥0.5 FTE for mesh care: upgrades, CVEs, CRD churn), defer. Rule: **Adopt a mesh only when you can name three L7 east-west policies you will ship in the first quarter; otherwise solve mTLS with ambient-style L4 or CNI encryption and stop.**

BAD: "Install Istio with sidecars cluster-wide so we're ready for whatever comes" (pays ~10-15% per-pod overhead, upgrade-restart pain, and a permanent ops burden for features nobody scheduled). GOOD: "Enable Cilium transparent encryption for the compliance mTLS requirement now; revisit ambient Istio when the payments team's per-route authz work lands next quarter."

```
SERVICE MESH DECISION
═════════════════════
DRIVER: [mTLS · retries/timeouts · canary · east-west authz · multi-cluster]
CHEAPER SUBSTITUTE: [CNI encryption / Gateway API / Argo Rollouts] · viable? [Y/N + why]
SCALE: [N services · N teams] · PLATFORM OWNER: [name / none — none = defer]
MODE IF ADOPTING: [ambient L4-first · waypoints only in: ns-list]
OPERATIONAL TAX: [upgrade cadence · CVE watch · CRD surface] accepted by: [team]
VERDICT: [ADOPT ambient / ADOPT full / DEFER — revisit trigger: condition]
```

Skip when: the org already runs a mesh in production (decision is made — focus on operating it well), or you have a single monolith plus a couple of satellites.

Gotchas: teams adopt a mesh for observability alone, which eBPF tooling (Cilium/Hubble, Grafana Beyla) now provides without proxies; sidecar resource requests are forgotten in capacity planning and silently eat 10-15% of the cluster; mesh-wide upgrades get deferred until a CVE forces a rushed one — pin an upgrade cadence on day one; and "we'll add L7 policy later" means the waypoint/sidecar tax was paid for years before the first AuthorizationPolicy shipped.
