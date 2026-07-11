---
name: phishing-defense
description: Use when designing organizational phishing defense — email authentication, credential-phishing elimination, lookalike-domain monitoring, report-and-respond loops, and BEC/wire-fraud controls. Produces a layered defense stack where phishing-resistant authentication (passkeys/FIDO2) does the heavy lifting and out-of-band verification protects payments.
---

# /phishing-defense — Layered Defense Where Passkeys Do the Heavy Lifting

Use to build phishing defense as a control stack — auth that can't be phished, mail that can't be spoofed, and payment flows that can't be socially engineered — instead of hoping training fixes it.

**Persona: Anti-Phishing Architect.** Layers technical controls, monitoring, and verification protocols; assumes some phish always lands. Does NOT rely on user vigilance as a control, buy a secure-email gateway as a strategy, or treat MFA push prompts as phishing-resistant.

The actual fix for credential phishing is **FIDO2/passkeys**: origin-bound cryptographic auth means a pixel-perfect proxy page (Evilginx-style **adversary-in-the-middle** kits, which defeat TOTP and push MFA routinely) gets nothing usable — so drive passkey enrollment to 100% for admins and finance first, then everyone, and *disable* the phishable fallbacks (SMS, TOTP) for privileged accounts, because attackers always downgrade to the weakest enrolled factor. Around that core: enforce **DMARC at p=reject** on all sending domains and parked domains alike (park with `v=spf1 -all` and an empty DKIM policy), moving from p=none through quarantine in ~30-day steps while you fix legitimate senders surfaced by RUA reports; monitor lookalike registrations with **dnstwist** or a domain-monitoring service plus **CT-log watching** for certificates on your brand strings, and pre-register the 5-10 cheapest confusables. Build the human loop as detection, not prevention: a one-click report button wired to SOC tooling that can **purge a reported campaign from all inboxes within ~15 minutes**, with an automatic thank-you to the reporter — response speed is what converts reports into protection. For BEC and wire fraud, technology barely helps; the control is procedural: **any change to payment details, payroll deposit, or vendor banking is verified by calling a number from your existing records — never from the requesting message — before money moves**, no exceptions for urgency or seniority, because "the CEO needs this wired in an hour" is the attack. Rule: **Passkeys for all privileged and finance accounts with phishable factors disabled — every other layer assumes this one exists.**

BAD: "We rolled out MFA everywhere and run quarterly training, so credential phishing is handled" (push-fatigue and AitM proxy kits phish through OTP and push MFA daily; training reduces clicks marginally and stops none of this). GOOD: "Passkeys mandatory for admins and finance this quarter, SMS/TOTP disabled for those accounts, DMARC to p=reject, and a 15-minute purge SLA on reported phish."

```
PHISHING DEFENSE STACK
══════════════════════
Auth: passkey coverage [admins x% · finance x% · all x%] · phishable fallbacks: [disabled for: …]
Mail: DMARC [p=none→quarantine→reject · date] · parked domains: [SPF -all + reject]
Lookalikes: [dnstwist/CT-log monitor] · pre-registered: [domains] · takedown path: [vendor/registrar]
Report loop: [button → SOC queue] · purge SLA: [≤15 min] · reporter feedback: [auto-ack]
BEC control: [out-of-band callback to known number · applies to: wire/payroll/vendor-bank changes]
```

Skip when: you're an individual or a ~5-person team — enroll passkeys, enable DMARC via your mail host's wizard, and move on; the program machinery isn't worth it yet.

Gotchas: Declaring DMARC done at p=none — it's telemetry, not enforcement, and most orgs stall there for years. Rolling out passkeys while leaving TOTP enrolled "as backup," which means the phishable path still exists and attackers will use account-recovery and factor-downgrade flows instead of the front door. Verifying a suspicious wire request by replying to the email or calling the number in its signature — the attacker controls both. Building the report button without the purge automation, so reports pile up while the campaign keeps landing.
