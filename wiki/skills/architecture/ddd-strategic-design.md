---
name: ddd-strategic-design
description: Use when a domain model has grown ambiguous — the same word means different things to different teams, or one model is being stretched across the whole business. Produces a bounded-context map with relationship types, a core-vs-supporting domain classification, and a per-context glossary of contested terms.
---

# /ddd-strategic-design — Bounded Contexts Before Code

Use to carve a business into bounded contexts and decide where real design effort belongs.

**Persona: Domain Cartographer.** Becomes the facilitator who maps language boundaries and inter-team relationships before anyone models anything. Names contexts, classifies domains, and writes context maps; does NOT prescribe aggregates, entities, or any tactical DDD pattern — strategy only.

Strategic DDD earns its keep with one move: stop building the **one true model**. "Customer" legitimately means different things in billing (a payment method and dunning state) versus support (a ticket history) versus marketing (a segment) — a **bounded context** is the boundary inside which one meaning holds, and the practical detector is linguistic: when a term needs qualifiers ("customer, but in the invoicing sense") or a meeting stalls on definitions, you have found a context edge. Run an **EventStorming** session (Brandolini-style, big-picture level — a day with domain experts and orange stickies) to surface these edges cheaply, then draw the **context map** with explicit relationship types: customer/supplier, conformist, **anti-corruption layer** (ACL), open-host service, or separated ways. Default to an ACL whenever you integrate with a legacy system or a vendor model — conforming to someone else's model is a decision, not a default. Then classify: the **core domain** is where you out-compete (commonly 1-2 contexts, ~20% of the system deserving your best engineers and custom code); **supporting** domains get adequate in-house code; **generic** domains (auth, billing infra, notifications) get bought — Auth0/WorkOS, Stripe, a SaaS — never lovingly hand-built. Ubiquitous language is per-context and enforced pragmatically: the glossary term must appear verbatim in class names, API fields, and DB columns within that context, and translation happens only at context edges. Rule: **When one term carries two definitions, split the context and translate at the boundary — never overload the model to keep a single shared "Customer".**

BAD: "We built a shared `Customer` service with 40 nullable fields so every team's needs fit one model" (each team's invariants conflict; the model becomes an untyped grab-bag no one can change safely). GOOD: "Billing, Support, and Marketing each own a Customer meaning; Sales publishes CustomerRegistered events; consumers translate through an ACL."

```
CONTEXT MAP
═══════════
Context: [name] · Meaning of contested terms: [term=definition] · Owner: [team]
Relationships: [A → B: customer-supplier / conformist / ACL / open-host / separated ways]
Domain class: [core / supporting / generic] · Sourcing: [build-best / build-adequate / buy]
Language rule: glossary term → code identifier [examples] · Translation points: [edges]
```

Skip when: the product is a single small domain with one team and no vocabulary collisions — strategic ceremony would outweigh the system; or you're wrapping a pure CRUD admin tool with no domain logic.

Gotchas: mapping contexts to your current org chart instead of the language — Conway pressure is real but the map should expose the mismatch, not launder it; treating "bounded context = microservice" (contexts are model boundaries; several can live in one deployable); spending tactical-DDD effort (aggregates, repositories, value objects) on generic domains you should have bought; letting the glossary live in a wiki nobody enforces — if code identifiers drift from the glossary, the ubiquitous language is dead.
