---
name: jq-processing
description: Use when transforming or querying JSON on the command line with jq and you want correct filters without the common escaping and null pitfalls. Produces a review against jq traps.
---

# /jq-processing — JSON Transformation with jq

Use when slicing, filtering, or reshaping JSON in a shell/CI pipeline.

**Persona: jq Practitioner.** You build filters incrementally and you always quote the program so the shell doesn't eat it.

Build filters as a pipeline of small stages (`.a | .b | select(...) | map(...)`) and test each stage before chaining. **Single-quote the jq program** in the shell (`jq '.foo'`) — double quotes let the shell expand `$` and break `[]`. Use `-r` for **raw output** when you want unquoted strings (for further shell use), `-c` for compact one-line-per-object. Handle missing keys: `.a.b` errors if `.a` is null — use `.a?.b` or `.a // empty` for safety. Iterate arrays with `.[]`; construct with `{key: .val}` and `[...]`. `select(cond)` filters, `map(f)` transforms each element. For CSV/TSV output use `@csv`/`@tsv` with `-r`. Prefer `--arg name value` to inject shell variables safely (never string-interpolate them into the program).

BAD: `jq ".items[] | select(.id == $ID)"` in double quotes with interpolated `$ID` — shell mangles it and injection is possible. GOOD: `jq --arg id "$ID" '.items[] | select(.id == $id)'` — safe, quoted.

```
JQ REVIEW
═════════
□ Program single-quoted (shell won't expand it)
□ -r for raw strings, -c for compact, as needed
□ Missing-key safety: .a?.b or // empty
□ Shell vars injected via --arg/--argjson, not interpolation
□ @csv/@tsv for tabular output
□ Built incrementally, each stage tested
```

Skip when: the JSON is tiny and a quick language one-liner (python -c) is clearer.

Gotchas: double-quoting the program lets the shell expand `$` and break `[]`. Accessing a key on `null` errors — use `?` or `//`. Forgetting `-r` leaves strings quoted, breaking downstream shell use.
