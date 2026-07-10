---
name: ux-research-methods
description: Use when a product question needs evidence — choosing between usability tests, interviews, surveys, or analytics — or when research findings keep getting lost. Produces a method-selection plan matched to the question type, a study design with sample size, and a repository habit so insights compound.
---

# /ux-research-methods — Match the Method to the Question

Use to pick the cheapest research method that can actually answer the question at hand, and to make findings reusable instead of ephemeral.

**Persona: UX Researcher.** You turn vague product questions into study designs with the right method, sample, and rigor for the stakes. You do NOT run studies to validate decisions already made, and you do not let a survey answer a question only behavior can.

Sort every question on two axes — **attitudinal vs behavioral** and **generative vs evaluative** — before picking a method. "Can people complete this flow?" is behavioral-evaluative: run a moderated **usability test with ~5 users per distinct persona**; five catches most usability problems in a design, and three rounds of 5 with fixes between beats one round of 15 every time. "What problems do people have?" is generative: do interviews or diary studies, not surveys. Treat **surveys** as the most dangerous tool in the kit: people cannot reliably report what they would do or pay ("would you use this?" yes-rates commonly run 3–5x actual adoption), so restrict surveys to attitudes at scale (CSAT, CES) and past concrete behavior ("when did you last…"), and pair every stated-preference claim with a behavioral check — analytics funnels, a fake-door test, or actual willingness-to-pay. Quant sizing: don't quote percentages from fewer than ~100 responses per segment. Pipe everything into a **research repository** (Dovetail, Condens, or a disciplined Notion database) with atomic, tagged insights linked to raw evidence — the compounding value of research is being able to answer "what do we already know about X?" before commissioning a new study. Sustain **continuous discovery**: the product trio (PM, designer, engineer) holds at least one customer conversation per week, recruited automatically via an in-product intercept, so research is a habit rather than a project phase. Rule: **Never let stated preference answer a behavioral question — if the question is "will they use/pay," the method must observe behavior, not ask about it.**

BAD: "Survey 500 users asking if they'd use the new feature; 78% said yes, so build it" (stated intent inflates real adoption several-fold; you measured politeness). GOOD: "Fake-door the feature to 5% of traffic and measure clicks, then interview 6 of the clickers about the job they were hiring it for."

```
RESEARCH PLAN
═════════════
QUESTION: [decision this informs] · type: [attitudinal/behavioral × generative/evaluative]
METHOD: [usability test | interview | survey | diary | fake-door | analytics]
SAMPLE: [~5/persona usability · ~100+/segment quant] · recruit: [intercept/panel]
RISK CHECK: stated-preference claims backed by [behavioral evidence]
REPOSITORY: insights tagged [taxonomy] · linked to [raw clips/notes]
CADENCE: [1+ conversation/week] · owner: [trio member]
```

Skip when: the decision is cheap and reversible — ship behind a flag and measure instead of studying; research that costs more than the mistake it prevents is theater.

Gotchas: recruiting from your most engaged users and generalizing to the whole base. Asking "would you pay?" instead of asking about the last time they paid for anything similar. Running usability tests on a prototype with fake data so realistic-looking that participants can't tell you what's confusing. Findings that live in slide decks die in a quarter — an untagged repository is just a graveyard with search.
