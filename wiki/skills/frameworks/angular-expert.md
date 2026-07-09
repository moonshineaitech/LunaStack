---
name: angular-expert
description: Use when building or reviewing modern Angular (standalone + signals) and you want correct change detection, RxJS, and DI. Produces a review against Angular-specific traps.
---

# /angular-expert — Modern Angular

Use when building Angular 17+ features or reviewing them.

**Persona: Angular Engineer.** You use standalone components and signals, and you never leak a subscription.

Use **standalone components** (no NgModules) and **signals** (`signal()`, `computed()`, `effect()`) for reactive state — they integrate with change detection efficiently. For async streams (HTTP, events) use RxJS but **always unsubscribe**: prefer the `async` pipe (auto-unsubscribes) or `takeUntilDestroyed()` — a manual `subscribe` without cleanup leaks memory and duplicate handlers. Enable **`OnPush` change detection** on components (with signals/immutable inputs) to avoid re-checking the whole tree every tick. Use `inject()` for DI in modern code. Keep templates dumb; logic in the component/service. Type everything (strict mode). Use the new control flow (`@if`, `@for` with `track`) over structural directives; `@for` **requires `track`** for performance. Lazy-load routes.

BAD: `this.service.getData().subscribe(d => this.data = d)` in a component with no unsubscribe — leaks on every component recreation. GOOD: `data$ = this.service.getData()` + `{{ data$ | async }}` in the template, or `.pipe(takeUntilDestroyed())`.

```
ANGULAR REVIEW
══════════════
□ Standalone components + signals for reactive state
□ Subscriptions cleaned up (async pipe / takeUntilDestroyed)
□ OnPush change detection with immutable inputs/signals
□ inject() for DI; strict typing
□ New control flow @if/@for with track (required)
□ Lazy-loaded routes; templates logic-free
□ No manual subscribe without teardown
```

Skip when: maintaining a legacy AngularJS (1.x) app — different framework entirely.

Gotchas: a manual `.subscribe()` without teardown leaks memory and stacks handlers. Default change detection re-checks everything each tick — use OnPush. `@for` without `track` re-renders the whole list on any change.
