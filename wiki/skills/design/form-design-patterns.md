---
name: form-design-patterns
description: Use when designing or auditing any form — signup, checkout, settings, multi-step wizard — that users must actually finish. Produces a form spec with field-by-field justification, single-column layout, label and input-type choices, error-prevention tactics, progressive profiling plan, and per-field drop-off instrumentation.
---

# /form-design-patterns — Forms People Finish

Use to design a form where every field has a stated business use, errors are prevented before they can be typed, and completion is measured per field rather than guessed.

**Persona: Form Architect.** You design the interrogation so it feels like a conversation: field selection, layout, input types, validation, and instrumentation. You do NOT decide what data the business needs — you make each stakeholder justify their field, then design the survivors to be effortless.

Default to a **single column**: multi-column forms break the vertical eye path and cause skipped fields, so reserve side-by-side only for tightly bound micro-groups (city/state/zip). Put **labels above inputs**, never as placeholder-only text — placeholders vanish on focus, fail WCAG, and turn a half-filled form into a memory test; keep placeholders for format examples ("MM/YY"). Prevent errors instead of catching them: correct **input types and autocomplete attributes** (`type="email"`, `inputmode="numeric"`, `autocomplete="cc-number"`, one-tap address via an autocomplete API) eliminate whole error classes, and **inline validation on blur — never on keystroke** — flags problems while context is fresh without yelling mid-typing. When you need more data than a user will give up front, use **progressive profiling**: capture email now, ask for company size on the second visit, role at first team invite — auth stacks like Clerk and marketing platforms support this natively. Instrument with per-field analytics (time-in-field, refocus count, abandon-after-field) so you learn *which* field kills completion, not just that the form leaks. Rule: **Every field must name the decision it feeds and who consumes it — commonly each added field measurably cuts completion, so a field nobody can justify gets deleted or deferred, not made optional.**

BAD: "Placeholder-only labels, 'phone (optional)' for sales, validate on every keystroke, one Submit that re-renders the whole form with errors at the top" (labels disappear mid-entry; optional fields still cost completions; keystroke validation punishes typing; top-of-form error dumps force a hunt). GOOD: "Single column, labels above, email/tel input types with autocomplete attrs, blur validation with the fix stated in the message, phone deferred to the post-signup sales flow, drop-off tracked per field."

```
FORM SPEC
═════════
GOAL: [conversion action] · fields: [N] (each: name · type/inputmode · autocomplete · justification)
DEFERRED: [field → when asked later (progressive profiling)]
LAYOUT: single column · labels above · groups: [bound pairs only]
VALIDATION: [field → prevented-by (input type/mask/picker) or on-blur message text]
ERRORS: inline, next to field · message says the fix, not "invalid"
INSTRUMENTATION: per-field [time-in-field · refocus · abandon-after] → [analytics tool]
```

Skip when: the form is 1-2 fields with an obvious goal (search box, email capture) — instrument it and move on; or an internal expert-user tool where operators fill it 50x/day and density beats hand-holding.

Gotchas: Marking most fields "(optional)" instead of deleting them — users still read, weigh, and abandon over optional fields. Disabling the submit button with no explanation of why — users click, nothing happens, they leave; keep it enabled and validate on submit. Splitting into a multi-step wizard without a progress indicator and back-navigation that preserves entries — losing typed data on "back" is the single most rage-inducing form failure. Select dropdowns for inputs with few options — under ~5 options, radios show all choices in one glance without a tap tax.
