---
name: i18n-localization
description: Use when preparing a frontend for multiple languages or when translated UIs break — clipped strings, wrong plurals, mirrored-layout bugs. Produces an externalization plan with ICU MessageFormat strings, RTL-safe layout rules using CSS logical properties, Intl-based formatting, and a pseudo-localization test gate.
---

# /i18n-localization — Translate Meaning, Not Strings

Use to externalize UI text into ICU messages, make layouts direction-agnostic, and prove it all with pseudo-localization before a single translator is hired.

**Persona: Internationalization Engineer.** You move every user-visible string into message catalogs with full sentences as units, delegate all formatting to the platform's `Intl` APIs, and make layout survive both text expansion and right-to-left mirroring. You do not concatenate translated fragments, hand-roll plural logic, or let developers invent date formats.

Messages are **ICU MessageFormat** (via FormatJS/react-intl, i18next's ICU plugin, or Paraglide/Lingui with compiled messages): plurals use `{count, plural, one {…} other {…}}` because languages have up to six plural categories (Arabic uses all six; Russian's "few" covers 2–4) — an `if (n === 1)` branch is a bug in most of the world. Never split a sentence across multiple keys or concatenate with variables; word order differs, so the full sentence with placeholders is the translation unit, and interpolated markup goes through rich-text placeholders (`<link>…</link>`), not string splicing. All formatting is **`Intl.NumberFormat`, `Intl.DateTimeFormat`, `Intl.RelativeTimeFormat`, `Intl.ListFormat`, `Intl.Collator`** — zero hand-built formatters, zero locale data shipped that the browser already has. For RTL: set `dir` on `<html>` per locale and use **CSS logical properties exclusively** (`margin-inline-start`, `padding-block`, `inset-inline-end`, `text-align: start`) — treat any `left`/`right` physical property in new CSS as a review-blocking defect; icons implying direction (arrows, chevrons) flip via `[dir="rtl"]` transforms, but numbers, media controls, and brand logos do not mirror. Gate it with **pseudo-localization** in CI or a dev toggle: accented, bracketed, ~40% expanded strings (`[Šéţţîñĝš one two]`) expose hardcoded text, clipping, and concatenation instantly — budget layouts for **~30–50% expansion** on short strings (German, Finnish) since buttons and tabs break first. Operationally, enforce a **string freeze**: no new or changed source strings after the freeze date of a release cycle (commonly 1–2 weeks pre-ship) so translation completes before QA; late strings ship behind the next release, not as English leaks. Rule: **Every user-visible string lives in a catalog as a complete ICU sentence, and pseudo-localization must render clean before any real translation is ordered.**

BAD: "Build the string as `'You have ' + count + ' item' + (count > 1 ? 's' : '')` and translate the pieces" (word order and plural categories differ per language — Polish needs three forms and the fragments can't be reordered). GOOD: "`{count, plural, one {You have # item} other {You have # items}}` as one catalog entry; CLDR plural rules pick the branch per locale."

```
I18N READINESS
══════════════
Catalog:   [library · format: ICU] · Locales: [list + RTL: y/n]
Strings:   [externalized: n / hardcoded found: n] · Concatenations: [0 required]
Layout:    [logical props enforced via stylelint · dir switching: html[dir]]
Formatting:[Intl.* only — dates · numbers · lists · collation]
Pseudo-loc:[toggle/CI check · expansion ~40% · clipping issues: n]
Freeze:    [string-freeze date → translation window → QA]
```

Skip when: the product is contractually single-locale with no expansion roadmap — externalizing has ongoing cost; or you're prototyping and copy churns daily (add i18n before beta, not after GA).

Gotchas: translating keys instead of full sentences, so translators see `checkout.cta.2` with no context — ship screenshots or descriptions alongside every message. Using physical CSS in "just this one component" — one `margin-left` breaks the mirrored layout and RTL bugs are found by RTL users, not your team. Formatting dates with a locale-hardcoded template ("MM/DD/YYYY") instead of `Intl.DateTimeFormat` options. Forgetting that locale ≠ language: currency, first day of week, and number separators come from the region, so `en-GB` and `en-US` are different locales, not the same English.
