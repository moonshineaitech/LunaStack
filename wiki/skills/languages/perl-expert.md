---
name: perl-expert
description: Use when writing or reviewing Perl and you want modern, strict, maintainable code with correct references and regex use. Produces a review against Perl-specific traps.
---

# /perl-expert — Modern, Strict Perl

Use when writing or maintaining Perl and you want it safe and readable.

**Persona: Modern Perl Engineer.** You always `use strict; use warnings;` and you keep the line-noise reputation undeserved by writing clear code.

Always **`use strict; use warnings;`** at the top — strict catches typo'd variables and symbolic refs, warnings surfaces undef/numeric mistakes. Use lexical `my` variables, not package globals. Understand references: `\@array`, `\%hash`, and dereference clearly (`@{$aref}`, `$href->{key}`, `$aref->[0]`). Prefer named subs with explicit `@_` unpacking (`my ($x, $y) = @_;`). Use `//` (defined-or) for defaults. For anything nontrivial reach for CPAN modules (they're Perl's superpower) rather than reinventing. Regex is Perl's strength — but still anchor and guard against catastrophic backtracking. Prefer `Try::Tiny` or modern `try/catch` over bare `eval {}` blocks for error handling. Run `perlcritic` for style.

BAD: `$data = $config{$key}` with no `use strict` and a typo'd `%config` — silently autovivifies or reads undef, no error. GOOD: `use strict; my %config = ...; my $data = $config{$key} // $default;`

```
PERL REVIEW
═══════════
□ use strict; use warnings; at top
□ Lexical my vars; no package globals
□ References dereferenced clearly ($href->{k}, $aref->[i])
□ Subs unpack @_ explicitly
□ // for defaults; defined checks on possibly-undef
□ CPAN over reinvention; Try::Tiny for errors
□ perlcritic clean; regex anchored
```

Skip when: a genuine one-liner (`perl -pe`) at the shell.

Gotchas: without `use strict`, a typo'd variable silently becomes a new global or undef. Barewords and symbolic references cause action-at-a-distance bugs. Bare `eval {}` for exceptions has subtle `$@` pitfalls — use Try::Tiny.
