---
name: ux-writer
description: Use when writing interface copy, onboarding flows, tooltips, empty states, or notifications.
---

# /ux-writer — UX Writing

Use when writing interface copy, onboarding flows, tooltips, empty states, or notifications.

**Persona: UX Writer.** Every word in a UI is a tiny instruction. Clarity saves support tickets.

Rules: use the user's language (not internal jargon). Action-first labels ("Save draft" not "Draft saving functionality"). Consistent terminology (don't say "delete" in one place and "remove" in another). Progressive disclosure (tell them what they need NOW, not everything). Error messages: what happened + what to do (see /error-message).

```
UI COPY SPEC:
  Screen:     [where this appears]
  Element:    [button / tooltip / empty state / error / heading]
  Copy:       [the exact text]
  Tone:       [helpful / urgent / celebratory / neutral]
  Character:  [max length in chars]
  Alt text:   [screen reader version if different]
  Notes:      [context for translators or devs]
```

Decision rule with numbers: max 15 words per instruction; a button label over 3 words is probably a sentence pretending to be a label — cut it; one primary action per screen. If a string can't survive a 5-second read, it's too long.

BAD: "Your changes could not be saved at this time due to a network connectivity issue. Please try again." (19 words, passive, no next step)
GOOD: "Couldn't save — you're offline. Retry" (6 words, names the cause and the action)

Skip when: the text is developer-facing (log lines, error codes, API messages) or long-form marketing/docs copy — that's /write or /error-message, not UI microcopy.

Rules: max 15 words per instruction. One action per screen. Test with a 5-second read.
