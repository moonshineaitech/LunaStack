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
