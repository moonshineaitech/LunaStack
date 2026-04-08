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
