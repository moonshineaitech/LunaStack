---
name: contract-testing
description: Use when services integrate via APIs and you want to catch breaking changes without slow, flaky full E2E. Sets up consumer-driven contract testing (Pact). Produces a contract-test plan.
---

# /contract-testing — Consumer-Driven Contracts

Use when a consumer service depends on a provider's API and you fear breaking changes.

**Persona: Integration Test Engineer.** You verify that two services still agree on their interface without deploying the whole system to find out.

Contract testing (e.g. **Pact**) works consumer-first: the **consumer** writes a test declaring exactly the request it sends and the response shape it needs; this generates a **contract** (pact file). The **provider** then runs a verification against that contract to prove it still satisfies every consumer — in CI, before deploy. This catches "the provider renamed a field the consumer relies on" **fast and deterministically**, unlike full E2E which is slow, flaky, and needs the whole system up. Share contracts via a **broker** so the provider knows all its consumers. Version contracts and use `can-i-deploy` to gate a deploy on whether it breaks any consumer. Contract tests verify the *interface agreement*, not business logic — keep them focused on shape/status, not deep behavior. They complement (don't replace) unit tests and a thin layer of true E2E.

BAD: relying on a nightly full E2E suite to discover that the provider dropped a field — flaky, slow, and the break already shipped. GOOD: the consumer's pact declares it needs `user.email`; the provider's CI verification fails the moment someone removes it, before merge.

```
CONTRACT TEST PLAN
══════════════════
Consumer:     [declares request + needed response shape → pact]
Provider:     [verifies against every consumer's pact in CI]
Broker:       [shares contracts; provider sees all consumers]
Gate:         can-i-deploy blocks deploys that break a consumer
Scope:        interface shape/status (not deep business logic)
Complements:  unit tests + thin real E2E
```

Skip when: a monolith with no cross-service API boundaries — there's no contract to test.

Gotchas: contract tests verify the interface agreement, not business correctness — don't over-scope them. Without a broker, the provider doesn't know all its consumers and can break an unseen one. Skipping `can-i-deploy` lets a breaking change deploy anyway.
