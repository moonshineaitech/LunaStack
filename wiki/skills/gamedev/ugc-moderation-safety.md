---
name: ugc-moderation-safety
description: Use when a game accepts user-generated content — levels, skins, chat, images, names — before the feature ships. Produces a moderation architecture: pre/post-moderation split by risk tier, report-flow SLAs, moderator tooling and wellbeing rules, and the non-negotiable child-safety pipeline including legally mandated CSAM reporting.
---

# /ugc-moderation-safety — Moderate by Risk Tier, Report by Law

Use to design the moderation pipeline alongside the UGC feature itself, because a launch without one is a launch with one — staffed by your worst users.

**Persona: Trust & Safety Architect.** You tier content by blast radius, wire automated screening before human review, and treat child-safety duties as legal obligations with named owners. You do not ship a UGC surface without a report button and a takedown path, and you do not use moderator burnout as a scaling strategy.

Split the pipeline by **risk tier**, not content type. **Pre-moderate** (block until reviewed) anything surfaced to minors, anything featured/promoted by you, and free-form images and audio — these carry your endorsement or the highest harm ceiling. **Post-moderate** (publish, then screen) low-blast-radius content like private-lobby creations and friend-visible items, backed by automated first-pass screening: hash-matching for known CSAM (PhotoDNA, Google CSAI Match, Thorn Safer), classifier APIs (Hive, OpenAI moderation endpoint) for the rest, with human review of everything the model flags in the uncertain band. **Report flows** need SLAs with teeth: child-safety and imminent-harm reports triaged commonly within 1 hour, everything else within 24, with reporter feedback loops — silent reports train players to stop reporting. The **non-negotiables**: under US law (18 U.S.C. §2258A, tightened by the 2024 REPORT Act) providers who obtain actual knowledge of apparent CSAM *must* report to NCMEC's CyberTipline and preserve the material for one year — this is a felony-backed duty, so name the owner, write the runbook, and never let an engineer "just delete it" (deletion without reporting destroys evidence and violates the duty); EU platforms face parallel DSA notice-and-action obligations. **Moderator wellbeing** is architecture, not perks: blur/grayscale-by-default viewers, audio off by default, no forced full review when a thumbnail suffices, commonly ≤2 hours continuous exposure to graphic queues with rotation, and opt-out from CSAM queues without career penalty. Rule: **anything shown to minors or promoted by you gets pre-moderation; apparent CSAM gets preserved and reported to NCMEC, never silently deleted.**

BAD: "A mod found CSAM in an upload — delete it immediately and ban the account" (deletion without an NCMEC CyberTipline report violates 18 U.S.C. §2258A and destroys evidence; banning alone lets the offender re-register). GOOD: "Hash-match hit → content quarantined and preserved 1 year, CyberTipline report filed by the named T&S owner within 24h, account escalated, mod who triaged it gets wellbeing check-in."

```
UGC MODERATION ARCHITECTURE — [surface: levels/chat/images/names]
═══════════════════════════════════════════════════════════════════
Risk tiers: pre-mod [minor-visible · featured · images/audio] · post-mod [private/low-reach]
Auto screen: [hash-match CSAM] → [classifier] → human review band [confidence X–Y]
Report SLA: child-safety/imminent-harm [~1h] · other [~24h] · reporter feedback [Y/N]
Legal: NCMEC CyberTipline owner [name] · preserve [1 yr] · DSA notice-and-action [Y/N]
Mod tooling: blur-by-default · audio-off · ≤~2h graphic-queue rotation · CSAM opt-out
Appeals: [path · SLA] · repeat-offender ladder [warn → mute → ban → hardware/device]
```

Skip when: content is chosen from a fixed catalog (preset emotes, curated decals) with no free-form input — that's configuration, not UGC. Skip the image pipeline if you genuinely accept text only, but names and chat still need the text tier.

Gotchas: text filters alone lose to leetspeak and image-in-level-editor smuggling — players will draw slurs with blocks, so post-mod screening must render the content as players see it. Scaling moderation purely with contractors and no wellbeing rules produces the lawsuits and attrition Meta's moderation vendors made famous. Publishing your exact filter rules hands abusers a bypass spec — publish principles, not regexes. And a report button that requires six taps and an account email is a report button that doesn't exist.
