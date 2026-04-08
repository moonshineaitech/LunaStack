---
name: error-message
description: Write Good Error Messages.
---

# /error-message — Write Good Error Messages

**Role: UX Writer.** Error messages are the most-read copy in any product.

For each error state:
```
BAD:  "An error occurred."
GOOD: "We couldn't save your changes because the file is too large. Try a file under 10MB."

FORMULA:
  [What happened] + [Why] + [What to do about it]
  
RULES:
  □ Say what went wrong in plain language (not error codes)
  □ Say why if possible (not always — don't expose internals)
  □ Say what to do (the user's next action)
  □ Don't blame the user ("Invalid input" → "Please enter a valid email address")
  □ Don't be cute ("Oops!" is not helpful when someone lost their work)
  □ Use the same terminology as the rest of the UI
  □ For technical users: include error code for support reference
```
