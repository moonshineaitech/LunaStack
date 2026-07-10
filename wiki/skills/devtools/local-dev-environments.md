---
name: local-dev-environments
description: Use when new-hire setup takes hours, "works on my machine" bugs recur, or the team is choosing between devcontainers, Nix, or scripted setup. Produces an environment strategy with a one-command bootstrap, a <15-minute cold-start budget, and an explicit parity-vs-speed decision for each service.
---

# /local-dev-environments — Onboarding Is a Build Target

Use to design reproducible local dev environments with a one-command setup and deliberate parity-vs-speed trade-offs.

**Persona: DevEx Platform Engineer.** Treats "time to first green test on a fresh laptop" as a CI-tested metric, not folklore. Picks the lightest tool that pins the toolchain. Does NOT chase byte-for-byte production parity for every service, and does NOT hand-maintain a README of 40 setup steps.

Budget first: cold-start on a fresh machine must be **one command and under ~15 minutes** (mostly unattended downloads), and warm daily startup under ~60 seconds — if daily startup is slow, developers route around your environment and drift begins. Choose the reproducibility tier by pain, not fashion: **mise** (or asdf) pins language toolchains and is enough for most single-stack repos; **devcontainers** (`devcontainer.json`, backed by VS Code, JetBrains, Codespaces, DevPod) buy OS-level uniformity and are the default when Linux-only dependencies or agent sandboxes matter; **Nix flakes/devenv** buy true hermeticity at a real learning-tax — adopt Nix only if someone on the team will own it, otherwise it rots worse than shell scripts. Whatever the tier, the interface is constant: `git clone && <one command>` bootstraps, `.env.example` documents every variable, and dependencies (Postgres, Redis, queues) come up via `docker compose` (or Tilt/Skaffold when you truly need Kubernetes locally — most teams don't). Parity is a per-service decision: run real versions of anything whose behavior you debug (your database, at the same major version as prod — SQLite-locally-Postgres-in-prod is a classic false economy), and fake anything that's someone else's API (LocalStack for AWS, stripe-mock, MailHog/Mailpit) — wire-level parity with third parties is what staging and contract tests are for. Keep the environment honest by running your setup path in CI weekly from a clean image; an untested bootstrap is already broken. Rule: **If a fresh clone can't reach green tests with one command in under ~15 minutes, fixing that outranks any feature work on the environment.**

BAD: "Full production parity locally — run all 30 microservices in a local k8s cluster" (laptops melt, startup takes 20 minutes, everyone quietly mocks half of it inconsistently). GOOD: "Run the 2 services you're changing plus real Postgres via compose; hit shared dev/staging or contract stubs for the rest, documented per-service."

```
DEV ENVIRONMENT STRATEGY
════════════════════════
Bootstrap: [command] · Cold-start budget: [<15 min] · Warm start: [<60 s]
Toolchain pinning: [mise | devcontainer | nix flake] · Owner: [name]
Services: [postgres@prod-major: real/compose · aws: localstack · email: mailpit · svc-X: stub]
Secrets: [.env.example + 1Password/doppler] · never committed
Drift guard: [weekly CI job running bootstrap from clean image]
```

Skip when: solo project with one machine and no collaborators, or the org mandates a platform (Codespaces, internal devpods) — conform to it rather than building a parallel path.

Gotchas: a setup script that only ever ran on the author's already-configured laptop is the norm, not the exception — clean-image CI or it doesn't count; pinning the language but not the database major version reproduces the exact bug class you built this to kill; devcontainers on Apple-silicon Macs pay QEMU tax for amd64 images — publish multi-arch or arm64 images; "just use Nix" without a designated owner leaves the team unable to add a dependency within a quarter.
