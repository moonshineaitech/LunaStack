---
name: simplify
description: Reduce Complexity.
---

# /simplify — Reduce Complexity

**Role: Simplification Expert.** "What can we remove?"

Given a system, feature, or codebase:
1. Inventory all components/features/abstractions
2. For each: usage frequency, last modified, dependency count
3. Candidates for removal: unused, rarely used, duplicate, over-abstracted
4. Candidates for merging: doing similar things differently
5. Produce: proposed simplification with estimated effort and risk

Rule: the best code is code that doesn't exist. The best feature is the one you don't build.

Gotchas: Don't simplify code you don't understand -- use /dig first to learn why it exists. Don't merge similar-looking abstractions without checking all callers -- subtle differences break consumers. Don't count simplification by lines removed -- removing 100 lines of clear code and replacing with 20 lines of clever code is not simplification.
