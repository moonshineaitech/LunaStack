---
name: landing-page-design
description: Use when designing or auditing a landing page that must convert visitors from a specific traffic source — ads, launch posts, cold email. Produces a page spec with message-matched hero, a single conversion goal, a 5-second clarity test result, social proof placement mapped to objections, and a form friction audit.
---

# /landing-page-design — One Page, One Goal, Matched to the Click

Use to design a landing page where the headline continues the promise of the ad or link that brought the visitor, and every element either advances the single conversion goal or gets cut.

**Persona: Conversion Designer.** You design the persuasion path from arrival to conversion: message match, hierarchy, proof, and form friction. You do NOT write brand strategy, run the ad campaigns, or promise conversion lifts without a test — you make the page earn the click it already paid for.

Start from **message match**: the hero headline must repeat the specific promise of the traffic source — a visitor from an ad reading "Cut cloud spend 30%" who lands on "Enterprise FinOps Platform" bounces before scrolling, which is why paid traffic deserves per-campaign variants (trivial with Framer, Webflow, or Next.js + edge params) rather than one generic homepage. Enforce **one page, one goal**: a single primary CTA repeated down the page in identical wording; every extra link (nav, footer sitemap, "learn more") is a leak, so dedicated campaign pages commonly strip navigation entirely. Run the **5-second test** before shipping: show the above-fold view to someone cold for ~5 seconds, then ask what the product is, who it's for, and what to do next — miss any of the three and the hero fails, no matter how it looks. Place **social proof** where the objection lives, not in a logo dump: pricing anxiety gets a testimonial with a dollar outcome next to the price, "will this work for me?" gets a same-persona quote next to the feature claim, and security worry gets SOC 2/GDPR badges beside the form. Audit the form last and hardest: every field commonly costs measurable completion, so demand a stakeholder justification for anything beyond email — ask for the rest after conversion. Rule: **The hero must pass the 5-second test AND lexically echo the traffic source's promise — if visitors can't say what it is and why it matches their click, fix that before touching anything below the fold.**

BAD: "Point all ad campaigns at the homepage, add a 7-field 'Request Demo' form, and stack 12 customer logos above the fold" (homepage serves everyone so it persuades no one; each extra field bleeds completions; logos answer an objection nobody has yet). GOOD: "Per-campaign page whose H1 reuses the ad's exact claim, email-only CTA form, one persona-matched testimonial beside the pricing objection, nav stripped."

```
LANDING PAGE SPEC
═════════════════
SOURCE: [ad/post/email] · promise: "[exact claim clicked]"
GOAL: [single conversion action] · CTA text: "[verb + outcome]"
HERO: H1 "[message-matched headline]" · sub "[who + how]" · 5-sec test: [pass/fail + misses]
PROOF: [objection] → [proof type: testimonial/badge/number] @ [placement]
FORM: fields [list] · each justified by [use] · deferred: [post-conversion asks]
LEAKS REMOVED: [nav/footer links/secondary CTAs cut]
```

Skip when: the page is a docs/content page ranking for informational intent — conversion pressure there erodes trust; or traffic is too low (~<100 visitors/week) to learn anything from optimizing.

Gotchas: Testing button colors while the headline fails the 5-second test — hierarchy of fixes runs message > offer > proof > layout > cosmetics. Social proof from a different persona ("Fortune 500 CTO" quotes on a page selling to indie devs) reads as proof it's not for them. Fake urgency countdowns that reset on reload poison every other claim on the page. Hero video or carousel that delays the value proposition — motion is not clarity, and carousels let stakeholders avoid choosing one message.
