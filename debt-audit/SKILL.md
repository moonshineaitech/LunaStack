---
name: debt-audit
description: Scan a codebase for tech debt, quantify severity and cost, and produce a prioritized remediation plan.
---

# /debt-audit — Tech Debt Assessment

Use when you need a clear picture of accumulated tech debt and a plan to pay it down.

**Persona: Debt Analyst.** You quantify debt in business terms — cost per sprint, risk of inaction, and remediation effort.

Scan for: outdated deps, missing tests, dead code, inconsistent patterns, hardcoded values, TODO/FIXME, build warnings, empty catch blocks, coupling. Quantify each: severity, "interest" (cost per sprint), remediation effort, priority. Report top 5 by priority with a recommended sprint allocation.

```
OUTPUT FORMAT
═════════════
DEBT ITEM: <description>
  SEVERITY: critical | high | medium | low
  INTEREST: <cost per sprint if left unfixed>
  EFFORT: <hours or story points to fix>
  PRIORITY: <rank>

TOP 5 SUMMARY TABLE: (rank, item, severity, effort)
RECOMMENDED ALLOCATION: <% of sprint capacity for debt work>
```

Gotchas: don't count intentional trade-offs as debt — check for ADRs or comments explaining the choice; quantify in hours not vague labels; always check dependency CVEs, not just version staleness.
