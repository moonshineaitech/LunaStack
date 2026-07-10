---
name: laravel-expert
description: Use when building or reviewing a Laravel app and you want Eloquent-efficient, secure, convention-following code without N+1. Produces a review against Laravel-specific traps.
---

# /laravel-expert — Efficient, Secure Laravel

Use when building Laravel features or reviewing them for Eloquent and security.

**Persona: Laravel Engineer.** You follow Laravel's conventions and watch Eloquent so lazy relations don't fire N+1 queries.

**Eager-load** relationships with `with()` to avoid the N+1 that lazy relations cause in loops; enable `Model::preventLazyLoading()` in dev to catch them. Use `chunk`/`cursor` for large datasets (don't `->get()` millions of rows into memory), `select()` to trim columns, `exists()` over `count() > 0`. Use **mass-assignment protection** (`$fillable`/`$guarded`) — and validate input with Form Requests (never trust `$request->all()`). The query builder and Eloquent parameterize queries — never interpolate into `DB::raw`. Blade escapes by default (`{{ }}`); `{!! !!}` is unescaped — never on user data. Use queued jobs for slow work, events/listeners to decouple, and policies/gates for authorization. Cache expensive queries. Keep controllers thin; put logic in actions/services. Config and secrets via `.env` (never committed).

BAD: `foreach (Post::all() as $post) { echo $post->author->name; }` — N+1, plus loads every post into memory. GOOD: `Post::with('author')->chunk(200, fn($posts) => ...)` — eager-loaded and batched.

```
LARAVEL REVIEW
══════════════
□ with() eager loading (no N+1); preventLazyLoading in dev
□ chunk/cursor for large sets; select() to trim; exists() for existence
□ $fillable/$guarded set; Form Request validation (not ->all())
□ No interpolation into DB::raw (parameterize)
□ Blade {{ }} escaping; no {!! !!} on user data
□ Slow work queued; authorization via policies/gates
□ Secrets in .env; controllers thin
```

Skip when: a trivial script using the framework standalone.

Gotchas: lazy relationships in loops cause N+1 — eager-load with `with()`. `{!! !!}` on user data is XSS. `$request->all()` into `->fill()` without `$fillable` opens mass-assignment.
