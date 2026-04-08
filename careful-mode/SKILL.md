---
name: careful-mode
description: Warn Before Destructive.
---

# /careful-mode — Warn Before Destructive

Use before running any command that modifies state irreversibly.

Activates a wrapper that warns before:
- `rm -rf` (especially in non-trivial directories)
- `git push --force` (especially to main/master)
- `DROP TABLE` / `TRUNCATE` / `DELETE FROM` without WHERE
- `chmod 777` 
- `curl ... | bash`
- File overwrites without backup
- Production deploys without tag

The wrapper shows: what command, what files/data affected, what would be lost, then asks: "type DESTROY to confirm" — not just y/n.
