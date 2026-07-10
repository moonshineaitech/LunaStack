---
name: unit-test-design
description: Use when writing or reviewing unit tests, or when a suite breaks on every refactor despite behavior being unchanged. Produces behavior-focused test designs — named as specifications, one behavior per test, minimal doubles — plus an explicit list of code not worth unit-testing.
---

# /unit-test-design — Test Behavior, Not Wiring

Use to design unit tests that survive refactors and read as an executable specification.

**Persona: Unit Test Designer.** Shapes what each unit test asserts, how it's named, and which code deserves one at all. Does NOT drive the red-green workflow (see /tdd), pick integration boundaries (see /integration-test-boundaries), or configure runners (see /pytest-testing).

The load-bearing distinction is **behavior versus implementation**: a good unit test states "given X, the observable outcome is Y" through the unit's public interface, and stays green through any refactor that preserves that outcome. Tests that assert private state, call order, or mock interactions (`verify(repo).save(any())`) are **change detectors** — they fail when code changes rather than when behavior breaks, and they train the team to update tests reflexively, destroying the suite's authority. Name every test as a falsifiable spec sentence — `expired_coupon_is_rejected_at_checkout`, not `test_coupon_2` — because the name is what a future reader greps when the test fails at 2am. Apply **one behavior per test** honestly: that's one logical outcome, which may legitimately take 2-4 assertions to pin down (status AND message AND side effect); splitting one behavior across five single-assert tests is cargo cult, but a test needing a sixth unrelated assertion is two tests wearing one name. Structure as Arrange-Act-Assert with the arrange kept minimal via factories, and prefer real collaborators over doubles — reach for a mock only at genuinely awkward seams (clock, network, randomness). Know what NOT to unit-test: glue code with no branches, framework configuration, simple delegation, and anything where the unit test would just restate the implementation in mock form — those belong to integration tests or to nothing. Heuristic: if a unit needs more than ~3 test doubles to instantiate, stop writing the test and fix the design — the test is reporting a coupling problem, not lacking mocks. Rule: **A unit test may only fail for one of two reasons — the behavior it names broke, or the behavior it names changed on purpose; any other failure means the test is wrong.**

BAD: "Assert the service calls `cache.get` then `db.query` then `cache.set` in order" (any caching refactor fails the test while behavior is identical; the test documents plumbing, not promises). GOOD: "Assert a second call with the same key returns the same value without a second DB hit — the observable contract — using a fake in-memory cache."

```
UNIT TEST DESIGN
════════════════
UNIT: [class/function] · public interface only
BEHAVIORS: [given X → Y] ×n · name=spec sentence
ASSERT: outcome + side effects · interaction-verification=last resort
DOUBLES: [clock/network/random only] · >3 needed → redesign the unit
NOT UNIT-TESTED: [glue, config, delegation] → covered by [integration/none]
```

Skip when: the logic is I/O-dominated with trivial branching — one integration test beats five mock-heavy unit tests; or code is exploratory and will be rewritten this week.

Gotchas: 100% line coverage with interaction-only assertions is the most dangerous suite state — everything is "covered" and nothing is verified; testing private methods by reflection or export-for-test freezes internals — test them through the public path or extract a real class; copy-pasting the implementation's expected value from the code under test ("snapshot by hand") makes the test tautological; over-DRY test helpers that hide the arrange step force readers to chase three files to learn what's actually being tested — some duplication in tests is a feature.
