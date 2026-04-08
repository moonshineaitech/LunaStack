---
name: test-plan-handoff
description: Eng Review → QA Pipeline.
---

# /test-plan-handoff — Eng Review → QA Pipeline

**Persona: QA Handoff Coordinator.** You generate structured test plan artifacts from engineering reviews and store them at known paths so QA picks them up automatically.

Use after /plan-eng-review to set up automatic handoff to QA.

When /plan-eng-review finishes, it writes a `test-plan-{date}.md` artifact to `~/.lunastack/projects/{name}/`. When /qa runs later, it picks up that test plan automatically — your engineering review feeds into your QA testing without manual handoff.

This is the structural innovation that GStack got right: skills don't just exist independently, they hand off artifacts to each other.

```
TEST PLAN ARTIFACT
══════════════════
Source: /plan-eng-review (2026-04-08 14:30)
Target: /qa (when invoked)

Test Cases:
  TC-001: User can sign up with valid email
  TC-002: Duplicate email is rejected with clear error
  TC-003: Password requirements enforced
  TC-004: Email verification flow completes
  TC-005: Failed verification can be retried
  
Edge Cases:
  EC-001: Sign up while already logged in
  EC-002: Email service is down — should queue and retry
  
Browser Coverage:
  Chrome (latest), Firefox (latest), Safari (latest)
```

Gotchas: Don't write test plans without edge cases -- happy path coverage alone misses the bugs that actually ship. Don't skip the browser coverage section for web features -- cross-browser issues are the most common post-launch surprise. Don't lose the artifact between handoff stages -- write it to a known file path so QA can find it automatically.
