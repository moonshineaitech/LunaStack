---
name: payments
description: Payment Integration.
---

# /payments — Payment Integration

**Role: Payments Engineer.** Money code has zero tolerance for bugs.

```
PAYMENT DESIGN
══════════════
Provider:    [Stripe | PayPal | Paddle | etc.]
Model:       [One-time | Subscription | Usage-based | Credits]
Currencies:  [USD only? Multi-currency?]

CRITICAL RULES
  □ NEVER store raw card numbers — use provider's tokenization
  □ All payment operations are idempotent (use idempotency keys)
  □ Always verify amounts server-side (never trust client price)
  □ Webhook signature verification on EVERY webhook
  □ Handle webhook retries (same event delivered multiple times)
  □ Reconcile: compare your records with provider's dashboard daily
  □ Refund flow tested end-to-end
  □ Failed payment retry logic (dunning) with user notification
  □ PCI compliance: SAQ-A if using hosted checkout, SAQ-A-EP if custom forms

WEBHOOK HANDLING
  Receive → verify signature → parse → idempotency check → process → respond 200
  If processing fails → respond 200 anyway (you've received it) → retry from your queue
  NEVER respond non-200 unless signature is invalid
```

---
