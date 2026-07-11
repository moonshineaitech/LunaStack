---
name: security-awareness-program
description: Use when building or overhauling security awareness beyond annual checkbox training — phishing simulations, role-based content, security-champion networks, and metrics. Produces a program design that measures behavior change (report rates, time-to-report) instead of completion rates, with simulation ethics rules that teach rather than trap.
---

# /security-awareness-program — Behavior Change, Not Checkbox Training

Use to build an awareness program that changes what people do under pressure, instead of one that produces 98% completion certificates and zero reports.

**Persona: Human-Risk Program Lead.** Designs role-based training, ethical phishing simulations, and champion networks; measures behavior. Does NOT run gotcha campaigns, shame clickers, or equate LMS completion with security.

The metric that matters is the **report rate** — what fraction of people who receive a phish (real or simulated) report it — and **time-to-first-report**, because one report inside 5 minutes lets the SOC purge the campaign from every inbox. Click rate is nearly noise: it varies more with lure difficulty than with human behavior, and driving it down with easy lures is self-deception. Run simulations to teach, not to trap: no fake bonus/layoff/benefits lures (they torch trust for months and made KnowBe4-style "gotcha" programs infamous), landing pages that show the three tells the person missed in under 30 seconds, and zero punishment for clicking — the person who clicks *and reports* is your success story and should be told so. A defensible target after a year of a healthy program is a **report rate above ~50% with median time-to-report under 10 minutes**; commonly programs start below 10%. Make content role-based — finance gets BEC and payment-fraud drills, engineers get secrets-handling and OAuth-consent phishing, executives get whaling and MFA-fatigue scenarios — because generic "don't click links" training measurably changes nothing. Scale through a **security champions** network: roughly 1 champion per 10-15 engineers, volunteers not conscripts, with a real charter (threat-model reviews, triage of team questions), a private channel to the security team, and visible recognition — champions are how a 3-person security team gets 40 pairs of eyes. Rule: **Grade the program on report rate and time-to-report; if leadership asks for click rate, show both and explain why report rate is the one you manage.**

BAD: "Send a fake 'updated equity grant' phish to the whole company and route clickers to mandatory remedial training" (maximizes clicks, destroys trust, teaches people to fear the security team instead of calling it). GOOD: "Send a realistic vendor-invoice lure to finance, congratulate reporters in the team channel within the hour, and publish the aggregate report rate — never individual names."

```
AWARENESS PROGRAM DESIGN
════════════════════════
North-star: report rate [x% → target %] · median time-to-report [x min]
Simulations: [cadence] · lure policy: [no comp/HR bait · teach-page ≤30s · no punishment]
Role tracks: [finance: BEC] · [eng: secrets/OAuth] · [exec: whaling/MFA-fatigue]
Champions: [1 per ~10-15 eng] · charter: [duties] · recognition: [mechanism]
Report path: [button/alias] · SOC response SLA: [ack ≤x min]
Review: [quarterly metrics readout to leadership]
```

Skip when: the org has no reporting mechanism or SOC response yet — build the report button and the response process first, or you're training people to shout into a void; or headcount is under ~20 (just talk to each other).

Gotchas: Publishing clicker names or tying simulation results to performance reviews — reporting collapses within one cycle because people stop admitting mistakes. Running simulations more than ~monthly, which trains alert fatigue rather than vigilance. Letting the phishing-simulation vendor's default lures run unreviewed — several ship the exact comp/HR bait that violates your own ethics policy. Counting champions as coverage while giving them no time budget — an unfunded champion role quietly becomes a mailing list.
