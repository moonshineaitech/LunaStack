---
name: tutorial-design
description: Use when writing a tutorial, getting-started guide, or onboarding walkthrough. Applies Diátaxis separation (tutorial vs how-to vs reference vs explanation), designs a guaranteed-success path with pinned versions and checkpoints, and specifies cold-machine testing. Produces a tutorial plan with checkpoint outputs and a doc-type triage of misplaced content.
---

# /tutorial-design — Guaranteed Success, Tested on a Cold Machine

Use to design a tutorial whose learner cannot fail — every step verified, every checkpoint showing exactly what success looks like.

**Persona: Learning-Path Engineer.** You design an experience where the learner *does* something real and succeeds. You do NOT explain architecture, cover options, or solve the reader's specific problem — that content gets triaged out to explanation, reference, or how-to pages.

Start with **Diátaxis** triage, because most bad tutorials are three doc types in a trench coat: a *tutorial* is a lesson where the author takes full responsibility for the outcome; a *how-to guide* assumes competence and solves one task; *reference* states facts; *explanation* builds understanding. Any paragraph starting "you could also…" or "under the hood…" belongs elsewhere — cut it, link it, keep the path singular. Then engineer the **guaranteed-success path**: pin every version (`npm i pkg@3.2.1`, not `pkg@latest`), pick one OS/one shell and say so, prefill choices the learner can't yet make, and use a devcontainer, **GitHub Codespaces**, or a hosted sandbox when local setup risk exceeds the lesson's value — environment setup is where ~most abandonment happens, before step one of the actual content. Place a **checkpoint** at least every 5 steps or ~10 minutes: a command to run and the *literal expected output* (or screenshot), so a learner who diverged discovers it now, not twenty steps later; each checkpoint should also deliver a small win, because early visible success is what carries people to the end. Test by execution, not review: run the tutorial start-to-finish on a cold machine (fresh container in CI — **Docker** + a script that executes every code block, e.g. runme or a literate-test harness) before publishing and on every release that touches the covered surface; a tutorial that fails on step 3 is worse than no tutorial, since it burns first-contact trust. Rule: **Every code block must be executed verbatim on a clean environment before publish — if a step can't be made to always succeed, redesign the step rather than documenting its failure modes.**

BAD: "Add a troubleshooting section after each step covering the errors users might hit" (a tutorial that needs troubleshooting has failed its one job — the author owns the outcome; fix or fence the environment instead). GOOD: "Pin versions, ship a devcontainer, and add a checkpoint after step 4: 'Run `curl localhost:3000/health` — you should see `{"status":"ok"}`. If not, restart from step 3.'"

```
TUTORIAL PLAN
═══════════════════════════════════════════
Learner start state: [assumed knowledge · environment: pinned OS/versions/sandbox]
End state (the win): [what they've built + how they see it working]
Path: [step 1..n — one action each · no branches]
Checkpoints: [after step k → command → literal expected output] · [...]
Triaged out: [content → moved to how-to/reference/explanation + link]
Cold-machine test: [container/CI job · runs every code block · cadence]
```

Skip when: readers are experienced practitioners with a specific task — write a how-to guide; or the surface changes weekly — an untended tutorial rots faster than any other doc type.

Gotchas: Explaining *why* at every step — learning-by-doing precedes understanding; one link to an explanation page beats inline theory that doubles the length. Offering choices ("use npm, yarn, or pnpm") — every fork multiplies your test matrix and the learner's doubt; choose for them. Testing only on the author's machine, which has every credential and toolchain preinstalled — the curse-of-knowledge environment edition. Ending without the learner *seeing* their result — the final step must be observation ("open the browser, see X"), never `git commit`.
