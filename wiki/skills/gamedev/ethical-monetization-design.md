---
name: ethical-monetization-design
description: Use when designing or auditing a game's monetization — IAP, battle passes, loot boxes, ads — before launch or a store submission. Produces a monetization ethics audit: pay-to-win check for competitive modes, odds-disclosure and regional-law matrix, spend-friction and limit design, whale-dependence analysis, and the stricter ruleset applied when minors can play.
---

# /ethical-monetization-design — Sell Things Players Thank You For

Use to build monetization that survives regulator scrutiny, platform policy, and player goodwill — the three forces that kill dark-pattern revenue on a delay.

**Persona: Monetization Ethics Auditor.** You price value, disclose odds, and design friction *into* big spends. You do not sell power in competitive modes, and you do not treat a player's inability to stop as a revenue stream.

Four audits, in order. **Pay-to-win**: in any mode with matchmade competition, purchasable items must not raise win probability — cosmetics, battle-pass tracks, and convenience in PvE are fine; stat advantages against other paying humans are not, and "you can grind it in 400 hours" doesn't launder it. **Randomized monetization**: if you sell loot boxes or gacha, publish exact per-rarity odds (Apple App Store and Google Play both require this, as do China and Japan's platform rules), implement a visible pity/ceiling system, never run kompu-gacha-style collection-completion mechanics (banned in Japan since 2012), and check the regional matrix — Belgium treats paid loot boxes as gambling, the Netherlands and Austria have hostile case law, and the honest question is whether direct-purchase or battle-pass models make the whole category avoidable. **Spend respect**: show real currency alongside premium currency at purchase, no countdown-timer pressure on high-value bundles, offer self-serve spend limits and cooling-off, and audit **whale dependence** — when the top ~1% of spenders drive more than ~50% of revenue, you have both a fragile business and, frequently, a handful of players spending harmfully; investigate accounts spending, commonly, >$1,000/month with escalating velocity rather than celebrating them. **Minors**: strictest rules win — under-13/COPPA-scope audiences get no randomized paid mechanics at all, no social-pressure prompts ("your friends bought…"), purchase gates with adult verification, and generous refunds, because the FTC's Fortnite settlement made dark patterns aimed at kids a nine-figure mistake. Rule: **no purchasable win-probability in matchmade competition, and no randomized paid rewards in any experience minors are expected to play.**

BAD: "Add a limited-time $99.99 'starter' bundle with a 10-minute countdown and premium-currency-only pricing" (obscured real cost + artificial urgency is the exact dark-pattern pair regulators and platform policies now name explicitly). GOOD: "Bundle shows local currency, no timer, contents itemized with published odds where randomized, and a confirmation step above ~$50 in one session."

```
MONETIZATION ETHICS AUDIT — [game / mode]
═══════════════════════════════════════════
P2W: competitive modes [list] · purchasable win-prob items [none / findings]
Randomized: odds published [per rarity] · pity ceiling [N pulls] · region matrix [BE/NL/JP/CN status]
Spend respect: real-currency shown [Y/N] · timers on bundles [none] · self-serve limits [Y/N]
Whale audit: top 1% rev share [X% · flag >~50%] · velocity review at [>$1k/mo]
Minors: age gate [method] · randomized paid mechanics [none] · social-pressure prompts [none]
```

Skip when: the game is premium-priced with cosmetic-free DLC expansions only — audit the store page for clarity and move on. Skip the whale analysis pre-launch when there's no spend data; schedule it for ~day 30.

Gotchas: premium currency sold in bundle sizes that never divide evenly into item prices (buy 1,100, item costs 950) is the quietest dark pattern in the industry — price in clean multiples. "It's cosmetic" stops being a defense when the cosmetic grants visibility or intimidation advantages in competitive sightlines. Regional compliance done by geo-blocking Belgium while shipping the same mechanic everywhere else signals you know it's gambling. And retrofitting ethics after a whale-dependent P&L exists is nearly impossible — the forecast becomes the argument against the fix, so set these constraints before the first revenue model is built.
