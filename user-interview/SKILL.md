---
name: user-interview
description: Use when designing user-research interview questions to validate a product, feature, or problem with real people. Produces a guide that reveals actual behavior — past-tense and specific — instead of the flattering hypotheticals people volunteer.
---

# /user-interview — User Research Questions

**Role: UX Researcher.** You design questions that reveal true behavior, not stated preferences. People lie in interviews — not maliciously, but because they describe who they wish they were, not who they are.

Given a product or feature:

Decision rule: cap the core at 5-7 questions (a guide over ~20 minutes bleeds answer quality); every core question must be past-tense and point at a specific real event. If more than 1 core question is hypothetical ("would you..."), the guide fails — rewrite before running it. Never draw conclusions from fewer than 5 interviews; patterns don't emerge from 1-2.

BAD: "Would you use an app that reminds you to water your plants?" → polite yes, predicts nothing.
GOOD: "Walk me through the last plant you let die. When did you notice? What did you do next?" → real behavior, real friction.

Skip when: you already hold behavioral data (analytics, session recordings, support tickets) that answers the question — observe what users did before asking what they'll say. Also skip for pure UI-copy or aesthetic preference calls, where a 5-minute usability test beats a scheduled interview.

**Behavioral questions (ask these):**
- "Walk me through the last time you [did the thing]. What happened step by step?"
- "What was the hardest part? Where did you get stuck?"
- "What did you do right before? Right after?"
- "How are you solving this problem today? Show me."
- "When's the last time this problem cost you real time or money?"

**Never ask:**
- "Would you use a product that...?" (hypothetical = useless)
- "How much would you pay for...?" (they'll lowball)
- "Do you like this feature?" (they'll say yes to be nice)

Output:
```
INTERVIEW GUIDE: [topic]
════════════════════════
Goal: [what we're trying to learn]
Screening: [who to talk to, who to exclude]
Questions (15-20 min):
  Opening: [warm-up, establish context]
  Core (5-7 questions): [behavioral, specific, past-tense]
  Probing: [follow-ups when they give vague answers]
  Close: [anything we didn't ask about?]
Red flags in answers: [signals they're telling you what you want to hear]
```

Gotchas: Don't ask hypothetical questions ("would you use...") -- they produce hypothetical answers that don't predict behavior. Don't ask leading questions that suggest the "right" answer -- users will agree to be polite. Don't interview fewer than 5 people -- patterns don't emerge from 1-2 conversations.
