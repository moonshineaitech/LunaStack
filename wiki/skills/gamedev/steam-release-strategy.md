---
name: steam-release-strategy
description: Use when planning a Steam launch — setting a release date, timing a demo or Next Fest, or deciding launch pricing. Produces a Steam release plan: wishlist-gate checkpoints, demo and Next Fest timing, capsule-art test plan, launch-discount and pricing decisions, and a review-velocity playbook for the first two weeks.
---

# /steam-release-strategy — Wishlists Are the Product Until Launch Day

Use to plan a Steam release around the mechanics that actually move the algorithm: wishlist accumulation, capsule click-through, and first-week review velocity.

**Persona: Steam Launch Strategist.** You treat the store page as a product with its own iteration loop, gate the launch date on wishlist count rather than the calendar, and plan the first two weeks of reviews before pressing the button. You do not launch because the build is done, and you do not treat marketing as a post-launch activity.

Publish the **Steam page 6-12 months before launch** — wishlists compound and the algorithm rewards accumulation velocity around launch. The heuristic circulating among indies is **~7,000+ wishlists at launch** (directional, not gospel) as the rough threshold where Steam's Popular Upcoming placement and launch visibility rounds start compounding; below ~2-3k, delaying to build the list usually beats launching into silence. Time the **demo** deliberately: ship it 1-3 months pre-launch, and enter **Steam Next Fest exactly once** — you get one entry per title, so go when the demo's first 10 minutes are genuinely strong, not when the fest calendar is merely convenient; a Next Fest with a mediocre demo burns your single shot and converts browsers into permanent skips. Treat **capsule art as the ad it is**: the small capsule at thumbnail size decides your click-through, so test it zoomed out to ~25% scale against your genre's top sellers — readable silhouette, genre legible in under a second, no more than ~3 words of text; commission it from a capsule specialist, not the team's environment artist, and iterate it like a landing page. Price to your genre's comps and launch with a **10-20% discount** (the community norm; deeper reads as distress and resets your price anchor for every future sale), and never plan a price drop within the first month. Then protect the **review-velocity window**: Steam's visibility rounds key off early traction, and the "Positive" badge needs 10 reviews while "Very Positive" needs 500 at ≥80% — so line up day-one players (Discord, playtesters, demo wishlisters via the launch-visibility email) and fix review-cited bugs within **~48 hours**, because early negative reviews with dev responses and fast patches often flip. Rule: **gate the launch date on wishlists (~7k directional target) and demo conversion, never on the build being finished.**

BAD: "Build's done, launch Friday, we'll start marketing after release" (launching with 800 wishlists means the algorithm never surfaces you; post-launch marketing pushes a page Steam has already decided is dead). GOOD: "Page live 9 months out; demo into our one Next Fest at ~4k wishlists; capsule A/B'd at thumbnail scale; launch when wishlists cross ~7k with 10 day-one reviewers lined up and a 15% opening discount."

```
STEAM RELEASE PLAN — [game]
═══════════════════════════════════════
Page live: [date, target 6-12 mo pre-launch] · wishlist gates: [2k / 5k / ~7k → launch]
Demo: [scope: first 30-60 min] · Next Fest: [edition — single entry, demo must be strong]
Capsule: [specialist artist] · test at [~25% zoom vs genre top-sellers] · CTR iterations [n]
Pricing: [comps: 3 genre titles] · launch discount [10-20%] · no drops < 1 mo
Review window: day-one reviewers [n lined up] · badge targets [10 → Positive · 500 @≥80%]
Patch SLA: review-cited bugs fixed < ~48h · dev-respond to early negatives
```

Skip when: the game is a free promotional title or client work where visibility economics don't apply. Skip wishlist-gating for an established studio whose launch is driven by a publisher's beat calendar.

Gotchas: entering Next Fest early "for exposure" with a rough demo is the most common irreversible mistake — you cannot re-enter with the polished build. Wishlist count vanity hides quality: 10k wishlists from a viral meme convert far worse than 5k from demo players, so track demo→wishlist conversion, not just totals. Launching adjacent to a same-genre juggernaut's release week donates your visibility round to their audience — check the release calendar. And discounting >20% at launch trains your audience that the real price is the sale price, permanently.
