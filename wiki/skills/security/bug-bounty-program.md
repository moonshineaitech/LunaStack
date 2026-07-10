---
name: bug-bounty-program
description: Use when launching or fixing a vulnerability disclosure or bug bounty program — deciding VDP vs paid bounty, designing scope, setting triage SLAs, choosing platform vs self-run, or resolving duplicate and severity disputes. Produces a program design with scope, reward table, SLAs, and researcher-relations rules.
---

# /bug-bounty-program — Bounties That Researchers Actually Work

Use to design a bounty program that attracts good researchers instead of drowning triage in noise or burning goodwill with slow payouts.

**Persona: Bounty Program Operator.** Designs scope, sets rewards and SLAs, runs triage, and keeps researcher relations warm. Does NOT launch a paid program on an unhardened target, argue severity to save $500, or treat researchers as adversaries.

Climb the ladder: **security.txt + VDP** (safe-harbor disclosure policy, no rewards) first, then a **private bounty** with 20-50 invited researchers for ~3-6 months, and only go public once private-program signal is mostly duplicates — a public launch on soft targets buys you a triage flood, not coverage. Scope is the real design work: put the **crown jewels** in (production app, API, auth flows, tenant isolation) and the noise out (rate-limit nitpicks, `Self-XSS`, email spoofing on parked domains, third-party services you can't fix) — an explicit out-of-scope list cuts report volume ~40-60% without losing real findings. Platforms (**HackerOne**, **Bugcrowd**, **Intigriti**) rent you triage staff, researcher reach, and dispute mediation; self-run via a `security@` inbox plus GitHub Security Advisories works only if someone owns a **first-response SLA of 1 business day** and triage within 5. Pay on triage, not on fix — researchers don't control your sprint schedule, and payout latency is the #1 reputation killer on platform program pages. For disputes, pre-commit to **CVSS 4.0 as the baseline** adjusted by real business impact, pay the higher tier when severity is genuinely arguable, and treat duplicates generously (link the original report ID; consider partial credit when the dupe adds exploitation depth). Have counsel review the safe-harbor language once — Good-faith researchers need legal cover in writing; this is not legal advice. Rule: **Never launch paid bounties until your VDP has run ~90 days and internal fixes keep pace — a bounty amplifies whatever triage capacity you already have, including zero.**

BAD: "Launch a public $10k-top-bounty program to signal security maturity before the first pentest" (day one delivers 200 reports, 190 known issues or noise, and the backlog becomes the researcher-visible story). GOOD: "Run a VDP for a quarter, fix the known criticals, invite 30 researchers privately, then go public with a scope that names 6 in-scope assets and 10 explicit exclusions."

```
BOUNTY PROGRAM DESIGN
═════════════════════
Stage: [VDP / private / public] · Platform: [H1/Bugcrowd/Intigriti/self-run]
In scope: [assets] · Out: [exclusions + known-issue list]
Rewards: [Low $X · Med $X · High $X · Crit $X] · Paid at: [triage]
SLAs: first response [1 bd] · triage [5 bd] · fix target by sev: [C:x d / H:x d]
Disputes: [CVSS 4.0 + impact adj · dupe policy] · Safe harbor: [counsel-reviewed link]
Capacity check: [triage owner · fix bandwidth/week]
```

Skip when: you have no engineering capacity to fix findings (run a pentest with a fixed report instead); or the product is pre-launch with no production attack surface yet.

Gotchas: Downgrading severity to shrink payouts — researchers screenshot it, and one public dispute thread costs more than a year of honest payouts. Scoping out an asset because it's embarrassing rather than out of your control — that's exactly where researchers will look, without safe harbor. Letting "duplicate" become a black box: always cite the original report's ID or public reference, or accusations of dupe-farming follow. Forgetting internal routing — a bounty report that sits because no team owns the affected service blows every SLA you published.
