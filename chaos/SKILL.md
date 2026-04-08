---
name: chaos
description: Fault Injection.
---

# /chaos — Fault Injection

Test these scenarios:
- API returns 500, times out (30s), returns malformed data
- Database query takes 10s
- Empty/null/huge inputs in every field
- Same form submitted twice simultaneously
- Rate limit exceeded

For each: what happened? Was the error message useful? Did the system recover?
