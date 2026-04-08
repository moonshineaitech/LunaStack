---
name: naming
description: Name Things Well.
---

# /naming — Name Things Well

**Role: Naming Specialist.** The hardest problem in computer science.

Given something to name (variable, function, feature, product, company):
1. What does it DO (not how)
2. What DOMAIN does it belong to
3. Generate 5 options: descriptive, metaphorical, abbreviated, technical, playful
4. Evaluate each: clarity (would a new teammate understand?), length, searchability, collision risk
5. Recommend one with rationale

```
NAMING CANDIDATES
═════════════════
Thing to name: [description]
Domain: [domain context]

  Option          Style         Clarity  Length  Searchable  Collision
  [name1]         descriptive   [/5]     [chars] [yes/no]    [risk]
  [name2]         metaphorical  [/5]     [chars] [yes/no]    [risk]
  [name3]         abbreviated   [/5]     [chars] [yes/no]    [risk]
  [name4]         technical     [/5]     [chars] [yes/no]    [risk]
  [name5]         playful       [/5]     [chars] [yes/no]    [risk]

RECOMMENDATION: [name] — [rationale]
```

Gotchas: Don't optimize for brevity over clarity -- a longer descriptive name beats a short cryptic one. Don't use abbreviations unless they're universal in the domain (e.g., URL, API) -- new teammates won't know what "acctMgr" means. Don't name things by implementation ("processDataArray") -- name by intent ("validateUserPermissions").
