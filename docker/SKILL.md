---
name: docker
description: Use when writing, reviewing, or debugging a Dockerfile, docker-compose file, or container image before it is built or deployed.
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

Decision rule: `:latest` base tag, running as root, or any secret literal in the image are CRITICAL -- block the merge on any one of them, no exceptions. Size overruns are a flag, not a block: if the built image exceeds its budget (200MB Node, 100MB Go, 500MB Python ML) by more than 2x, require a multi-stage build before approving.

Anti-fabrication: image size is a measured field -- report the actual output of `docker images`. If you have not built the image, write "not measured"; never estimate, back-solve, or invent a size.

BAD: `FROM node:latest` then `RUN npm install` and no USER -- non-reproducible, ships build tools, runs as root, ~1.1GB. GOOD: `FROM node:20.11-alpine AS build` for deps, a second `FROM node:20.11-alpine` runtime stage copying only `dist/` and prod deps, plus `USER node` -- reproducible and ~90MB.

Skip when: no container is in play -- a plain script, a serverless function, or a static-file host needs no Dockerfile review.

Gotchas: Don't use :latest as your base image tag -- builds become non-reproducible when the upstream image changes. Don't run containers as root -- use a non-root USER directive. Don't put secrets in the Docker image -- use environment variables or a secrets manager at runtime.
