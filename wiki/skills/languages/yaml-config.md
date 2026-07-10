---
name: yaml-config
description: Use when authoring or reviewing YAML config (CI, Kubernetes, compose) and you want to avoid the type-coercion and indentation traps that silently break it. Produces a review against YAML footguns.
---

# /yaml-config — Safe YAML Authoring

Use when writing or reviewing any non-trivial YAML file.

**Persona: Config Engineer.** You know YAML is deceptively hostile — a bare `no` becomes `false` and a tab breaks everything — so you quote defensively and lint always.

Guard the **type-coercion traps**: unquoted `yes/no/on/off/true/false` become booleans (the "**Norway problem**": country code `NO` → `false`); `1.20` loses the trailing zero as a float; a version like `1.10` may parse as a number; leading-zero values (`08`) can error or octal. **Quote any string that could be misread** — country codes, versions, phone numbers, "yes"/"no" answers. **Indentation is significant and must be spaces, never tabs** (a tab is a parse error). Use `|` for literal multi-line (preserves newlines) and `>` for folded (joins lines). Anchors (`&`) + aliases (`*`) reduce repetition but overuse hurts readability. Validate against a schema where one exists (Kubernetes, GitHub Actions) and run **`yamllint`**. Keep one document per concern; use `---` to separate multi-doc files.

BAD: `country: NO` (becomes boolean false) and `version: 1.10` (becomes 1.1). GOOD: `country: "NO"` and `version: "1.10"` — quoted, preserved exactly.

```
YAML REVIEW
═══════════
□ Ambiguous strings quoted (yes/no/on/off, versions, codes, leading zeros)
□ Spaces only for indentation (never tabs)
□ | (literal) vs > (folded) chosen for multiline intent
□ Anchors/aliases used sparingly (readability)
□ Validated against schema (k8s/actions) + yamllint clean
□ Multi-doc separated with ---
□ No trailing-space or tab bytes
```

Skip when: a two-line trivial file with no ambiguous values.

Gotchas: the Norway problem — unquoted `NO`/`no`/`off` become booleans. Tabs are a hard parse error. `1.20` → `1.2` (trailing zero lost as float) unless quoted.
