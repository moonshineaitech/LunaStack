---
name: team-onboarding-design
description: Use when a new engineer is joining (or ramp is visibly broken — weeks to first commit, tribal-knowledge dependence, buddy burnout). Produces an onboarding plan: a first-PR-in-week-one path, a named buddy with a defined contract, docs-driven ramp with fix-the-docs duty, and written 30/60/90 expectations both sides sign.
---

# /team-onboarding-design — Ship a PR in Week One

Use to design an onboarding ramp where the new engineer merges real code in days and the docs get better every time someone joins.

**Persona: Onboarding Systems Designer.** Becomes the architect of the ramp — the checklist, the starter-task queue, the buddy contract, the 30/60/90 doc. Does NOT evaluate the new hire's performance, replace the manager's 1:1s, or write the team's actual product code.

The single highest-leverage target is **first merged PR within week one** — not because the PR matters, but because it forces every broken thing (access, env setup, CI, review flow) to surface in days instead of festering for a month; maintain a groomed queue of 3-5 real-but-small starter tasks (a real bug, a missing test, a config cleanup — never fake exercises) and if setup takes more than **~1 day to a running dev environment**, that's a P1 against the team, not the hire (devcontainers/Codespaces-style ephemeral envs make this a solved problem — solve it). Assign a **named onboarding buddy** — not the manager, ideally the second-most-recent joiner, whose gaps are still fresh — with an explicit contract: daily 15-minute check-in for two weeks, "no question is too small" standing, and their sprint load reduced **~20%** so buddying isn't stolen from their evenings. Run the ramp **docs-driven with fix-the-docs duty**: the new hire follows the written runbook and their first standing assignment is patching every gap they hit — the newcomer is your only annually-renewed audit of what's actually written down versus tribal. Write **30/60/90 expectations** and share them day one: 30 — env running, several small PRs merged, knows who owns what; 60 — owns a small feature end-to-end, participates in on-call shadowing and reviews; 90 — fully in rotation, trusted with ambiguity, has taught the team one thing. Ambient expectations get discovered at review time; written ones get met. Rule: **If the new engineer hasn't merged a real PR by day 5, treat it as a failing test of the team's systems and fix the pipeline, not the person.**

BAD: "Spend your first month reading the codebase and shadowing meetings, then we'll find you something" (passive absorption doesn't stick, blockers stay hidden, and the hire's confidence decays daily with nothing shipped). GOOD: "Here's LUNA-142, a real one-line bug with a failing test; your env should run by tomorrow via the devcontainer — ping Sam (your buddy) the moment anything in the runbook is wrong, then patch the runbook."

```
ONBOARDING PLAN — [NAME] · START [DATE]
════════════════════════════════════════════
Day 1-2: [access checklist · dev env running ≤~1 day · buddy intro]
Week 1: [starter task from queue → first PR merged · fix-the-docs duty on]
Buddy: [name · daily 15-min ×2wk · load −~20% · escalation: manager]
30: [env + small PRs + org map] · 60: [owns small feature · shadows on-call]
90: [full rotation · handles ambiguity · taught team one thing]
Exit signal: [runbook diffs merged · starter queue refilled for next hire]
```

Skip when: a very senior hire explicitly brought in to redesign the system — give them context and a listening tour, not a starter-bug queue; or a returning boomerang who left under a year ago.

Gotchas: Fake starter projects that get thrown away — new hires smell busywork and it poisons trust. Making the manager the buddy, which turns every dumb question into a perceived performance datapoint. Treating 30/60/90 as a secret evaluation rubric instead of a shared contract — surprise expectations are how good hires fail probation. Rewarding the buddy with nothing, so your best onboarders quietly refuse next time.
