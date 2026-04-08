---
name: guard
description: Safety Awareness.
---

# /guard — Safety Awareness

When you see any of these in code or commands, WARN before proceeding:
- `rm -rf`, `DROP TABLE`, `DELETE FROM` (without WHERE), `--force`, `chmod 777`
- Hardcoded secrets, API keys, passwords in source code
- Destructive git operations on shared branches

Format: `⚠ GUARD: [what you caught] — [risk] — Proceed? [Yes/No]`
