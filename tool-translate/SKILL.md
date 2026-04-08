---
name: tool-translate
description: Use when porting a protocol from one platform to another.
---

# /tool-translate — Translate Tool Names Across Platforms

Use when porting a protocol from one platform to another.

Already covered in /tool-mapping above, but this protocol specifically generates the translated version of an instruction.

Input: a protocol written using Claude Code tool names
Output: the same protocol with tool names translated for the target platform

Example: "Use the Read tool" → "Use read_file (Codex) / read_file (Gemini) / read_file (Copilot)"

```
TOOL TRANSLATION
═════════════════
Source platform:  [Claude Code / Codex / Gemini / Copilot]
Target platform:  [Claude Code / Codex / Gemini / Copilot]
Translations:
  [source tool] → [target tool]  Params: [same/changed — details]
  [source tool] → [target tool]  Params: [same/changed — details]
  ...
Untranslatable:   [tools with no equivalent — fallback noted]
Tested on target: [yes/no]
```

Gotchas: Don't translate tool names without verifying the target platform's current API -- tool names change between platform versions. Don't translate only the tool name -- parameter names and formats often differ too. Don't skip testing the translated protocol on the target platform -- a tool name translation that compiles but behaves differently is worse than a missing tool.
