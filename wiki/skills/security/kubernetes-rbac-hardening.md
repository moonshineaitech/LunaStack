---
name: kubernetes-rbac-hardening
description: Use when auditing or tightening Kubernetes RBAC — least-privilege roles, service-account discipline, and finding out who actually holds cluster-admin. Produces a cluster-admin inventory with justifications, per-workload service accounts with token automount disabled, aggregated roles instead of copy-paste grants, and an audit-log review focused on privilege-relevant verbs.
---

# /kubernetes-rbac-hardening — Least Privilege, Starting With Who Is Admin

Use to shrink Kubernetes RBAC from "everyone inherited cluster-admin in 2023" down to grants someone can defend.

**Persona: Cluster Access Auditor.** You inventory effective permissions, cut them to least privilege, and wire detection for the grants that remain. You do NOT design multi-tenancy network policy or pod security standards — RBAC is the identity layer, and it's enough scope.

Start with the **cluster-admin inventory**, because it's always worse than believed: enumerate every subject bound (directly or via groups) to `cluster-admin` and to the quiet equivalents — `escalate`, `bind`, `impersonate` verbs, write on `clusterrolebindings`, or create-pods-plus-mount-any-SA in kube-system. Use `kubectl-who-can` / `rbac-tool` (or `kubectl auth can-i --list --as=`) rather than eyeballing YAML, since group bindings through your OIDC IdP hide most of the population; commonly a defensible target is **≤5 human break-glass subjects with cluster-admin**, everything else scoped and namespaced. **Service-account discipline** is the workload half: never run on the `default` SA — give each workload its own SA, set `automountServiceAccountToken: false` cluster-wide and opt in only pods that call the API (most don't), and rely on bound, time-limited **TokenRequest** projected tokens, never legacy long-lived secrets. For roles, use **aggregated ClusterRoles** (`aggregationRule` label selectors) so teams extend a base role by adding labeled rules instead of forking copies that drift — copy-paste roles are how a "read-only" role quietly accumulates `create secrets` over two years. Ban wildcards in rules (`*` verbs or resources), and treat read on `secrets` as the privileged grant it is: cluster-wide secret-read is cluster-admin with extra steps. Close the loop with **audit-log review**: alert on `escalate`/`bind`/`impersonate` use, new ClusterRoleBindings, `create` on `pods/exec` in sensitive namespaces, and any use of break-glass identities. Rule: **no workload runs as the default service account, and no SA token is mounted unless the pod provably calls the Kubernetes API — automount off by default, opt-in with justification.**

BAD: "we made a read-only role for the CI runner" that includes `get secrets` cluster-wide (CI now holds every credential in the cluster; one runner compromise is game over). GOOD: CI gets a namespaced SA with `get/list` on pods and deployments only, automount enabled just for that pod, bound token TTL ~1h, and an alert on that SA touching any other namespace.

```
RBAC HARDENING REPORT
═════════════════════
cluster-admin inventory: [subject → via (binding/group) → justification/REVOKE]
Admin-equivalents: [escalate/bind/impersonate/CRB-write holders]
Service accounts: [default SA usage: 0 target · automount: off by default · bound tokens ✓]
Roles: [wildcards removed · secrets-read scoped · aggregation base: name]
Audit alerts: [escalate/bind/impersonate · new CRBs · pods/exec · break-glass use]
```

Skip when: it's a single-tenant dev cluster that holds no secrets and gets rebuilt weekly — spend the effort on the prod cluster's IdP group mappings instead.

Gotchas: auditing RoleBindings but not the IdP groups behind them — `system:masters` via a certificate or a fat OIDC group bypasses RBAC review entirely (and `system:masters` can't be revoked without rotating the CA). Granting `list secrets` believing it hides values — list returns full objects. Trusting namespace isolation while a Role permits `create pods` with arbitrary `serviceAccountName` — that's lateral movement to any SA in the namespace. Writing alerts for cluster-admin use but never for `escalate`/`bind`, the verbs that mint new admins.
