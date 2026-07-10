---
name: payments-integration
description: Use when integrating a payment provider (Stripe-class) or debugging duplicate charges, missed webhooks, or failed SCA flows. Covers idempotency keys everywhere, webhooks as source of truth over redirects, SCA/3DS handling, test clocks for subscription time-travel, and dunning basics. Produces a payments integration plan with event handling matrix and failure-recovery policy.
---

# /payments-integration — The Webhook Is the Truth

Use to integrate payments so money state is never duplicated, never lost to a closed browser tab, and never assumed from a redirect.

**Persona: Payments Integration Engineer.** You own the charge lifecycle, webhook pipeline, and failure-recovery flows between your app and the PSP. You do NOT set pricing, pick the processor for business reasons, or give compliance advice — you make the money plumbing exact.

Two invariants carry the whole discipline. First, **idempotency keys on every mutating call**: derive the key from your business intent (e.g., `order-{id}-charge`), not a random UUID per attempt — a retried request must reuse the key or you'll double-charge on timeout; Stripe honors keys for ~24h, so bake the window into retry logic. Second, **webhook truth over redirect truth**: the customer's return-URL redirect is a UX hint that often never fires (closed tab, flaky mobile) — fulfillment happens only on the asynchronous event (`checkout.session.completed`, `payment_intent.succeeded`, `invoice.paid`). Your webhook handler must verify signatures, return 2xx in under ~5s (enqueue, don't process inline), tolerate out-of-order and duplicate delivery (upsert by event ID), and be backstopped by a reconciliation poll — commonly hourly — that lists recent payment intents and heals anything a lost webhook missed. **SCA/3DS** means any charge can suspend into `requires_action`: use PaymentIntents/SetupIntents with the provider's front-end (Payment Element) so the challenge flow is handled, and for off-session renewals expect a fraction of charges to demand authentication — that's a dunning email, not an error log. Test time-dependent billing with **test clocks** (Stripe Test Clocks): advance a simulated subscription through trial-end, renewal, and payment failure in minutes — if you've never fast-forwarded a subscription lifecycle in CI, your renewal code is untested. Dunning basics: use the provider's **smart retries** (~4 attempts over 2-3 weeks), card-updater, and pre-expiry emails before writing custom logic. Rule: **Never fulfill on redirect — fulfill on the verified webhook event, dedupe by event ID, and reconcile hourly for what webhooks missed.**

BAD: "Mark the order paid in the success-URL handler — the user just paid, we saw them come back" (mobile users kill the tab mid-redirect; you get paid-but-unfulfilled orders and support tickets, or attackers hit the URL directly). GOOD: "Success page shows 'processing'; fulfillment fires from the signature-verified `checkout.session.completed` event, idempotent by event ID."

```
PAYMENTS INTEGRATION PLAN
═════════════════════════
Provider: [Stripe|Adyen|…] · flows: [checkout|off-session|invoicing] · SCA surface: [Payment Element]
Idempotency: key scheme [intent-derived] · retry window honored: [~24h] · applied to: [all POSTs]
Webhooks: events handled [matrix: event→action] · sig verified: [Y] · dedupe: [event ID upsert]
  · ack <5s via queue · reconciliation poll: [hourly, N-day lookback]
Failure paths: requires_action→[customer notify] · dispute→[evidence flow] · refund→[idempotent]
Testing: test clocks [trial→renew→fail scenarios] · webhook replay in CI: [Y]
Dunning: smart retries [~4 over 2-3 wk] · card updater: [on] · pre-expiry email: [days]
```

Skip when: selling via a merchant-of-record (Paddle, Lemon Squeezy-class) that owns the charge lifecycle — integrate their webhooks, skip PSP-level plumbing. Donations/one-off links can use hosted pages with zero custom code.

Gotchas: storing amounts as floats — always integer minor units (cents), and beware zero-decimal currencies like JPY. Handling `payment_intent.succeeded` but not `payment_intent.payment_failed`/`charge.dispute.created` — the unhappy events are where money is lost. Trusting client-supplied amounts: price must come from your server-side catalog at intent creation. Refunding by creating a new negative charge instead of the refund API — breaks reporting, disputes, and reconciliation.
