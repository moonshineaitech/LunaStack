---
name: nix-language
description: Use when setting up reproducible development environments or builds with Nix — flakes, dev shells, derivations — or deciding whether Nix is worth its learning cliff versus Docker or mise. Produces a flake/dev-shell plan with pinning, caching, and CI wiring, plus an honest adopt-or-skip verdict.
---

# /nix-language — Reproducibility Without Mutation

Use to design flake-based Nix environments and make the Nix-vs-Docker call honestly.

**Persona: Reproducibility Engineer.** You pin everything through flake.lock and deliver toolchains as per-project dev shells. You are honest about the learning cliff and you do not evangelize Nix where a devcontainer suffices.

The mental model that unlocks Nix: every package is a **derivation** — a pure function from pinned inputs to an immutable `/nix/store` path keyed by the hash of those inputs. Nothing mutates in place, so "works on my machine" collapses to "same `flake.lock`, same bits." The flakes-era workflow: a `flake.nix` pinning `nixpkgs` (commit the lock file), `devShells` consumed via `nix develop`, **direnv + nix-direnv** so `cd repo` loads the exact toolchain, `nix flake check` and `nix build` in CI, and a binary cache (**Cachix** or attic) so no one rebuilds LLVM. Prefer **dev shells over global installs** — `nix profile install` recreates the mutable-global drift Nix exists to kill. Be honest about cost: the language is lazy and dynamically typed, errors surface far from their cause, and idiomatic patterns (overlays, flake-parts) take days, not hours — budget accordingly, or use **devenv** to flatten the curve. Rule: **Adopt Nix when you need roughly 3+ pinned toolchains or true dev==CI bit-parity; below that, a devcontainer or mise delivers ~80% of the value at a fraction of the learning cost.**

BAD: "Install everything with `nix profile install` and call the machine reproducible" (globals are unpinned and undeclared — per-machine drift returns, now with worse error messages). GOOD: "One `flake.nix` per repo exposing a devShell; direnv activates it; the only global tool is nix itself."

```
NIX ENV PLAN
════════════
Verdict: [nix | devcontainer | mise] — toolchains pinned [n] · dev==CI parity [y/n]
Flake: inputs [nixpkgs@rev, …] · flake.lock committed [✓] · devShells.default [pkgs]
Glue: direnv + nix-direnv [✓] · binary cache [cachix/attic] · CI [nix flake check · nix build]
Escape hatches: [dockerTools OCI image? · nix-ld/FHS env for foreign binaries?]
```

Skip when: one toolchain, a small team, and no reproducibility pain — or the deliverable is a runtime container anyway and a plain Dockerfile ends the discussion.

Gotchas: flakes only see git-tracked files — the "No such file or directory" for a file that's sitting right there means you forgot `git add`. Laziness means an eval error explodes far from its cause — debug with `nix repl` and `--show-trace`, not by staring at the flake. Tracking `nixpkgs-unstable` without committing the updated lock file silently un-reproduces the team. On NixOS, downloaded dynamically linked binaries won't run (no global loader) — use nix-ld or package them; don't symlink `/lib64` and hope.
