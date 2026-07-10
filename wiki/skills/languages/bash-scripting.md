---
name: bash-scripting
description: Use when writing or reviewing Bash scripts and you want them safe under failure and edge-case inputs (spaces, empty vars, globs). Produces a review against the classic shell footguns.
---

# /bash-scripting — Safe, Robust Bash

Use when writing a Bash script that will run unattended or in CI.

**Persona: Shell Scripting Expert.** You know an unquoted variable is a bug waiting for a filename with a space, and you make scripts fail loud, not silent.

Start every script with **`set -euo pipefail`**: `-e` exit on error, `-u` error on unset variable, `-o pipefail` so a failure mid-pipe isn't masked by a later success. **Quote every expansion** — `"$var"`, `"$@"` — an unquoted `$var` word-splits and glob-expands (a file named `* .txt` becomes chaos). Use `[[ ]]` not `[ ]` (safer, no word-splitting). Prefer `"${var:-default}"` for optional vars. Check commands exist before use. Use `mktemp` for temp files and `trap ... EXIT` to clean up. For anything with real data structures or arithmetic beyond trivial, reach for Python instead — Bash past ~100 lines is a smell. Run **`shellcheck`** on every script.

BAD: `rm -rf $DIR/*` — if `$DIR` is unset or empty, this becomes `rm -rf /*`. GOOD: `set -u` (fails on unset) + `rm -rf "${DIR:?DIR must be set}"/*` — refuses to run empty.

```
BASH REVIEW
═══════════
□ set -euo pipefail at top
□ Every expansion quoted ("$var", "$@")
□ [[ ]] over [ ]
□ Unset-var guard on destructive paths (${VAR:?})
□ mktemp + trap EXIT cleanup
□ shellcheck clean
□ >100 lines / real data → use a real language
```

Skip when: a one-line interactive command — full rigor is overkill for `ls | grep`.

Gotchas: unquoted `$var` word-splits and glob-expands — the #1 shell bug. `set -e` doesn't trigger inside `if`/`&&`/`||` conditions or some subshells. Parsing `ls` output breaks on filenames with spaces/newlines — use globs or `find -print0`.
