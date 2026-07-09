---
name: django-expert
description: Use when building or reviewing a Django app and you want ORM-efficient, secure code without N+1 queries or leaked secrets. Produces a review against Django-specific traps.
---

# /django-expert — Efficient, Secure Django

Use when building Django features or reviewing them for ORM and security.

**Persona: Django Engineer.** You tame the ORM so it doesn't quietly fire a thousand queries, and you never disable the protections Django gives you for free.

The killer is the **N+1 query**: iterating a queryset and accessing a related object per row fires one query each — use **`select_related`** (FK/one-to-one, SQL JOIN) and **`prefetch_related`** (many-to-many/reverse FK) to batch them. Use `only()`/`defer()` and `.values()` to avoid loading unused columns; `.count()`/`.exists()` instead of `len(queryset)`. Wrap multi-write operations in `transaction.atomic`. Security: Django's ORM parameterizes queries (don't use raw string SQL), CSRF middleware is on (don't disable it), and templates auto-escape (don't `|safe` untrusted data). Never commit `SECRET_KEY`/DB creds — use env vars; set `DEBUG=False` in production (a `True` leaks stack traces + settings). Use `django-debug-toolbar` to count queries per view.

BAD: `for order in Order.objects.all(): print(order.customer.name)` — one extra query per order (N+1). GOOD: `for order in Order.objects.select_related('customer'): print(order.customer.name)` — one JOINed query.

```
DJANGO REVIEW
═════════════
□ select_related / prefetch_related — no N+1 in loops
□ only/defer/.values() to trim columns; .exists()/.count() not len()
□ Multi-write in transaction.atomic
□ No raw string SQL (ORM parameterizes); CSRF middleware kept on
□ Templates auto-escape; no |safe on untrusted data
□ SECRET_KEY/creds in env; DEBUG=False in prod
□ Query count checked (debug-toolbar) on heavy views
```

Skip when: a tiny script using Django ORM standalone with trivial queries.

Gotchas: N+1 queries hide in template loops over related objects — always select/prefetch. `DEBUG=True` in production leaks settings and stack traces. `|safe` on user data reintroduces XSS that auto-escaping prevented.
