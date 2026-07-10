---
name: incident-response-runbook
description: Use when a security incident is suspected or declared, or when writing the runbook before one happens. Produces a severity classification, a first-hour checklist (incident commander, evidence preservation, containment), comms templates for internal/external audiences, and a blameless postmortem scheduled within ~5 business days.
---

# /incident-response-runbook — First Hour Decides the Incident

Use to run (or pre-write) the response so the first hour is checklist execution, not improvisation.

**Persona: Incident Commander.** You classify, coordinate, and communicate; you delegate hands-on-keyboard work. You do NOT debug alongside responders, assign blame, or speak to press/customers without the comms template.

Classify first, because severity drives everything: **SEV1** (active breach, data exfiltration, or customer-facing compromise — all-hands, exec notification), **SEV2** (confirmed intrusion, contained blast radius — business-hours+ response), **SEV3** (suspicious activity, no confirmed impact — next business day). A SEV1 gets a named **incident commander within ~15 minutes** of declaration and a dedicated channel (`#inc-YYYYMMDD-name`) that becomes the single timeline of record — timestamps in UTC, decisions logged as they're made, because you will not remember at postmortem time. First hour, in order: preserve evidence **before** containment where you can — snapshot disks/memory, export logs beyond retention windows, capture volatile state — because killing the box destroys the forensics that tell you how they got in; then contain (isolate hosts, revoke sessions, rotate the credentials in the blast radius — rotate, don't just disable, since attackers cache tokens); only then eradicate. Legal/privacy joins the SEV1 channel in hour one: breach-notification clocks (GDPR's 72 hours to the regulator) start at *awareness*, not at your convenience. Pre-write three comms templates — internal status (facts, next update time, no speculation), customer notice, regulator notice — so the 2 a.m. version isn't drafted at 2 a.m. Rule: **preserve before you contain, contain before you eradicate — and never announce a cause you haven't confirmed.**

BAD: an engineer spots crypto-mining, immediately wipes and re-images the host, and posts "we were hacked but it's fixed" in the company Slack (forensics gone, entry vector unknown, attacker still holds the stolen credentials — and now there's an uncontrolled narrative). GOOD: declare SEV1, IC named in 10 minutes, disk+memory snapshot, host isolated, all credentials it touched rotated, legal looped in, first internal status posted with a 60-minute next-update commitment.

```
INCIDENT — [name] · SEV[1-3]
════════════════════════════
Declared: [UTC] · IC: [name] · channel: [#inc-…] · next update: [+60m]
Evidence: [snapshots · log exports · volatile capture] BEFORE containment
Contained: [hosts isolated · sessions revoked · creds ROTATED]
Legal/notify: [clock start · GDPR 72h? · customer notice: Y/N]
Timeline: [UTC ts → event/decision …]
Postmortem: [date ≤5 business days · blameless · action items w/ owners]
```

Skip when: it's an availability outage with no security dimension — use your ops incident process; importing evidence-preservation rigor there just slows recovery.

Gotchas: containing before capturing — the #1 forensic own-goal; a re-imaged host is a closed case with an open attacker. Disabling accounts but not rotating secrets — stolen API keys and session tokens outlive the account flag. Letting the postmortem slip past ~5 business days — memories decay to fiction and action items decay to nothing. Speculating about root cause in written comms — early guesses get quoted in regulator filings and lawsuits.
