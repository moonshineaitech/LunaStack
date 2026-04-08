---
name: careful-mode
description: Warn Before Destructive.
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

Gotchas: Don't rely on y/n confirmation for destructive ops -- muscle memory causes accidental confirms. Don't assume piped commands are safe -- `curl | bash` bypasses all careful-mode checks. Don't disable careful-mode "just for this one time" in production -- that's when accidents happen.
