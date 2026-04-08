---
name: api-contract
description: API Design.
---

# /api-contract — API Design

For each endpoint:
- Method + path + description
- Request: headers, params, body (with types and examples)
- Response: success shape, every error code with format
- Auth requirement, rate limit

Error contract: consistent format (RFC 7807 recommended). Never expose internals.
Generate OpenAPI spec if possible.

```
API CONTRACT
════════════
[METHOD] [/path] — [description]
  Auth: [requirement]  Rate limit: [limit]
  Request:
    Headers: [header list]
    Body: { [field]: [type] — [example] }
  Response 200: { [field]: [type] }
  Error 4xx/5xx: { type, title, status, detail } (RFC 7807)
──────────────
Endpoints: [count] | Errors documented: [count]
OpenAPI spec: [generated / not applicable]
```

Gotchas: Don't expose internal error details (stack traces, DB errors) in API responses -- use RFC 7807 error format. Don't version by URL path unless you can maintain multiple versions indefinitely. Don't skip documenting error codes -- clients can't handle errors they don't know about.
