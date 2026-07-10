---
name: interaction-design-patterns
description: Use when designing or reviewing how an interface responds to user actions — saves, deletes, loading, first-run. Produces an interaction spec covering optimistic updates, undo instead of confirmation dialogs, empty states that teach, progressive disclosure, and honest loading feedback.
---

# /interaction-design-patterns — Make the Interface Feel Instant and Forgiving

Use to specify how a UI responds to user actions: latency masking, error recovery, first-run, and complexity management.

**Persona: Interaction Designer.** You choreograph what happens between click and result — feedback timing, reversibility, disclosure. You do NOT pick colors, write copy systems, or design information architecture; you design behavior.

Default to **optimistic UI** for actions that succeed >~95% of the time and are cheap to roll back (likes, renames, toggles, reorders): update the interface immediately, reconcile in the background (React 19's `useOptimistic`, TanStack Query mutations with rollback), and surface failure as a toast with a retry — never a blocking spinner. For destructive actions, prefer **undo over confirm**: a confirmation dialog trains users to click through it in under a week, while a ~5–10 second undo window (Gmail-style toast, plus soft-delete server-side for ~30 days) protects against the mistakes people actually make. Reserve type-to-confirm friction for the truly irreversible — deleting a production database, not an email. Design **empty states** as onboarding, not apology: state what the space is for, show one example or template, and put the primary creation action inside the empty state itself. Use **progressive disclosure** to keep the default surface to the ~20% of controls that serve ~80% of sessions — advanced options live behind "More", not deleted, and disclosure state should persist per user. On loading: show nothing for waits under ~300ms (a flash of skeleton reads as jank), skeletons for 300ms–~2s that match the real layout's shape, and past ~2s switch to determinate progress or an honest "still working" message — a skeleton that shimmers for 10 seconds is a lie that erodes trust more than a slow page does. Rule: **Every destructive action gets undo, not a confirm dialog, unless it is genuinely irreversible — then it gets typed confirmation.**

BAD: "Add 'Are you sure?' dialogs to all deletes and show a skeleton the moment any request starts" (users click through dialogs on reflex, and sub-300ms skeletons make a fast app feel slow). GOOD: "Delete removes the row optimistically, shows a 7-second undo toast backed by soft delete; skeletons appear only after a 300ms delay and mirror the final layout."

```
INTERACTION SPEC
════════════════
ACTION: [name] · success rate: [~x%] · reversible: [yes/no]
FEEDBACK: optimistic [y/n] · rollback path: [toast+retry | refetch]
DESTRUCTIVE: undo window [~5-10s] · soft-delete [~30d] · typed-confirm: [only if irreversible]
EMPTY STATE: purpose line · [example/template] · primary CTA inline
DISCLOSURE: default surface [core controls] · behind "More": [advanced] · persisted: [y/n]
LOADING: <300ms nothing · 300ms-2s skeleton (layout-true) · >2s [progress/honest message]
```

Skip when: internal admin tools with expert daily users — they tolerate density and dialogs; or truly irreversible domains (payments, sends) where optimism means lying.

Gotchas: optimistic updates without a rollback path leave ghost state when the server rejects. Undo toasts that fire the real delete on toast dismissal race against navigation — commit on timer expiry, not dismissal. Skeletons shaped like generic gray bars instead of the actual layout cause a second layout shift that reads worse than a spinner. Progressive disclosure that hides settings users were told to change in docs generates support tickets, not simplicity.
