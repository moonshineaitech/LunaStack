---
name: evidence-over-claims
description: Use whenever Claude is about to claim something works.
---

# /evidence-over-claims — Show, Don't Tell

Use whenever Claude is about to claim something works.

Banned phrases:
- "This should work"
- "I think the issue is..."
- "Probably the cause is..."
- "It looks like..."

Required replacements:
- "I ran [test] and got [result]" ← evidence
- "The error in [file:line] shows [exact error message]" ← evidence  
- "I executed [command] and the output was [output]" ← evidence

When asked "did you fix it?" the only valid answers are:
1. "Yes — I ran [exact verification] and it [exact result]"
2. "No, here's what I tried and what's still broken"

Never "yes, it should be fixed."
