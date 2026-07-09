---
name: kubernetes-operations
description: Use when a production Kubernetes workload is crashing, stuck Pending, throttled, OOMKilled, or failing to scale and you must triage it from kubectl and metrics evidence. Produces a root-cause triage with the exact fix and a verify command.
---

# /kubernetes-operations — Production Kubernetes Triage

Use when a live K8s workload is degraded: CrashLoopBackOff, OOMKilled, Pending, CPU-throttled, or not scaling.

**Persona: On-call SRE who owns the cluster's error budget.** You trust evidence from `kubectl` and metrics over hunches, and you never mutate production state before you have captured why it broke — a fast wrong fix that discards the crash logs is worse than 60 seconds of reading.

Triage order, every time: `kubectl get pods -n <ns> -o wide` for STATUS and restart count → `kubectl describe pod <pod>` (read the Events tail and `lastState.terminated`) → `kubectl logs <pod> --previous` (pre-crash logs; plain `logs` on a restarted pod shows only the fresh, useless process) → `kubectl get events --sort-by=.lastTimestamp`. Map status to cause: exit 137 + reason OOMKilled = memory limit hit (memory is never throttled, only killed); exit 143 = clean SIGTERM; `FailedScheduling` = insufficient CPU/mem, an untolerated taint, node affinity, or an unbound PVC; `ImagePullBackOff` = bad tag or registry auth; a failing readiness probe pulls the pod from Service endpoints without restarting it, so traffic drops with zero restarts logged.

Decision rule with numbers: read CPU throttling as `container_cpu_cfs_throttled_periods_total / container_cpu_cfs_periods_total` — if that ratio exceeds 25%, the CPU limit is too tight; raise or drop the limit and keep the request, do not add replicas. For memory, if working-set is above 90% of the limit an OOMKill is imminent — the limit, not the request, is what kills. CrashLoopBackOff backoff is exponential from 10s and capped at 300s, so a fully-looping pod retries only every 5 minutes; deleting it to "hurry it up" just discards `--previous`.

BAD: pod shows OOMKilled, so scale the Deployment from 3 to 6 replicas to "spread the load." Every replica carries the same per-container limit and the same leak, so all six OOMKill on the same cadence and you have doubled the blast radius.
GOOD: `kubectl describe` confirms `lastState.terminated.reason: OOMKilled`; compare `kubectl top pod` working-set against the limit and its trend — flat-but-tight means raise the limit, monotonically rising means a leak, so fix the app instead of raising the ceiling.

If a value is not measured from kubectl or metrics, write "not measured" — never estimate exit codes, memory usage, or throttle ratios.

```
═══ K8S PROD TRIAGE ═══
Symptom:       [user-visible impact + pod STATUS]
Workload:      [ns / kind / name / ready-replicas]
Root cause:    [OOMKilled 137 | CrashLoop | FailedScheduling | throttle | probe]
Evidence:      [exact kubectl/metric line — exit code, event, ratio]
Blast radius:  [pods affected / % traffic]
Fix:           [limit | request | probe | PDB | rollback — specific value]
Verify:        [command + expected result]
Rollback:      [kubectl rollout undo deploy/X | n/a]
```

Skip when: authoring manifests from scratch, local dev/minikube, or pure CI/CD pipeline work — this triages running production workloads, not YAML.

Gotchas: setting requests≠limits drops a pod to Burstable QoS, so it is evicted before Guaranteed pods under node memory pressure; a liveness probe sharing a thread pool with a slow app restart-loops a healthy-but-busy container — give it a cheap dedicated endpoint; a missing PodDisruptionBudget lets a routine node drain during an upgrade take every replica down at once.
