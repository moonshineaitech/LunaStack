---
name: find-duplicates
description: Use when refactoring, or when codebase feels bloated.
---

# /find-duplicates — Semantic Code Duplication Detection

Use when refactoring, or when codebase feels bloated.

From obra/superpowers-lab: Detect SEMANTIC duplication, not syntactic. Two functions with the same INTENT but different implementations are duplicates that copy-paste detectors miss.

Two-phase approach:
1. **Phase 1 (Haiku):** Extract all functions, categorize by domain (auth, validation, formatting, etc.)
2. **Phase 2 (Opus):** Within each category, find functions with same intent but different implementations

```
DUPLICATE ANALYSIS
══════════════════
Category: User input validation
  validateUserEmail() in auth/login.ts:34
  checkEmailFormat() in registration/signup.ts:67
  isValidEmail() in utils/validators.ts:12
  
  → 3 functions, same intent, different implementations
  → Recommendation: extract to utils/validators.ts, delete the others
```
