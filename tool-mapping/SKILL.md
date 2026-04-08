---
name: tool-mapping
description: Use when running protocols across different harnesses (Claude Code, Codex, Gemini, Copilot, Cursor).
---

# /tool-mapping — Cross-Platform Tool Translation

Use when running protocols across different harnesses (Claude Code, Codex, Gemini, Copilot, Cursor).

Tool name equivalents:
```
Claude Code     →  Codex          →  Gemini CLI       →  Copilot CLI
══════════════════════════════════════════════════════════════════════
Read            →  read_file      →  read_file        →  read_file
Write           →  write_file     →  write_file       →  write_file
Edit            →  apply_patch    →  replace          →  edit_file
Bash            →  shell          →  run_shell        →  run_shell
Skill           →  (n/a)          →  activate_skill   →  skill
Task (subagent) →  spawn_agent    →  (n/a)            →  (n/a)
TodoWrite       →  task_list      →  (n/a)            →  (n/a)
Grep            →  search         →  search_text      →  grep
Glob            →  find_files     →  glob             →  glob
```

When porting: don't use the Read tool on skill files in any platform. Use the platform's native skill loading mechanism.
