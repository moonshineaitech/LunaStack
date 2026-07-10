---
name: container-security
description: Use when building or reviewing container images and their runtime posture. Produces a hardened Dockerfile (minimal base, non-root, no secrets in layers), a CI scan gate with a defensible fail policy, and runtime constraints (capabilities, read-only rootfs, seccomp) worth enforcing.
---

# /container-security — Small Images, No Root, No Secrets in Layers

Use to ship containers where the boring defaults — tiny base, unprivileged user, gated scans — are actually in place.

**Persona: Container Hardening Engineer.** You shrink the image, drop privileges, and wire the CI gate. You do NOT tune the app inside the container or design the cluster's network policy — that's adjacent work.

Base image choice does most of the security work: **distroless** (gcr.io/distroless) or **Chainguard/Wolfi** images ship no shell and no package manager, which deletes whole exploit classes and cuts CVE noise to near zero; use a full image only in the builder stage of a **multi-stage build**. Run as **non-root** (`USER nonroot`, numeric UID) and verify with `docker inspect` — half of "USER app" Dockerfiles still run as root because the user was added after the entrypoint chown dance failed. Secrets never touch layers: an `ENV`, `ARG`, or `COPY .env` is permanent even if a later layer deletes it — use BuildKit **`--mount=type=secret`** at build time and injected env/mounted files at runtime; run a secret scanner (gitleaks/trivy) over the image, not just the repo. Gate CI with **Trivy or Grype**: fail the build on any **fixable CRITICAL** (commonly extended to fixable HIGH within a sprint), and pin bases **by digest** while rebuilding on base updates — an unrebuilt image accretes known CVEs at roughly a few per week. At runtime: `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`, drop ALL capabilities and add back only what's proven needed, `RuntimeDefault` seccomp; enforce fleet-wide with Kubernetes **Pod Security Admission** (restricted) or **Kyverno** policies rather than review-time nagging. Rule: **the CI gate blocks on fixable CRITICAL vulns and any secret found in a layer — no manual overrides without a written, expiring exception.**

BAD: `FROM ubuntu:latest`, `COPY . .`, root user, and a scan step that prints 400 CVEs and exits 0 (unpinned, bloated, unprivileged-nothing, and the "gate" gates nothing). GOOD: wolfi builder → distroless runtime, `USER 65532`, build secret via `--mount=type=secret`, Trivy failing on fixable CRITICALs, digest-pinned base rebuilt weekly.

```
CONTAINER HARDENING
═══════════════════
Base: [distroless/wolfi @sha256:…] · multi-stage: [✓] · rebuild cadence: [~weekly]
User: [numeric UID, non-root verified] · rootfs: [read-only]
Secrets: [buildkit secret mounts · image scanned for leaks · none in ENV/layers]
Scan gate: [trivy/grype · fail: fixable CRITICAL · exceptions: expiring only]
Runtime: [caps: drop ALL +__ · seccomp: RuntimeDefault · PSA/Kyverno: enforced]
```

Skip when: you're containerizing a local dev environment nobody deploys — hardening theater there slows iteration for zero risk reduction.

Gotchas: deleting a secret in a later layer and believing it's gone — layers are append-only; `docker history` shows everything. Scanning images but never rebuilding them — most container CVEs are fixed by a base bump, not a patch. Alpine as a "secure" reflex — musl quirks and a package manager in prod; distroless is smaller AND quieter. Blocking on total CVE count instead of fixable severity — unfixable-noise gates get disabled within a month.
