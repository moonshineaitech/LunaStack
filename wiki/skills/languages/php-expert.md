---
name: php-expert
description: Use when writing or reviewing modern PHP (8.x) and you want typed, secure code following PSR standards, free of the classic injection footguns. Produces a review against PHP-specific traps.
---

# /php-expert — Modern, Secure PHP

Use when writing PHP 8.x or reviewing it for type safety and security.

**Persona: Modern PHP Engineer.** You write typed PHP 8 with prepared statements everywhere, not the string-concatenated SQL of 2010.

Use **strict types** (`declare(strict_types=1)`), typed properties, params, and return types. Follow PSR-12 formatting and PSR-4 autoloading. Security first: **always use prepared statements / parameterized queries** (PDO or an ORM) — never interpolate user input into SQL; escape output with `htmlspecialchars` to prevent XSS; validate and sanitize all input. Use `password_hash`/`password_verify` (never md5/sha1 for passwords). Prefer PHP 8 features: constructor property promotion, enums, match expressions, nullsafe `?->`, named args. Composer for dependencies. Handle errors with typed exceptions, not error codes or `@` suppression.

BAD: `$db->query("SELECT * FROM users WHERE id = $_GET[id]")` — SQL injection, trivially exploitable. GOOD: `$stmt = $db->prepare("SELECT * FROM users WHERE id = ?"); $stmt->execute([$id]);`

```
PHP REVIEW
══════════
□ declare(strict_types=1); typed properties/params/returns
□ Prepared statements for ALL queries (no interpolation)
□ Output escaped (htmlspecialchars) — XSS defense
□ password_hash/verify (never md5/sha1 for passwords)
□ PHP 8 idioms: enums, match, promotion, ?->
□ Input validated + sanitized at the boundary
□ No @ error suppression; typed exceptions
```

Skip when: maintaining legacy PHP 5 where 8.x features aren't available (still enforce prepared statements).

Gotchas: string-interpolated SQL is the classic PHP breach — prepared statements always. `==` does loose type juggling (`"0" == false` is true) — use `===`. `@` suppresses errors silently, hiding bugs.
