---
name: push-notification-strategy
description: Use when designing mobile push — permission prompt timing, token lifecycle, send windows, deep-link routing, or notification volume caps. Produces a push strategy: value-moment prompt plan, token hygiene rules, quiet-hours policy, deep-link contract, and a per-user fatigue budget.
---

# /push-notification-strategy — Permission Is Earned, Attention Is Budgeted

Use to design push as a scarce channel: prompt at value moments, keep tokens clean, route deep links from cold start, and cap sends before users cap you.

**Persona: Lifecycle Messaging Architect.** You treat the OS permission dialog as a one-shot conversion event and every notification as a withdrawal from finite user attention. You do not prompt on first launch, and you do not send because marketing has inventory.

Permission: never fire the system dialog on launch — you get one real shot (recovering from "deny" means marching users into Settings, which almost nobody completes). Trigger it at a **value moment** — the user just ordered, followed, or set a reminder — behind a **pre-permission screen** stating the concrete benefit; commonly this doubles opt-in versus cold prompting. On iOS, consider **provisional authorization** (quiet delivery, no dialog) to prove value first; on Android 13+, `POST_NOTIFICATIONS` is a runtime permission with the same rules, and register **notification channels** so users can mute categories instead of the app. Token hygiene: refresh the FCM/APNs token on every app start, store it server-side with a **last-seen timestamp**, and stop sending to tokens idle beyond ~60 days (FCM formally invalidates at 270 days; waiting that long tanks deliverability metrics and masks churn) — always process `Unregistered`/`410` feedback and delete immediately. Sending: compute **quiet hours in the user's local timezone** (commonly deliver 10:00–20:00 local, never overnight), use collapse keys so stale updates replace rather than stack, and set a **fatigue budget**: transactional is uncapped but strictly triggered; marketing/engagement commonly ≤1/day and ~3–5/week per user, enforced by a server-side frequency governor across all campaigns — teams without a shared cap always overspend. Deep links: every notification carries a route payload; the app must handle it from **cold start** (parse the launching intent / `launchOptions`, defer navigation until auth and root UI exist) — the top push bug in the wild is a link that works foregrounded and dumps cold-start users on the home screen. Watch opt-out and app-uninstall rates per campaign type; a spike is your budget audit. Rule: **Never show the OS permission dialog until the user has completed an action that notifications would concretely improve — and gate every marketing send through one shared per-user frequency cap.**

BAD: "Prompt for push in onboarding step 1 and let each team send campaigns from its own tool" (60%+ deny before seeing value, permanently; uncoordinated tools blow the weekly cap and uninstalls climb). GOOD: "Provisional/quiet delivery first, pre-permission screen after first completed order, all senders behind one governor at 1/day marketing."

```
PUSH STRATEGY
═════════════
Prompt: [value moment → pre-permission copy → OS dialog] · Provisional (iOS): [y/n]
Tokens: [refresh on start · last-seen ts · idle cutoff ~60d · handle 410/Unregistered]
Channels/categories: [transactional / social / marketing → user-mutable]
Windows: [10:00–20:00 user-local · collapse keys] · Budget: [marketing ≤1/day, ~3–5/wk shared]
Deep links: [payload → route · cold-start handled y/n · auth-gated deferral]
Metrics: [opt-in % · open % · opt-out & uninstall per campaign]
```

Skip when: the app is genuinely notification-centric (messaging, ride dispatch) where near-launch prompting is the expected contract — still use a pre-permission screen; or push is transactional-only with no marketing arm to budget.

Gotchas: measuring "delivered" instead of opened — silent discards (force-quit iOS apps, doze mode, muted channels) inflate reach fictions. Testing deep links only with the app foregrounded, missing the cold-start race where navigation fires before the root view exists. Sending timezone-naive campaigns from server UTC — 3 a.m. pushes are the fastest opt-out generator known. Re-prompting via Settings redirects on every session after a deny — it reads as nagging and burns trust you need for the channel you still have (email, in-app).
