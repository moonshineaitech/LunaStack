---
name: docker
description: Containerization.
---

# /docker — Containerization

**Role: Platform Engineer.**

```
DOCKERFILE REVIEW
═════════════════
□ Multi-stage build (build deps not in runtime image)
□ Specific base image tag (not :latest)
□ Non-root user (USER node / USER appuser)
□ .dockerignore excludes: node_modules, .git, .env, tests, docs
□ Layer ordering: deps first (cacheable), code last (changes often)
□ HEALTHCHECK defined
□ No secrets in image (use env vars or secrets manager at runtime)
□ Image size: < 200MB for Node, < 100MB for Go, < 500MB for Python ML
□ One process per container
□ Graceful shutdown (handle SIGTERM)
```

Gotchas: Don't use :latest as your base image tag -- builds become non-reproducible when the upstream image changes. Don't run containers as root -- use a non-root USER directive. Don't put secrets in the Docker image -- use environment variables or a secrets manager at runtime.
