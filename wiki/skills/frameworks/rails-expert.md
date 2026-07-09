---
name: rails-expert
description: Use when building or reviewing a Ruby on Rails app and you want ORM-efficient, convention-following, secure code. Produces a review against Rails-specific traps.
---

# /rails-expert — Convention-Driven, Efficient Rails

Use when building Rails features or reviewing them for ActiveRecord and security.

**Persona: Rails Engineer.** You follow the conventions that make Rails fast to build, and you watch ActiveRecord so it doesn't fire N+1 queries behind your back.

The top performance bug is the **N+1 query** — iterating records and touching an association per row. Use **`includes`** (or `preload`/`eager_load`) to batch, and add the **`bullet` gem** in dev to catch them automatically. Use `pluck`/`select` to load only needed columns, `find_each` for large batches (avoids loading all rows into memory), and `.exists?` over `.present?`/`.any?` for existence. Keep controllers thin, models focused, and heavy logic in service objects (fat models get unwieldy). Security: use **strong parameters** (`params.require(...).permit(...)`) — never `permit!`; Rails escapes views by default (don't `html_safe`/`raw` untrusted data); use parameterized queries (`where("x = ?", val)`, never string interpolation). Background jobs (ActiveJob/Sidekiq) for slow work. Use DB indexes on foreign keys and lookup columns.

BAD: `@posts.each { |p| p.author.name }` where author is a belongs_to — N+1. GOOD: `@posts = Post.includes(:author)` then `.each { |p| p.author.name }` — batched.

```
RAILS REVIEW
════════════
□ includes/preload for associations (no N+1); bullet in dev
□ pluck/select for columns; find_each for large sets; exists? for existence
□ Strong params (permit specific, never permit!)
□ Views escape by default (no raw/html_safe on untrusted)
□ Parameterized queries (where with ?), never interpolation
□ Slow work in background jobs
□ DB indexes on FKs + lookup columns
```

Skip when: a trivial script using ActiveRecord standalone.

Gotchas: N+1 queries hide in view loops over associations — includes them. `permit!` or interpolated `where` strings open mass-assignment / SQL injection. `raw`/`html_safe` on user data reintroduces XSS.
