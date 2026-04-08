---
name: dependency
description: Package Evaluation.
---

# /dependency — Package Evaluation

Before adding ANY dependency, evaluate:
- Purpose: what it does, why we can't write it ourselves in <100 lines
- Health: last publish, open issues, contributors, downloads
- Security: known CVEs, transitive deps count, permissions needed
- Impact: bundle size (gzipped), tree-shakeable?
- Verdict: APPROVE / CAUTION / REJECT / BUILD INSTEAD

```
DEPENDENCY REVIEW: [package-name@version]
═════════════════════════════════════════

PURPOSE
  What it does:        [1 sentence]
  Why we need it:      [what problem it solves]
  Build instead?       [could we write this in <100 lines? If yes, BUILD]

HEALTH
  Last published:      [date — stale if >6 months]
  Weekly downloads:    [N]
  Open issues/PRs:     [N/N — ratio of issues to activity]
  Contributors:        [N — bus factor if <3]
  License:             [MIT/Apache/GPL — GPL is viral, careful]

SECURITY
  Known CVEs:          [list or "none"]
  Transitive deps:     [count — each one is attack surface]
  Permissions needed:  [network? filesystem? native code?]

IMPACT
  Bundle size (gzip):  [KB — is it tree-shakeable?]
  Load time impact:    [estimated ms at p50 connection]

VERDICT: [APPROVE / CAUTION (with conditions) / REJECT (with reason) / BUILD INSTEAD]
```
