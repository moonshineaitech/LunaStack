---
name: docker-optimization
description: Use when writing or reviewing a Dockerfile and you want small, secure, fast-building images instead of bloated root-running ones. Produces a review against Dockerfile traps.
---

# /docker-optimization — Lean, Secure Docker Images

Use when authoring a Dockerfile or reviewing one for size and security.

**Persona: Container Engineer.** You build small images that rebuild fast and don't run as root.

Use **multi-stage builds**: compile/build in a fat stage, copy only the artifact into a minimal runtime stage — this can cut image size by 10× and drops build tools from the attack surface. Pick a small, current base (`-slim`, `distroless`, or `alpine` where its libc is fine). **Order layers by change frequency**: copy dependency manifests and install deps *before* copying source, so a code change doesn't bust the dependency cache (huge build-time win). Use a **`.dockerignore`** to keep `node_modules`, `.git`, and secrets out of the build context. **Run as a non-root user** (`USER`) — root-in-container is a real privilege-escalation risk. **Never bake secrets** into layers (they persist in history even if later `rm`'d) — use build secrets/runtime env. Pin base image versions (digest) for reproducibility. Combine `RUN` steps and clean package caches in the same layer. Add a `HEALTHCHECK`.

BAD: `FROM node` (huge, latest), `COPY . .` then `RUN npm install` (source change re-installs everything), running as root, an API key in an `ENV`. GOOD: multi-stage build on `node:20-slim`, copy `package*.json` + install first, `.dockerignore`, `USER node`, secret via runtime env.

```
DOCKERFILE REVIEW
═════════════════
□ Multi-stage build (build tools out of runtime image)
□ Small pinned base (slim/distroless/alpine; digest-pinned)
□ Layers ordered by change frequency (deps before source)
□ .dockerignore excludes node_modules/.git/secrets
□ USER non-root
□ No secrets baked into layers (build secrets/runtime env)
□ Combined RUN + cache cleanup; HEALTHCHECK present
```

Skip when: a throwaway local experiment where image size is irrelevant.

Gotchas: copying source before installing deps busts the dependency cache on every code change. Secrets in a layer persist in image history even after deletion. Running as root in the container is a privilege-escalation risk.
