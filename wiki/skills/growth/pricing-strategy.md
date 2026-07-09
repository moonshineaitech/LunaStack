---
name: pricing-strategy
description: Use when setting or revising SaaS pricing and you want value-based tiers with the right metric, not cost-plus guessing. Produces a pricing structure with a value metric and tiers.
---

# /pricing-strategy — Value-Based SaaS Pricing

Use when pricing a new product or fixing pricing that leaves money on the table.

**Persona: Pricing Strategist.** You price on the value delivered and pick a metric that grows with the customer, not on your costs.

Price on **value, not cost-plus** — what the outcome is worth to the buyer sets the ceiling. Choose a **value metric** that scales with the customer's success (seats, API calls, contacts, GB, transactions) so revenue grows as they get more value — a good metric aligns your price with their usage and makes expansion automatic. Design **3 tiers** (a well-known heuristic): a cheap/entry tier, a **middle tier where you steer most buyers** (anchor it as the obvious choice), and a high/enterprise tier that makes the middle look reasonable and captures big accounts. Differentiate tiers by value-correlated features + the metric's included allowance, not arbitrary feature gating. Consider a free tier/trial only if it drives conversion (measure it). Review willingness-to-pay with real customer conversations or Van Westendorp, not internal guessing. Bill annually (with a discount) to improve cash + retention. Grandfather existing customers on price changes. Watch that cost-to-serve the cheapest tier stays below its price.

BAD: "cost is $2/user so we'll charge $3" — cost-plus ignores that the outcome is worth $50/user, leaving 94% of the value uncaptured; and a flat price doesn't grow with the account. GOOD: value metric = active seats, three tiers steering to the $29 middle, annual billing, priced from customer willingness-to-pay research.

```
PRICING STRUCTURE
═════════════════
Basis:       value-based (outcome worth), not cost-plus
Value metric:[seats/calls/contacts/GB — scales with customer value]
Tiers:       entry | MIDDLE (steer here) | enterprise
Differentiation: value-correlated features + metric allowance
WTP source:  [customer convos / Van Westendorp] (not internal guess)
Billing:     annual w/ discount (cash + retention); grandfather existing
Guardrail:   cost-to-serve cheapest tier < its price
```

Skip when: pre-product with no value signal yet — talk to users first.

Gotchas: cost-plus pricing leaves most of the value uncaptured. A flat price (no value metric) doesn't grow with the account and caps expansion revenue. Setting price from internal guesses instead of customer willingness-to-pay research misses the market.
