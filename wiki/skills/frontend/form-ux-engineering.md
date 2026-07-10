---
name: form-ux-engineering
description: Use when building or fixing any non-trivial form — signup, checkout, multi-step wizards — or when form abandonment is high. Produces a validation-timing spec, rewritten error messages, correct autofill/autocomplete attributes, and a multi-step state plan.
---

# /form-ux-engineering — Reward Early, Punish Late

Use to engineer forms where validation timing, error copy, and autofill do the persuading.

**Persona: Form UX Engineer.** You treat validation timing as the core mechanic — "reward early, punish late" — write error messages that state the fix, and wire autofill attributes so the browser does the typing. You do not validate on every keystroke of an untouched field, and you do not block paste anywhere, ever.

The timing law: a field shows its first error **on blur**, never while the user is still typing it; once a field is in an error state, it re-validates **on every change** so the error disappears the instant it's fixed (that's the reward). Async checks (username taken) debounce ~500ms after blur with a pending indicator. Error copy states what to enter, not what failed — "Enter the 16-digit number on the front of your card," never "Invalid input" — placed adjacent to the field, tied via `aria-describedby`, with the field marked `aria-invalid`; on submit, move focus to the first errored field. **Autofill is a conversion feature**: correct `autocomplete` tokens (`email`, `given-name`, `postal-code`, `one-time-code` for SMS codes, `new-password` vs `current-password`) plus `inputmode`/`type` for the right mobile keyboard routinely cut completion time dramatically — and wrong tokens actively corrupt autofill, worse than none. Never `preventDefault` paste in password or confirmation fields. Structure: labels always visible (placeholders are not labels — they vanish on focus and fail recall), one column, and past **~7 fields split into steps** grouped by topic, with each step's state persisted to `sessionStorage` on step-change so back-button, refresh, or an OAuth round-trip loses nothing; show a step indicator and validate per-step, not at the end. Rule: **First error on blur, error clears on change — any form that yells at an untouched or in-progress field, or that only reveals errors after submit, is mistimed and will bleed completions.**

BAD: "Validate onChange so users get instant feedback" (the email field screams "invalid" from the first character typed — punishing users for not being done). GOOD: "Silent while typing, error on blur, error clears live once they're fixing it — plus `autocomplete='email' inputmode='email'` so most users never type at all."

```
FORM SPEC
═════════
Timing:    [blur → first error · change → revalidate errored · async ~500ms]
Errors:    [copy states the fix · aria-describedby/-invalid · focus first]
Autofill:  [field → autocomplete token · inputmode · type]
Steps:     [>~7 fields → n steps · sessionStorage persist · per-step validate]
Never:     [blocked paste · placeholder-as-label · errors only on submit]
```

Skip when: single-field forms (search, newsletter) — validate on submit and move on; or the platform's form framework already enforces these patterns.

Gotchas: disabling the submit button until valid — users get no explanation of what's missing; keep it enabled and surface errors on submit instead. Splitting one credit-card input into four boxes with auto-advance, which breaks paste, autofill, and backspace at once. Rejecting valid input with over-eager regex (plus-addressed emails, spaces in card numbers — strip, don't reject). Losing 9 minutes of wizard input because step state lived only in component memory when the session bounced through a payment redirect.
