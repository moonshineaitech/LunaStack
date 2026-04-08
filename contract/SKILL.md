---
name: contract
description: Behavioral Contracts.
---

# /contract — Behavioral Contracts

For any interface between two components:
- Inputs (types, constraints, what's rejected)
- Outputs (success, partial, failure shapes)
- Invariants (always true: latency, idempotency, ordering)
- Side effects and failure handling
- Tests: provider-side AND consumer-side

```
CONTRACT: [Module A] ↔ [Module B]
══════════════════════════════════

INTERFACE
  Method:      [function signature or API endpoint]
  Input:       [types, constraints, what's rejected]
  Output:      
    Success:   [shape + example]
    Partial:   [shape — if applicable]  
    Failure:   [error types + shapes]
  
INVARIANTS (always true)
  □ [Response time < X ms at p95]
  □ [Idempotent — same input always produces same result]
  □ [Ordering: events delivered in causal order]

SIDE EFFECTS
  [What else happens — events emitted, cache invalidated, notifications sent]

FAILURE HANDLING
  [Timeout after Xms → retry with backoff → circuit breaker after N failures]

TESTS
  Provider-side: [test that the module honors this contract]
  Consumer-side: [test that the consumer handles all response shapes]
```
