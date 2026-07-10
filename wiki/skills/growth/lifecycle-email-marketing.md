---
name: lifecycle-email-marketing
description: Use when building or fixing email programs — onboarding flows, retention campaigns, or a deliverability scare. Designs trigger-based lifecycle emails with SPF/DKIM/DMARC enforcement, a per-user frequency budget, and a sunset policy for the disengaged. Produces a lifecycle email program spec.
---

# /lifecycle-email-marketing — Triggered Email That Protects Its Own Deliverability

Use to design an email program where behavior-triggered sends replace batch blasts and deliverability is treated as the asset it is.

**Persona: Lifecycle Marketing Engineer.** You send email triggered by what a user just did or failed to do, and you defend sender reputation like uptime. You do NOT blast the full list, buy addresses, or keep mailing people who stopped opening.

Build on **triggers, not calendars**: the highest-ROI emails fire off events — signed up but never activated (send at ~24h with the one action that activates), hit a usage milestone, card about to expire, went quiet for 14 days. Each triggered email needs an owner event, a goal action, and an exit condition; a batch newsletter is the garnish, not the program. **Deliverability is a precondition**: since the 2024 Gmail/Yahoo bulk-sender rules, anyone sending 5k+/day to Gmail must pass **SPF and DKIM with DMARC** (start `p=none` with `rua` reports, move to `p=quarantine` once legitimate mail aligns), offer **one-click unsubscribe** (RFC 8058 List-Unsubscribe-Post header), and keep the **spam complaint rate under 0.3%** in Google Postmaster Tools — ideally under 0.1%, because 0.3% is where Gmail starts junking the domain, not where trouble begins. Separate transactional and marketing mail onto different subdomains so a promo mistake can't sink password resets. Give every user a **frequency budget** — commonly 3-5 marketing emails per week ceiling, enforced centrally in the ESP (Customer.io, Braze, Klaviyo, Iterable all support rate limiting/priority) so overlapping campaigns compete for slots instead of stacking. And run a **sunset policy**: users with no open or click in ~90-180 days enter a 2-3 email win-back sequence; no response → suppress them. Mailing the disengaged feels free but trains Gmail that your mail is ignorable, dragging inbox placement down for engaged users too — plus Apple MPP inflates opens, so weight clicks when judging engagement. Rule: **never send marketing email to anyone with no click in ~180 days who ignored the win-back — suppress, don't nurture.**

BAD: "Keep the lapsed 40% on the list — emailing them costs nothing and someone might come back" (their non-engagement suppresses inbox placement for your whole domain; you're paying with everyone else's inboxing). GOOD: "90-day inactives get a 3-email win-back; non-responders are suppressed, and list size becomes a vanity metric we stop reporting."

```
LIFECYCLE EMAIL PROGRAM
═══════════════════════
Auth: SPF ✓ · DKIM ✓ · DMARC [none→quarantine, rua set] · one-click unsub ✓
Subdomains: transactional [t.domain] · marketing [m.domain]
Triggers: [event → email @ delay → goal action → exit condition] × [n flows]
Frequency budget: [n]/week per user · enforced in [ESP] · priority: [order]
Sunset: inactive [90-180d, click-weighted] → win-back [2-3 emails] → suppress
Health: complaint rate [<0.1% target / 0.3% ceiling] · Postmaster reputation: [High/Med/Low]
```

Skip when: sending under ~1k emails/month to a hand-known audience — a plain personal email outperforms any automation; or you're purely transactional with no marketing sends.

Gotchas: judging engagement by opens when Apple MPP auto-fires them — sunset on clicks and site activity or you'll suppress healthy users and keep dead ones. Launching flows before DMARC alignment, then diagnosing "spam folder" as a copy problem. Letting each campaign owner send independently so a user gets 6 emails in a day — the budget must be enforced centrally, not by courtesy. Importing an old cold list to "re-engage" it — that's how complaint spikes and blocklistings happen.
