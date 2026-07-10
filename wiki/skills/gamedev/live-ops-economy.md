---
name: live-ops-economy
description: Use when operating a live game economy — planning events, adding currencies, or diagnosing inflation and dead sinks. Produces a live-ops economy runbook: faucet/sink audit, inflation dashboard thresholds, event cadence calendar, currency segmentation map, and the paid-value protection policy that keeps spenders from feeling burned.
---

# /live-ops-economy — Run the Economy Like a Central Bank, Not a Slot Machine

Use to keep a live game economy stable across months of events, sales, and content drops without inflating rewards or devaluing what players already paid for.

**Persona: Live Economy Manager.** You audit every faucet and sink before it ships, watch wallet distributions weekly, and treat paid purchases as promises. You do not fix retention dips by spraying free currency, and you do not launch an event without modeling its net currency injection.

A live economy is a flow system you re-audit every release: list every **faucet** (quests, events, compensation grants, battle pass) and every **sink** (upgrades, consumables, cosmetics, repair/craft fees) with per-player-day rates, and keep engaged players' net currency flow near zero — when **P50 or P95 wallet balance grows more than ~10% week-over-week with no new sink shipping**, you have inflation, and the fix is new aspirational sinks (prestige upgrades, cosmetics, conversion ladders), never a stealth price hike on existing goods. **Segment currencies by function**: one earnable soft currency, one paid hard currency, and event-scoped currencies that expire or convert down at event end — event currency that lingers becomes an uncontrolled faucet, and letting hard currency be farmed freely collapses its price floor. Run **event cadence** as a calendar with breathing room — commonly one major economic event per 4–6 weeks with minor beats between, and model each event's net injection *before* launch, because "double XP weekend" math compounds with battle-pass catch-up mechanics in ways spreadsheets catch and vibes don't. The one inviolable policy is **never devalue paid**: don't deep-discount an item within ~30 days of someone buying it at full price without compensating them, don't power-creep a paid item into irrelevance without a grace path, and when sunsetting paid content, convert its value rather than deleting it — spenders have long memories, platforms have refund policies, and regulators (EU consumer law, Japan's kompu gacha precedent) have opinions. Rule: **model every event's net currency injection before launch, and treat >~10% week-over-week wallet growth without a new sink as a production incident.**

BAD: "Retention dipped, so grant 5,000 gems to everyone and double drop rates for a month" (a one-way faucet with no sink — wallets balloon, the store's price anchors collapse, and next month's event rewards feel worthless). GOOD: "Retention dipped: ship a limited prestige-upgrade sink alongside a 2-week event whose modeled net injection is ~+5% P50 wallet, absorbed by the new sink within the same window."

```
LIVE-OPS ECONOMY RUNBOOK — [game / season]
═══════════════════════════════════════════
Faucets: [source → currency/day per active player] · Sinks: [drain → currency/day]
Net flow: [P50 delta/week] · alert at [>~10% WoW wallet growth, no new sink]
Currencies: soft [earn-only] · hard [paid, price floor] · event [expires/converts at end]
Event calendar: [major every 4–6 wks] · per-event modeled injection [+X% P50 wallet]
Paid-value policy: no discount <~30 days post full-price sale · sunset = convert, never delete
Dashboard: wallet P50/P95 · sink participation % · store conversion · dead sinks [<2% use]
```

Skip when: the game is premium single-player with no live economy — balance it once with /game-balancing-methodology and ship. Skip the segmentation ceremony for a single-currency prototype still finding its core loop.

Gotchas: compensation grants for outages are the most common stealth inflation source — budget them as a faucet, don't hand them out ad hoc. Adding a sink nobody wants (a gold-eating tax) reads as punishment and burns goodwill; sinks must be aspirational purchases, not fees. Averages hide hoarders: a healthy P50 with an exploding P99 means your top players have nothing left to buy and will churn the moment a competitor ships endgame. And "temporary" event currency that converts up into hard currency trains players to arbitrage every event — always convert down into soft.
