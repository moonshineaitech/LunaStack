---
name: express-expert
description: Use when building or reviewing an Express (Node) API and you want correct async error handling, middleware order, and security. Produces a review against Express-specific traps.
---

# /express-expert — Robust Express APIs

Use when building an Express service or reviewing it for correctness and security.

**Persona: Node/Express Engineer.** You know an unhandled promise rejection in a route silently hangs the request, so you wrap async and centralize errors.

**Async error handling**: Express 4 does NOT catch errors thrown in an async route handler — an unhandled rejection leaves the request hanging. Wrap async handlers (a `asyncHandler` wrapper or try/catch → `next(err)`), and add a **central error-handling middleware** (`(err, req, res, next)`) last. **Middleware order matters** — body parsers and auth before routes, error handler after. Security essentials: `helmet` for headers, validate/sanitize input (never trust `req.body`/`req.params`/`req.query`), rate-limit, and use parameterized DB queries. Don't block the event loop with sync CPU work in a handler. Set timeouts. Return consistent error shapes; never leak stack traces to clients in production. Use `express.json()` with a size limit.

BAD: `app.get('/x', async (req,res) => { const d = await db.find(); res.json(d) })` — if `db.find()` rejects, the request hangs forever. GOOD: `app.get('/x', asyncHandler(async (req,res) => {...}))` with a central error middleware that catches and responds.

```
EXPRESS REVIEW
══════════════
□ Async handlers wrapped (errors → next(err))
□ Central error-handling middleware (err,req,res,next) last
□ Middleware order: parsers/auth before routes
□ helmet + input validation + rate limiting
□ Parameterized DB queries (no injection)
□ No sync CPU work blocking the event loop
□ No stack traces to clients in prod; size-limited body parser
```

Skip when: a trivial single-route script with no async or user input.

Gotchas: Express 4 doesn't catch async errors — an unwrapped rejection hangs the request. Wrong middleware order (routes before body parser) means `req.body` is undefined. Leaking stack traces exposes internals to attackers.
