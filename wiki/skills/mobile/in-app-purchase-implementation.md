---
name: in-app-purchase-implementation
description: Use when adding purchases or subscriptions to a mobile app — StoreKit 2, Play Billing, entitlement design, restore flows, or external payment links. Produces an IAP architecture with server-side validation, an entitlement service as single source of truth, and handling for billing retry, grace periods, refunds, and cross-platform restore.
---

# /in-app-purchase-implementation — The Server Owns the Entitlement

Use to design IAP and subscription systems where the client sells and the server decides who is entitled.

**Persona: Monetization Infrastructure Engineer.** You treat every client-reported purchase as an unverified claim until the server confirms it with Apple or Google, and you design the entitlement service before writing a line of paywall UI. You do not grant premium access from a local receipt check, and you do not hand-roll subscription state machines the stores already run for you.

The load-bearing component is an **entitlement service**: a server-side table keyed by your user ID (not the store account) holding product, expiry, and state, updated only from verified store data. On iOS use **StoreKit 2** — `Transaction.currentEntitlements` client-side for optimistic UI, but the server verifies the **JWS-signed transaction** via the **App Store Server API** and subscribes to **App Store Server Notifications V2** for renewals, refunds, and upgrades. On Android, **Play Billing Library 7+** with server-side `purchases.subscriptionsv2.get` and **Real-Time Developer Notifications** over Pub/Sub; always `acknowledge` within 3 days or Google auto-refunds. Model the full lifecycle, not just active/expired: **billing retry** and **grace period** (configure grace — commonly 16 days iOS, up to 30 on Play — and keep access ON during it; cutting off a user whose card merely expired is the cheapest churn you'll ever cause), account hold (access off, subscription alive), paused, and refunded (revoke within minutes of the notification, or refund abuse becomes a business). **Restore** must be one tap, no sign-in wall before it, and must merge store identity into your account system — reviewers reject apps that lose purchases on reinstall. In the **external-payment-link era** (post-2025 US ruling, EU DMA), you may steer to web checkout — worth it above roughly $1M/yr revenue where Stripe's ~3% beats the store's 15-30%, but you then own taxes, chargebacks, and family sharing yourself, and your entitlement service must merge web (Stripe/RevenueCat webhook) and store sources into one record. Rule: **No entitlement is ever granted or extended except by the server, from a store-verified transaction or a trusted payment webhook — the client only renders what the server says.**

BAD: "StoreKit says the purchase succeeded, so set `isPremium = true` in UserDefaults" (jailbreak tools and receipt spoofers flip that flag; refunds and family-plan revocations never reach it, so revoked users keep access forever). GOOD: "Client posts the JWS transaction to `/entitlements/verify`; server validates via App Store Server API, writes the entitlement row with expiry, and the client renders whatever `/entitlements/me` returns."

```
IAP ARCHITECTURE
════════════════
Products: [SKUs · sub groups/base plans · upgrade paths]
Entitlement svc: [user-ID keyed · states: active/retry/grace/hold/paused/revoked]
Verify: [StoreKit 2 JWS → App Store Server API · Play subscriptionsv2 + ack ≤3d]
Notifications: [ASSN v2 endpoint · RTDN Pub/Sub → handlers per event type]
Restore: [one-tap · store↔account merge rule] · Grace: [days · access stays on]
External payments: [yes/no · webhook source · merged into same entitlement row]
```

Skip when: the app has a single non-consumable and no server at all — StoreKit 2's on-device verification is acceptable for a $2 utility; or payments are entirely web-based with the app as a free companion (mind each store's reader/external-purchase rules).

Gotchas: validating receipts with the deprecated `verifyReceipt` endpoint instead of the App Store Server API — new fields and JWS transactions never arrive. Forgetting Play's acknowledge window and silently auto-refunding every Android sale after 3 days. Testing only the happy path — sandbox lets you compress billing retry and grace; teams that skip it ship access cutoffs that fire on the first real card decline. Keying entitlements on store account instead of your user ID, which breaks the moment one person uses two platforms or shares a family account.
