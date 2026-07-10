---
name: bdd-collaboration-testing
description: Use when a team is adopting or auditing BDD/Gherkin (Cucumber, SpecFlow/Reqnroll, Behave) and needs to decide where it earns its cost. Applies the honesty test — Gherkin only where business stakeholders actually read or write scenarios — and enforces declarative scenario style and step-definition hygiene. Produces a BDD scope decision, rewritten declarative scenarios, and a step-vocabulary standard.
---

# /bdd-collaboration-testing — Gherkin Only Where the Business Actually Reads It

Use to decide where BDD genuinely aids collaboration, write declarative scenarios there, and strip Gherkin theater everywhere else.

**Persona: BDD Pragmatist.** Runs the honesty test before writing a single feature file, facilitates example-mapping with real stakeholders, and keeps the step vocabulary small and business-worded. Does NOT wrap developer-only integration tests in Given/When/Then, and does not accept scenarios written by developers alone after the fact as "BDD."

BDD's value is the **conversation** — discovering requirements through concrete examples (example mapping, three amigos) before code — and the executable Gherkin is merely the receipt. So apply the honesty test: if no product owner, domain expert, or QA-business hybrid will read, review, or help write the scenarios within the next quarter, skip Cucumber/Reqnroll/Behave and write plain tests with good names; the Gherkin translation layer costs real maintenance (regex/expression matching, step registries, world state) and buys nothing without a business reader. Where BDD is real, write **declarative** scenarios at the business-rule level — "Given a customer with an expired card, When they check out, Then the order is held for payment retry" — never imperative UI scripts ("When I click #submit"): UI mechanics belong inside step definitions or a page/driver layer, so scenarios survive redesigns. Keep hygiene tight: a shared ubiquitous-language step vocabulary (commonly ~50-150 steps for a whole product — if you're past ~200 or steps are used once each, you're writing scripts, not specs); steps compose domain actions, hold no assertions in Given, no logic branching; scenario state flows through a typed context/world object, never globals. Cap scenarios at roughly 5-7 steps and one rule each — longer means you're testing a workflow, which belongs in an e2e suite, not a spec. Rule: **If business stakeholders won't read or co-author the scenarios, don't write Gherkin — the format without the conversation is pure overhead.**

BAD: "Developers retrofit 300 Gherkin scenarios over existing UI tests so the project 'does BDD'" (nobody business-side reads them, steps are one-off click scripts, and every redesign breaks hundreds of feature files). GOOD: "Example-map the 12 core pricing rules with the PO, encode them as declarative scenarios she reviews in PRs, and keep the rest of the suite as plain integration tests."

```
BDD SCOPE DECISION
══════════════════════════════════════════
HONESTY TEST: business reader/co-author? [who · cadence] → verdict: [real BDD / plain tests]
IN SCOPE: [domains with real collaboration] · OUT: [dev-only areas → plain test framework]
SCENARIO STYLE: declarative · [≤7 steps] · one rule each · UI mechanics in [driver layer]
STEP VOCABULARY: [n steps] · reuse ratio [avg uses/step] · owner: [name]
DISCOVERY RITUAL: [example mapping/three amigos · when]
```

Skip when: no business stakeholder will ever engage with scenarios (write plain tests with descriptive names), or the behavior is purely technical (serialization, caching) where Gherkin adds a translation layer with no audience.

Gotchas: writing scenarios after the code turns BDD into expensive documentation of what was built, not discovery of what's needed; "And I wait 2 seconds / And I click the third button" imperative steps weld specs to the DOM; conjunction steps ("Given a user exists and has a cart and is logged in") destroy reuse — split them; and measuring BDD success by scenario count invites theater, so measure by defects caught in the example-mapping conversation before code was written.
