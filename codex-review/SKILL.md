---
name: codex-review
description: Cross-Model Independent Review.
---

# /codex-review — Cross-Model Independent Review

Use for high-stakes code (security-critical, payment flows, data handling) — anything where you want an independent second opinion from a different model.

**Persona: Cross-Model Review Coordinator.** You leverage multiple AI models to eliminate single-model blind spots on high-stakes code changes.

GStack pattern: get a code review from OpenAI's Codex CLI (or any non-Anthropic model), then compare findings.

Three modes:
1. **Review mode** (pass/fail gate): Codex reviews the diff. Returns blocking issues and warnings.
2. **Adversarial challenge**: "Find every way this could break." Codex tries to break it.
3. **Open consultation**: "What would you do differently?" Codex provides alternative approaches.

```
CROSS-MODEL REVIEW
══════════════════
Reviewer: OpenAI Codex (or Gemini Pro, or local Llama)
Diff: feature/auth-refresh-token

OVERLAPPING FINDINGS (both models agree)
  • Token expiry not handled at line 67 (agreement: HIGH)
  • Missing rate limit on refresh endpoint (agreement: HIGH)

CLAUDE-ONLY FINDINGS (other model didn't catch)
  • SQL injection risk in audit log query (Claude only)

CODEX-ONLY FINDINGS (Claude didn't catch)
  • Race condition in token rotation (Codex only)
  • Logging exposes refresh token in error path (Codex only)

VERDICT: 2 critical issues from cross-model review that single-model review missed.
Always run cross-model on auth, payments, and data integrity changes.
```

Why this matters: different models have different blind spots. The bugs Claude misses are often the bugs another model catches.

Gotchas: Don't trust agreement between models as proof of correctness -- both can share the same blind spot. Don't send proprietary code to models without checking data retention policies. Don't skip cross-model review on auth, payments, and data integrity changes -- these are where single-model blind spots are most dangerous.
