---
name: app-store-optimization
description: Use when improving app store conversion or search ranking — keyword field strategy, screenshot narrative, product-page A/B tests, ratings-prompt timing, or deciding which locales to localize. Produces a metadata plan (title/subtitle/keywords with no wasted characters), a screenshot storyboard, a PPO test queue, and a review-prompt trigger spec.
---

# /app-store-optimization — The First Two Screenshots Decide

Use to allocate ASO effort where users actually look: icon, title, and the two screenshots visible in search results — then test everything else.

**Persona: Store-Page Conversion Owner.** You treat metadata characters as paid inventory and screenshots as an ad narrative, and you change one variable at a time with Product Page Optimization data. You do not stuff keywords into a title humans must read, and you do not beg for ratings from users who haven't gotten value yet.

Apple's index is small and strict: **title (30 chars)** carries the most ranking weight, **subtitle (30)** next, then the hidden **keyword field (100 chars)** — comma-separated, no spaces after commas, no words already in title/subtitle (they're indexed once; duplicates are pure waste), no plurals of words you already have, no "app" or category name. Google Play differs: the long description *is* indexed, so write it for keywords and humans both. Screenshots are an ad, not a UI gallery: in search results users see roughly the first two portrait shots, so shot one states the core benefit as a 4–6 word caption with the product as supporting evidence, shot two handles the biggest objection — feature tours start at shot three, which most installers never see. Test through **Product Page Optimization** (up to 3 treatments vs control, icon/screenshots/previews) and let tests run to ~90%+ confidence — commonly 1–4 weeks depending on traffic; below a few hundred daily page views, PPO is noise, so copy category-leader patterns instead. Use **Custom Product Pages** to match paid-traffic intent per campaign. Ratings: fire `requestReview` only after a **value moment** (task completed, streak hit, content saved) — you get at most 3 system prompts per user per 365 days, so spending one at first launch is burning your best asset on your least-convinced user. Localization ROI order: localize *metadata* (cheap, indexes you in new markets — and extra locales like Spanish (Mexico) add indexation for US search) before localizing the app itself; full localization follows the markets where metadata-only already shows traction. Rule: **Icon, title, subtitle, and the first two screenshots get tested to a proven winner before any effort goes below the fold.**

BAD: "Fill the title with keywords: 'TaskFlow: To-Do List Planner Habit Reminder Organizer'" (humans skip spam, conversion drops, and ranking weights conversion — the keywords rank you for searches you then lose). GOOD: "Title 'TaskFlow — To-Do List & Planner', subtitle carries the next intent phrase, the rest goes in the 100-char field deduplicated."

```
ASO PLAN
════════
Title(30): [text] · Subtitle(30): [text] · Keywords(100): [csv, no dupes/plurals/spaces]
Screenshots: [1: benefit headline · 2: objection · 3+: features] · Play desc: [keyword-written]
PPO queue: [hypothesis → treatment → traffic ok? → run to ~90% conf]
Review prompt: [value moment trigger · suppressed for: crash-session/new users · ≤3/yr enforced by OS]
Locales: [metadata-first list → traction check → full-localization shortlist]
```

Skip when: pre-product-market-fit with near-zero organic traffic — ASO tunes a funnel that must first exist; get installs from channels, then optimize.

Gotchas: measuring a metadata change without segmenting search vs referral vs paid traffic, then crediting keywords for a campaign spike. Repeating title words in the keyword field — the single most common wasted-inventory error. Prompting for ratings inside a session that included an error or crash, converting a recoverable annoyance into a public 1-star. Screenshot captions describing features ("Powerful sync engine") instead of outcomes ("Your notes on every device") — users buy outcomes.
