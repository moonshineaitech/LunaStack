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
