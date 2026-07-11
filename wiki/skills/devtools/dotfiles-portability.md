---
name: dotfiles-portability
description: Use when setting up, migrating, or auditing a personal development environment — dotfiles repo, shell config, tool installs — or when a new machine takes days to feel usable. Produces a portability plan: symlink/template manager choice, secret-hygiene audit, an idempotent bootstrap script, and a fresh-machine verification test.
---

# /dotfiles-portability — Your Environment Is a Repo, Not a Ritual

Use to turn a hand-grown personal environment into a versioned, secret-free, one-command-reproducible setup.

**Persona: Environment Engineer.** Owns the personal layer — shell, editor config, CLI tool state, machine bootstrap — and treats it as deployable software. Does NOT manage project-level dev environments (containers, devservices — that's a separate concern), and never commits a secret, token, or history file to solve a convenience problem.

Pick the manager by machine diversity, not fashion: **GNU Stow** (plain symlinks from a repo) is enough for one OS and one identity; the moment you have ≥2 machine classes — work vs personal, macOS vs Linux, different git emails — switch to a **chezmoi**-class tool, because you need templating (`.tmpl` files with per-machine data), `chezmoi diff` before apply, and native secret-manager integration. **Secrets never live in dotfiles**: reference them at apply-time from 1Password/Bitwarden CLI (chezmoi's `onepasswordRead`) or keep them in **age**-encrypted files whose key lives only in your password manager — and run a scanner (gitleaks) over the repo before it ever goes public, because `.netrc`, `.npmrc` auth lines, and shell history are the classic leaks. The bootstrap must be one idempotent command from a blank machine (`sh -c "$(curl ...)"` → install manager → apply → install packages from a committed Brewfile/package list), and it must be *tested*: the **works-on-my-new-laptop test** is spinning up a fresh container or VM and running bootstrap to a working shell, commonly targeting under ~15 minutes and repeated roughly quarterly — an untested bootstrap rots silently as you hand-tweak the live machine. Rule: **If a blank machine can't reach your working shell with one command, your dotfiles are a backup, not an environment.**

BAD: "Symlink all of `~/.config` into the repo so nothing gets missed" (machine-generated state, caches, and app-written tokens flood the repo; you leak a credential and drown real config in noise). GOOD: "Adopt files explicitly one at a time (`chezmoi add`), template the per-machine values, and let unmanaged state stay unmanaged."

```
DOTFILES PORTABILITY AUDIT
═══════════════════════════
Manager: [stow | chezmoi-class] · machine classes: [n] · templated values: [email, paths, OS]
Secrets: [vault refs / age-encrypted] · gitleaks scan: [clean | n findings → fix]
Bootstrap: [one-liner] · idempotent: [y/n] · package manifest: [Brewfile / list]
Fresh-machine test: [container/VM] · last run: [date] · time-to-shell: [min]
Gaps: [item → remediation]
```

Skip when: you work on a single company-managed machine with a golden image you can't customize, or you rebuild so rarely that a documented manual checklist honestly costs less than automation upkeep.

Gotchas: fixing things on the live machine and never porting the fix back to the repo, so the repo drifts into fiction; a bootstrap that assumes Homebrew/apt exists instead of detecting the OS and installing prerequisites first; encrypting secrets into the repo while the decryption key is documented... in the same repo; publishing the repo publicly before scanning history — a secret committed once lives in git history forever until you rewrite it and rotate the credential.
