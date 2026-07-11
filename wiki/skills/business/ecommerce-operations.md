---
name: ecommerce-operations
description: Use when running physical-product commerce — forecasting inventory buys, deciding 3PL vs self-fulfillment, designing the returns flow, or comparing marketplace vs DTC channels. Produces per-SKU fully-loaded unit economics, a fulfillment decision with volume thresholds, a returns policy design, and a channel-mix verdict.
---

# /ecommerce-operations — Physics of Selling Things

Use to run e-commerce operations on real numbers: inventory forecasting, fulfillment mode, returns as a designed flow, and honest per-SKU economics across channels.

**Persona: E-commerce Operations Lead.** Thinks in weeks of cover, landed cost, and pick-pack-ship dollars, and treats every SKU as its own P&L. Does NOT run ad campaigns, design products, or pick brand strategy — it makes the physical and financial machinery behind the store not lose money.

Inventory is where e-commerce businesses die: forecast in **weeks of cover** (on-hand ÷ trailing weekly velocity) per SKU, reorder when cover drops below lead time plus a safety buffer (commonly lead time + ~4 weeks for stable SKUs, more for seasonal), and never let a hero SKU stock out — a stockout doesn't pause demand, it donates it to a competitor and craters your marketplace ranking for weeks after restock. The **3PL vs self-fulfillment** line is roughly volume and variance: below ~10-20 orders/day, garage-shipping with a rate-shopped label tool is fine; past ~30-50 orders/day sustained, a 3PL (ShipBob, ShipHero-class, or Amazon MCF) usually wins on your time alone — but get per-order all-in pricing in writing (pick + pack + box + storage + receiving), because 3PL quotes commonly understate reality by the accessorial fees. **Returns are a designed flow, not a support ticket**: decide upfront the auto-refund threshold (commonly items under ~$25 aren't worth return shipping — refund and let them keep it), the restock-vs-liquidate rule per condition grade, and put return rate ON the SKU's P&L. Which brings the discipline that governs everything: **fully-loaded per-SKU contribution** = price − landed cost (COGS + freight + duty) − fulfillment − payment fees − returns allowance − channel fees; a marketplace sale at 15% referral fee plus FBA fulfillment often nets ~30-45% less contribution than the same SKU DTC, but arrives with free demand — run both channels only for SKUs positive in both, and kill or reprice any SKU whose fully-loaded contribution margin sits below ~20%. Rule: **Every SKU gets a fully-loaded contribution margin per channel, and anything persistently under ~20% is repriced, renegotiated, or discontinued — averages across the catalog hide the losers.**

BAD: "The catalog's overall margin is 55%, so we're healthy — let's reorder everything that sold" (catalog averages hide the 30% of SKUs that lose money after returns and channel fees; reordering losers locks cash into inventory that destroys value per turn). GOOD: "Rank SKUs by fully-loaded contribution per channel, reorder only positive ones at target weeks-of-cover, and liquidate the bottom decile instead of restocking it."

```
ECOM OPS SNAPSHOT
═══════════════════════════
INVENTORY: [SKU] · velocity [X/wk] · weeks of cover [N] · reorder point [lead time + ~4wk buffer] · stockout risks [list]
FULFILLMENT: mode [self / 3PL / hybrid] · orders/day [N] · all-in cost per order [$X] · threshold check [~30-50/day]
RETURNS: rate by SKU [X%] · auto-refund under [$25] · restock/liquidate rule [by grade]
UNIT ECON: [SKU] · price [$] · landed [$] · fulfill [$] · fees [$] · returns allow [$] → contribution [X%]
CHANNELS: DTC contribution [X%] vs marketplace [Y%] · verdict per SKU [both / DTC-only / kill]
```

Skip when: pure dropshipping or print-on-demand with no inventory risk — channel math still applies but the inventory half doesn't. Also skip pre-launch: forecast from real velocity, not projections.

Gotchas: forecasting off a promo-spiked month sets reorder quantities you'll be discounting for a year — use baseline velocity with promos excluded. Freight and duty left out of COGS is the classic landed-cost lie; a $4 unit that costs $2.10 to get to the warehouse is a $6.10 unit. Marketplace dependence feels like a channel until account suspension makes it existential — keep DTC above a meaningful floor. Storage fees on slow movers (especially Q4 marketplace surcharges) can quietly exceed the product's margin — aged inventory past ~90 days is a liquidation candidate, not an asset.
