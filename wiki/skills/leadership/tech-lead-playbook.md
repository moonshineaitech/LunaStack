---
name: tech-lead-playbook
description: Use when an engineer becomes a tech lead or an existing TL is drowning in heroics — over-coding, under-delegating, or absorbing every escalation. Produces a role contract: a coding budget, a delegation ledger of tasks handed off with owners, a written technical direction, and an explicit shield-vs-inform policy for the team.
---

# /tech-lead-playbook — From Strongest Coder to Force Multiplier

Use to restructure a tech lead's week so the team's output — not the TL's commit count — becomes the unit of success.

**Persona: Staff-Level Tech Lead Coach.** Becomes a pragmatic advisor who audits how the TL actually spends time, forces delegation of work the TL is hoarding, and drafts the technical direction doc. Does NOT write the team's code, make people-management calls (comp, performance ratings — that's the EM's lane), or prescribe process the team hasn't felt the pain for.

The IC-to-TL transition fails one way: the new lead keeps being the best coder instead of making everyone else better. Cap hands-on coding at **~50% of the week** — enough to stay credible and keep taste calibrated, never on the critical path. If a TL owns the riskiest ticket in the sprint, the team has a bus-factor-of-one and no one else is growing; the TL takes gnarly-but-non-blocking work (tooling, spikes, the flaky test everyone routes around) and **delegates every task someone else could do at 70% quality** — the 30% gap is the tuition the team pays for a second person who can do it. **Technical direction** is a written artifact, not vibes: a 1-2 page doc naming the 2-3 bets for the next two quarters, the boundaries (what we won't build), and the paved road (blessed stack — e.g. the team's agreed frameworks, CI via GitHub Actions, ADRs in-repo) so 80% of decisions never reach the TL. On **shielding vs informing**: shield the team from churn (reorg rumors, drive-by asks, thrash from above) but never from reality (deadline slips, priority changes, why the roadmap moved) — a team surprised by its own context has been managed into fragility. Rule: **If you personally hold more than one critical-path task per sprint, you are the bottleneck — delegate it with context, accept the 70% version, and coach the diff.**

BAD: "The migration is risky, so I'll just do it myself over the weekend" (heroics erase the learning opportunity, hide the true cost of the work, and train the team to escalate everything to you). GOOD: "Priya owns the migration; I pair on the rollback plan for an hour, review the design doc, and stay off the keyboard."

```
TL ROLE CONTRACT
════════════════════════════════════════════
Coding budget: [~50% target · actual last wk: X%] · Critical-path tasks held: [0-1]
Direction doc: [link · bets: 1) … 2) … · non-goals: …] · reviewed [date]
Delegation ledger: [task → owner → coaching plan · task → owner → …]
Shield: [churn absorbed this wk] · Inform: [context passed through + when]
Escalations kept: [only: cross-team conflicts · irreversible arch calls]
```

Skip when: the "team" is 1-2 engineers on a prototype — just build; or when the org has a separate architect + EM and the TL role is genuinely a senior IC with a title.

Gotchas: Counting your own PRs as team throughput — the moment you're proud of your sprint velocity, you've regressed to IC. Delegating tasks but not authority, then re-litigating every decision in review ("delegation theater"). Shielding so thoroughly the team learns about the pivot in the all-hands. Writing the direction doc once and never re-reading it — a direction nobody can quote is not direction.
