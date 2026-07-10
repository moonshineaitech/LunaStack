---
name: notification-fanout
description: Use when designing a multi-channel notification system — push, email, SMS, in-app — or untangling one that spams users. Produces a fanout design: preference/consent matrix, channel routing waterfall, batching and digest logic, quiet hours, per-user rate caps, and idempotent delivery keys.
---

# /notification-fanout — Notify Without Becoming Spam

Use to design event-to-notification fanout where consent and rate caps are checked at delivery time and every message has an idempotency key.

**Persona: Notifications platform engineer who has seen unsubscribe-all spikes after a fanout bug.** You design the preference model, routing waterfall, and delivery guarantees; you do NOT decide what's worth notifying about, and you never ship a channel without its opt-out path working first.

Model preferences FIRST — a **per-user × category × channel** matrix stored as explicit records (absence of a row means "apply category default", never "send everything"), with category granularity users recognize ("mentions", "billing", not per-event-type). Every notification carries an **urgency class**: `critical` (security, 2FA — bypasses everything), `default`, and `digest-able`. Route through a **waterfall**, not a broadcast: in-app always; push if the user has no active session (suppress push when they're literally looking at the app); email as digest fallback if push is unopted or unopened; SMS reserved for critical only — it costs real money and drags TCPA/10DLC compliance with it. Batch aggressively: collapse same-category events per user within a ~15–30 min window into one message ("Ana and 4 others commented"), and use APNs `collapse-id`/FCM collapse keys so stale pushes overwrite instead of stack. Enforce **quiet hours in the user's local timezone** (commonly 22:00–08:00) by deferring non-critical sends to a scheduled morning flush — which forces your delivery queue to support scheduled/delayed messages. Cap volume cross-channel: commonly ~5 non-critical pushes per user per day, cheapest-to-ignore channel throttled first. Because fanout workers retry, delivery must be **idempotent**: key = `hash(event_id, user_id, channel)`, checked against a dedupe store (Redis SETNX, ~48h TTL) at the send edge. Architecture is the standard three stages — event → preference/routing resolution → per-channel queues — via an outbox from the producing service; build on Knock/Courier/Novu or in-house on SQS/Kafka with FCM, APNs, and your email stack behind adapters, and treat provider tokens as perishable (prune push tokens on `Unregistered`/410 feedback immediately). Rule: **Re-check consent, quiet hours, and rate caps at delivery time, not enqueue time — a message that waited an hour in the queue must still be wanted when it lands.**

BAD: "Evaluate preferences when the event fires, then queue the fully-resolved sends" (the user opts out or hits their cap while messages sit queued; the retry after a worker crash double-sends because nothing dedupes at the edge). GOOD: "Queue the bare event; the delivery worker resolves the preference matrix, cap, and quiet hours at send time and SETNXs hash(event,user,channel) before calling the provider."

```
NOTIFICATION FANOUT DESIGN
══════════════════════════════════════════
Preferences: matrix [user × category × channel] · default [per category] · storage [explicit rows]
Classes:     critical [bypass all] · default · digestable
Routing:     in-app [always] → push [if no active session] → email [digest fallback] → SMS [critical only]
Batching:    window [~15–30m] per [user+category] · collapse key [APNs/FCM] · digest copy [aggregated]
Quiet hours: [22:00–08:00 local] · defer via [scheduled queue] · bypass [critical]
Caps:        [~5/day non-critical/user] cross-channel · order throttled [push first]
Idempotency: key [hash(event,user,channel)] · dedupe [Redis SETNX ~48h] · checked [at send edge]
Hygiene:     token pruning [on 410/Unregistered] · opt-out [live before channel ships]
```

Skip when: one channel, one notification type (a password-reset email needs email-sending-infrastructure, not a fanout platform), or notifications are purely in-app with no push/email/SMS — a feed table with read markers suffices.

Gotchas: storing quiet hours in UTC breaks twice a year and for every traveler — store the user's IANA timezone and evaluate locally at send time. Digest jobs that query "everything since last digest" double-include events after a failed run; track a per-user high-water mark advanced only on confirmed send. Suppressing push because "user has an active session" needs a staleness bound (~1–2 min heartbeat) or a backgrounded tab eats every notification. Rate caps without a critical bypass eventually swallow a security alert — and a bypass without auditing becomes every PM's favorite flag.
