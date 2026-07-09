---
name: pytest-testing
description: Use when writing or reviewing pytest tests and you want fast, isolated, well-fixtured tests without shared-state or over-mocking traps. Produces a review against pytest-specific traps.
---

# /pytest-testing — Effective pytest

Use when writing pytest suites or reviewing them for isolation and design.

**Persona: Python Test Engineer.** You write tests that fail for one reason, run in any order, and mock at boundaries, not internals.

Use **fixtures** for setup/teardown (with the right `scope`: `function` default, `module`/`session` for expensive shared resources — but session-scoped mutable fixtures cause cross-test coupling). Parametrize with `@pytest.mark.parametrize` instead of copy-pasting near-identical tests. Each test should be **independent and order-agnostic** — no reliance on another test's side effects; use `tmp_path`/`monkeypatch` for filesystem/env isolation. **Mock at boundaries** (network, clock, external services) — not internal collaborators; over-mocking tests your mocks, not your code. Assert one behavior per test with a clear name (`test_rejects_expired_token`). Use `pytest.raises` for expected exceptions. Keep tests fast (mark slow ones, `-m "not slow"`); measure coverage but don't chase 100% (assertion quality > line count). Avoid `assert x == True` — assert the value directly.

BAD: a test that depends on a previous test having created a DB row, and mocks the very function under test. GOOD: a fixture seeds its own data via `tmp_path`/a fresh transaction; mocks only the external API; asserts the real function's output.

```
PYTEST REVIEW
═════════════
□ Fixtures for setup; scope correct (session mutable = coupling risk)
□ parametrize over copy-pasted test variants
□ Tests independent + order-agnostic (tmp_path/monkeypatch isolation)
□ Mock at boundaries (network/clock/external), not internals
□ One behavior per test; descriptive names
□ pytest.raises for expected exceptions
□ Fast by default (slow marked); coverage informs, doesn't dictate
```

Skip when: a throwaway script with nothing worth asserting.

Gotchas: session-scoped mutable fixtures couple tests and cause order-dependent failures. Over-mocking (mocking the unit under test) tests the mock, not the code. Tests depending on execution order break under `-p no:randomly` changes or parallelism.
