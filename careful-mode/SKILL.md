---
name: careful-mode
description: Use when about to run any command that irreversibly modifies state — rm -rf, git push --force, DROP/TRUNCATE/DELETE without WHERE, chmod 777, curl | bash, unbacked file overwrites, or untagged production deploys.
---

# /careful-mode — Warn Before Destructive

Use before running any command that modifies state irreversibly.

**Persona: Safety Inspector.** You catch destructive operations before they execute, demanding explicit confirmation that goes beyond muscle-memory "y/n."

Activates a wrapper that warns before:
- `rm -rf` (especially in non-trivial directories)
- `git push --force` (especially to main/master)
- `DROP TABLE` / `TRUNCATE` / `DELETE FROM` without WHERE
- `chmod 777` 
- `curl ... | bash`
- File overwrites without backup
- Production deploys without tag

The wrapper shows: what command, what files/data affected, what would be lost, then asks: "type DESTROY to confirm" -- not just y/n.

```
CAREFUL MODE WARNING
════════════════════
Command: [exact command to be executed]
Risk level: [CRITICAL / HIGH / MEDIUM]
Affects: [files/data/services impacted]
Would be lost: [what cannot be recovered]
Backup exists: [yes — location / no]

Type DESTROY to confirm, or ABORT to cancel.
```

Decision rule: score risk mechanically. CRITICAL (block, require the typed DESTROY) if the op is irreversible AND no backup exists, OR it targets production, OR `rm -rf` resolves to more than 1 directory or any path above the repo root. HIGH if irreversible but a verified backup exists. MEDIUM otherwise. Never accept a bare y/n for CRITICAL or HIGH — require the full 7-character DESTROY.

Anti-fabrication: fill `Affects`, `Would be lost`, and `Backup exists` only from what you actually checked. If you haven't listed the real files or confirmed the backup, write "not verified" — never assume a backup exists, estimate the blast radius, or back-solve the risk level.

BAD: `git push --force origin main` → "Push anyway? (y/n)" — one reflex keystroke overwrites 6 teammates' commits, unrecoverable.
GOOD: same command → "Risk: CRITICAL. Overwrites main, 6 commits lost, backup: not verified. Type DESTROY." — forces a deliberate, non-muscle-memory choice.

Skip when: the command is read-only or trivially reversible under version control (`git status`, `ls`, an edit to a tracked file you can `git checkout`) — gating these trains users to ignore the warning.

Gotchas: Don't rely on y/n confirmation for destructive ops -- muscle memory causes accidental confirms. Don't assume piped commands are safe -- `curl | bash` bypasses all careful-mode checks. Don't disable careful-mode "just for this one time" in production -- that's when accidents happen.
