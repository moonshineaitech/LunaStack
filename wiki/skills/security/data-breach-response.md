---
name: data-breach-response
description: Use when a suspected or confirmed data breach involves personal data, customer data, or regulated records — the non-technical half of incident response. Produces a response sequence covering privileged counsel engagement, notification-clock tracking, forensic evidence preservation, and honest communications. Not legal advice; breach counsel drives the legal calls.
---

# /data-breach-response — The Half of Breach Response That Isn't Technical

Use to run the legal, regulatory, and communications track of a breach so the technical containment work doesn't create privilege, evidence, or notification disasters.

**Persona: Breach Response Coordinator.** Sequences counsel, forensics, notification, and comms alongside technical containment. Does NOT make legal determinations, draft notifications without counsel, or speculate about scope in writing. This is not legal advice — a licensed attorney (breach counsel) makes every notification and disclosure call.

The first call is to **outside breach counsel, before the forensics firm and before any written analysis** — counsel engages the forensic investigators so their work product sits under attorney-client privilege, and courts have pierced privilege where the forensics firm was hired directly by IT or under a pre-existing MSSP contract. From the moment of reasonable suspicion, two clocks may already be running: **GDPR gives ~72 hours from awareness to notify the supervisory authority**, and other regimes differ sharply — US state laws range from "without unreasonable delay" to 30-day statutes, sector rules (HIPAA, GLBA), SEC 8-K material-incident disclosure for public companies, and CIRCIA for critical infrastructure all have their own triggers; counsel confirms which apply, but *you* must surface the suspected-breach timestamp honestly, because "when did you know" is the question every regulator asks first. Preserve before you clean: forensic-image or snapshot affected systems (EBS/disk snapshots, memory captures) **before reimaging anything**, freeze log-retention deletion jobs, and start a timestamped incident log — the instinct to wipe-and-rebuild destroys the evidence that later proves the breach was smaller than feared. Route all written incident communication through a counsel-directed channel, label it privileged, and ban speculation ("we lost everything") in Slack — internal hyperbole is discoverable. When you notify, be plainly honest about what you know and don't: state facts, concrete user actions, and a follow-up commitment; companies get punished for minimizing ("out of an abundance of caution" for a confirmed exfiltration) far more than for the breach itself. Rule: **Counsel is engaged before any forensic firm, written scope assessment, or notification draft exists — privilege can only be built forward, never retrofitted.**

BAD: "The infra team reimages the compromised hosts overnight to restore service, then writes up what they found for the exec team" (evidence gone, timeline unprovable, and the write-up is a discoverable document created outside privilege). GOOD: "Snapshot and isolate the hosts, restore service from clean infrastructure, and have counsel engage the forensics firm before anyone writes conclusions."

```
BREACH RESPONSE TRACKER
═══════════════════════
Awareness: [timestamp + how] · Counsel engaged: [firm · time] · Privilege channel: [where]
Clocks: [GDPR ~72h → due] · [state/sector: per counsel] · [SEC/CIRCIA: per counsel]
Preservation: [snapshots taken] · [log deletion frozen] · [incident log owner]
Scope (known/unknown): [data types · record count est. · confirmed vs suspected]
Notifications: [regulator · individuals · customers/DPAs] — drafted by [counsel]
Comms: [holding statement owner · no-speculation rule acknowledged by responders]
```

Skip when: the incident provably touches no personal, customer, or regulated data (a defaced marketing page) — run the standard incident-response runbook instead; even then, log the determination and who made it.

Gotchas: Letting cyber-insurance panel requirements surprise you mid-incident — many policies void coverage if you hire non-panel counsel or forensics, so know the panel before the breach. Notifying users before counsel confirms scope, then issuing three expanding corrections that each restart the news cycle. Treating "we use encryption" as a notification exemption without counsel verifying the safe-harbor conditions actually apply to the compromised keys. Deleting the attacker's artifacts (webshells, tooling) during cleanup — they're evidence and often the only proof of what was *not* accessed.
