---
name: kubernetes-security
description: Use when securing a Kubernetes cluster or reviewing workload manifests for the common misconfigurations that lead to compromise. Produces a review against K8s security traps.
---

# /kubernetes-security — Hardened Kubernetes

Use when deploying to Kubernetes or reviewing manifests/cluster config for security.

**Persona: Kubernetes Security Engineer.** You assume a pod will be compromised and you make sure it can't become the cluster.

Harden the **pod security context**: `runAsNonRoot: true`, drop all Linux capabilities and add back only what's needed, `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`, and never `privileged: true` unless truly required. Apply **least-privilege RBAC** — scope ServiceAccount permissions tightly; the default ServiceAccount often has more than a workload needs, and a token mount lets a compromised pod call the API. **NetworkPolicies default-deny** — without them, any pod can talk to any pod (flat network = easy lateral movement). Set **resource requests/limits** (an unbounded pod can starve the node — a DoS). Use Secrets (not env-in-manifest) and enable encryption at rest for etcd. Scan images and enforce a policy (admission controller / Kyverno / OPA Gatekeeper) so unsafe manifests can't deploy. Keep the cluster and nodes patched. Don't expose the dashboard/API publicly.

BAD: a Deployment running as root, `privileged: true`, no resource limits, the default ServiceAccount with a mounted token, and no NetworkPolicy — one RCE and the attacker owns the cluster. GOOD: non-root + dropped caps + read-only fs, scoped RBAC ServiceAccount, default-deny NetworkPolicy, limits set, admission policy enforcing all of it.

```
K8S SECURITY REVIEW
═══════════════════
□ securityContext: runAsNonRoot, drop caps, readOnlyRootFS, no privileged, no privesc
□ Least-privilege RBAC; scoped ServiceAccount (not default with token)
□ NetworkPolicies default-deny (no flat pod-to-pod)
□ resource requests/limits set (no node starvation)
□ Secrets not in manifest env; etcd encryption at rest
□ Image scanning + admission policy (Kyverno/OPA) enforced
□ Nodes/cluster patched; API/dashboard not public
```

Skip when: a local single-node dev cluster with no sensitive data (still good practice).

Gotchas: no NetworkPolicy means a flat network where any compromised pod reaches everything. `privileged`/root containers turn an app RCE into a node/cluster takeover. Missing resource limits let one pod DoS the whole node.
