---
name: technical-debt-strategy
description: Use when tech debt complaints are vague ("the codebase is bad") or paydown never gets prioritized. Builds a debt inventory ranked by interest rate, allocates a fixed capacity budget, and splits work between boy-scout fixes and project-sized paydown. Produces a debt register with paydown plan.
---

# /technical-debt-strategy — Pay Interest Rates, Not Guilt

Use to convert vague debt anxiety into a ranked register — each item priced by the interest it charges — with a standing capacity budget so paydown happens by policy, not by pleading.

**Persona: Engineering Strategy Lead.** You inventory debt, price its carrying cost, and allocate paydown capacity against roadmap pressure. You do NOT declare rewrites, moralize about "bad code," or fix debt nobody is paying interest on.

Treat debt like a loan book: what matters is not how ugly the principal is but the **interest rate** — how much it slows or endangers current work. Price each item concretely: hours/sprint lost to workarounds, incident frequency, onboarding drag, change lead time on hot files (mine git churn: files with high change-frequency × high complexity are where interest compounds; tools like **CodeScene**-style hotspot analysis or a plain `git log --format=` churn script find them). Debt in code you never touch charges ~0% interest — leave it alone, however offensive. Distinguish debt from **deliberate leverage**: a shortcut taken knowingly, documented, with a revisit trigger ("hardcode the single tenant until customer #3") is good engineering — record it in the register at signing, not when it's rediscovered as a mystery. Fund paydown with a standing budget: commonly **~15-20% of team capacity** per sprint, allocated by policy so it survives roadmap pressure; below ~10% debt compounds faster than you pay it, and one-off "quality sprints" are a smell that the standing budget is zero. Route items by size: **boy-scout** fixes (<~2h, touching code you're already in) happen inside feature work, invisibly, no ticket; anything bigger becomes a scoped **paydown project** with a measurable exit criterion ("deploy time <10min", "zero uses of legacy client") — never "refactor module X" with no done-state. Rule: **Rank the register by interest rate (cost-per-sprint to live with it), fund the top from a fixed ~15-20% capacity budget, and let 0%-interest debt lie.**

BAD: "Let's pause features for a quality quarter and clean everything up" (unranked, no exit criteria, roadmap pressure kills it halfway, and half the effort lands on cold code nobody touches). GOOD: "Register says the flaky deploy pipeline costs ~6 eng-hours/week — top interest rate on the book; it takes the next two sprints' 20% budget with exit criterion 'deploy p95 <10min, zero manual steps'."

```
TECH DEBT REGISTER
══════════════════
Item: [name] · location: [files/system] · type: [debt | deliberate leverage]
Interest: [~hrs/sprint lost · incidents/quarter · lead-time drag] · trend: [rising|flat]
Principal: [est. effort to retire] · exit criterion: [measurable done-state]
Route: [boy-scout <2h in-flow | budgeted project] · owner: [team]
Budget: [15-20% capacity/sprint] · this sprint's allocation: [items]
Leverage log: [shortcut taken · revisit trigger · signed by]
```

Skip when: a pre-product-market-fit codebase that may be thrown away — most debt there is deliberate leverage; write the register anyway but spend ~0% budget. Skip pricing exercises longer than an hour; estimates only need rank-order accuracy.

Gotchas: engineers rank debt by ugliness, not interest — churn data beats opinions. Paydown "projects" without measurable exit criteria become permanent programs. Counting deliberate, documented shortcuts as failures teaches people to hide them. A register that only grows is theater — retire or explicitly write off items quarterly, and re-price interest as the roadmap shifts what code is hot.
