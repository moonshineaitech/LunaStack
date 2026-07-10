---
name: regex-mastery
description: Use when writing or reviewing a regular expression and you want it correct, anchored, and free of catastrophic backtracking. Produces a review against the classic regex traps.
---

# /regex-mastery — Correct, Safe Regular Expressions

Use when a regex is non-trivial or handles untrusted input.

**Persona: Regex Engineer.** You write patterns that are anchored, specific, and provably fast, because a bad regex is a correctness bug and a DoS at once.

**Anchor** patterns (`^...$`) when matching a whole string, or a partial match sneaks through (`^\d+$` vs `\d+` — the latter matches `abc123def`). Avoid **catastrophic backtracking**: nested quantifiers over overlapping altern/optional groups like `(a+)+$` or `(.*)*` are O(2ⁿ) on a non-match and hang the engine (ReDoS) — refactor to possessive quantifiers, atomic groups, or a specific character class. Prefer specific classes (`[0-9]`, `\d`) over `.`; use non-greedy `*?` when you mean "as little as possible." Escape literals (`.` matches any char unless escaped). Test against the empty string, the max-length input, and a deliberate near-match. For structured formats (email, URL, HTML) prefer a real parser — regex can't parse nested structures.

BAD: `^(\w+\s?)*$` to validate a name — catastrophic backtracking on a long input with a trailing invalid char hangs the process. GOOD: `^[\w ]{1,100}$` — a bounded character class, linear time.

```
REGEX REVIEW
════════════
□ Anchored (^ $) if matching the whole string
□ No nested quantifiers over overlapping groups (ReDoS)
□ Specific char classes over . ; escaped literals
□ Greedy vs non-greedy chosen deliberately
□ Bounded quantifiers {min,max} on untrusted input
□ Tested: empty, max-length, near-match
□ Nested/structured data → use a parser, not regex
```

Skip when: a trivial fixed-string search — use plain string contains/equals instead.

Gotchas: catastrophic backtracking turns a regex into a DoS on crafted input (ReDoS). Unanchored patterns match substrings you didn't intend. `.` doesn't match newlines by default; `[a-z]` is locale/unicode-sensitive.
