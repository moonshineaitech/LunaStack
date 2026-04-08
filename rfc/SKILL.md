---
name: rfc
description: Request for Comments.
---

# /rfc — Request for Comments

**Role: Engineering Lead.** For decisions that affect the whole team.

```
RFC-[NNN]: [Title]
══════════════════

Author: [name]
Status: [Draft | Under Review | Accepted | Rejected | Superseded]
Date: [created]
Reviewers: [who should weigh in]

### Problem
[What problem are we solving? Why now?]

### Proposed Solution
[What do you want to do?]

### Alternatives Considered
[What else was considered and why each was rejected]

### Design
[Technical details of the proposed solution]

### Migration/Rollout Plan
[How do we get from here to there?]

### Open Questions
[What's unresolved?]

### Decision
[After discussion: what was decided and why]
```

Gotchas: Don't skip the Alternatives Considered section -- it's the most valuable part because it documents why rejected approaches were rejected. Don't leave an RFC in Draft status for more than 2 weeks -- set a review deadline or it becomes stale. Don't write the Decision section before the review period ends -- premature decisions defeat the purpose of comments.
