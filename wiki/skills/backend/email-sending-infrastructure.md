---
name: email-sending-infrastructure
description: Use when setting up or auditing transactional/product email sending — new domain, new provider, or deliverability trouble. Produces a sending infrastructure plan: SPF/DKIM/DMARC/BIMI records, domain and IP warming schedule, bounce/complaint suppression wiring, stream separation, template testing, and provider failover design.
---

# /email-sending-infrastructure — Land in the Inbox, Stay There

Use to stand up email sending that survives Gmail/Yahoo bulk-sender enforcement: authenticated domains, warmed reputation, and suppression handling treated as a launch blocker.

**Persona: Deliverability engineer who has dug a domain out of the spam folder.** You treat reputation as an asset with a warm-up curve and a suppression ledger; you do NOT write marketing copy, and you never let a send path ship without bounce and complaint webhooks wired to suppression.

Authentication is table stakes, not the finish line: **SPF** and **DKIM** (2048-bit keys, rotate ~annually) must both pass *and align* with the From domain, plus **DMARC** — start at `p=none` with `rua` aggregate reports, move to `p=quarantine` then `p=reject` once reports show only legitimate sources for ~2–4 weeks. **BIMI** (logo in inbox) requires DMARC at enforcement plus a paid VMC, so it comes last. Split streams: transactional on its own subdomain (`txn.example.com`), marketing on another — one bad campaign must not sink password resets, and subdomain reputation is largely independent. **Warm** every new domain/IP: begin around ~100–200 messages/day to your most-engaged recipients and roughly double every 2–3 days over 4–6 weeks; dedicated IPs only make sense above ~100k emails/month sustained — below that, shared pools (SES, Postmark, Resend) warm you for free. The hard requirements mailbox providers actually enforce: spam **complaint rate** under 0.3% (Gmail's hard threshold — target <0.1%), hard **bounce rate** under ~2%, and RFC 8058 **one-click List-Unsubscribe** headers on anything bulk-ish over ~5k/day. Wire provider webhooks (SES event destinations, Postmark/SendGrid webhooks) so hard bounces and FBL complaints hit a shared suppression list synchronously — before the next send, not in a nightly job. Test templates by rendering across clients (Litmus/Email on Acid or Testsend), always include a plain-text part, and keep HTML under ~102KB to dodge Gmail clipping. For failover, abstract the provider behind your own send API, pre-provision DKIM at the standby provider, and fail over on sustained 5xx/deferral spikes — but expect the standby's reputation to be cold. Rule: **No send path ships until bounce and complaint webhooks feed a suppression list checked on every send — complaint rate <0.1%, hard cap 0.3%.**

BAD: "Blast the full 200k-user announcement from the brand-new domain the day DNS propagates" (zero reputation plus sudden volume pattern-matches to spam; Gmail tempfails then junk-folders everything, including next week's receipts). GOOD: "Warm txn.example.com over 4 weeks starting ~200/day to engaged users, DMARC p=none→reject as reports come clean, suppression wired before the first campaign."

```
EMAIL SENDING PLAN
══════════════════════════════════════════
Auth:        SPF [pass+align] · DKIM [2048, rotate ~1y] · DMARC [none→quarantine→reject, rua set] · BIMI [after reject]
Streams:     transactional [txn.domain] · marketing [mail.domain] · reputations [independent]
Warming:     start [~100–200/day] · double every [2–3d] · [4–6 wks] · dedicated IP [only >~100k/mo]
Suppression: hard bounce → suppress [sync] · FBL complaint → suppress [sync] · shared across [streams? decide]
Thresholds:  complaints [<0.1%, cap 0.3%] · bounces [<2%] · one-click unsub [RFC 8058 if bulk]
Templates:   client matrix [tested] · plain-text part [yes] · HTML [<102KB]
Failover:    provider abstraction [own API] · standby DKIM [pre-provisioned] · trigger [sustained 5xx/deferrals]
```

Skip when: you send only a handful of internal/ops emails a day (a default SES setup with alarms is enough), or email is fully delegated to a product like Customer.io that owns suppression and warming for you.

Gotchas: SPF passing on the Return-Path while the From domain differs fails DMARC alignment — check alignment, not just "SPF: pass". Suppression lists silo per provider by default, so switching providers resurrects every dead address and torches the new IP — export and own your suppressions. Retrying hard bounces "just in case" is how you hit spam traps; hard means never. `p=reject` before auditing rua reports silently kills mail from the billing system nobody remembered sends invoices.
