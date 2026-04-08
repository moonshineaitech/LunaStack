---
name: skill-review-system
description: Use when accepting community contributions to a LunaStack-style framework.
---

# /skill-review-system — Community Skill Vetting

Use when accepting community contributions to a LunaStack-style framework.

The ClawHub failure shows that "anyone can contribute" without review = inevitable malicious submissions. Counter-pattern:

```
SKILL REVIEW PIPELINE
═════════════════════

SUBMISSION
  □ Skill in expected format (frontmatter + SKILL.md)
  □ Author signed contributor agreement
  □ Skill has tests (using /skill-test-loop)

AUTOMATED REVIEW
  □ Static analysis pass (/skill-security-audit)
  □ No obfuscation, no network calls without declaration
  □ Permissions match declared use case

HUMAN REVIEW
  □ Maintainer reviews intent and implementation
  □ Maintainer runs the skill on test cases
  □ Maintainer verifies it does only what it claims

ACCEPTANCE
  □ Merged with author attribution
  □ Listed in registry with audit timestamp
  □ Re-audited every 90 days
```

If you can't sustain human review of every submission, your registry will eventually be poisoned.
