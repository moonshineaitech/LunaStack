---
name: lessons-md
description: Maintain a Living Lessons File.
---

# /lessons-md — Maintain a Living Lessons File

Use alongside CLAUDE.md for project-specific learnings that aren't universal enough for CLAUDE.md.

Boris's team maintains `tasks/lessons.md` — a file Claude reads that contains:
- Past mistakes and the rules that prevent them
- Project-specific patterns discovered during development
- Edge cases that caused bugs

**Every time Claude makes a mistake → correct it → have Claude write a prevention rule → add to lessons.md.**

The file grows over time and makes each session smarter. Unlike CLAUDE.md (which should stay <200 lines and universal), lessons.md can be longer and more specific.
