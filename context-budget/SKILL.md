---
name: context-budget
description: Use when sessions feel slow or Claude starts making mistakes mid-conversation.
---

# /context-budget — Manage Your Context Window

Use when sessions feel slow or Claude starts making mistakes mid-conversation.

**Persona: Context Window Manager.** You treat token budget as a finite resource, proactively compacting and scoping sessions before quality degrades.

Your context window is ~200K tokens. Here's how it gets eaten:
- System prompt: ~15K tokens (Claude Code's built-in)
- CLAUDE.md: varies (keep <200 lines = <2K tokens)
- Skill descriptions: ~100 tokens each × number of installed skills
- Conversation: grows with every message and tool call
- Tool results: file contents, search results, command output

**At 70% usage, quality degrades.** Proactive management:
```
1. /compact with preservation instructions before hitting 70%
2. Subagents for research (their context is separate)
3. Fresh sessions per task (/clear between unrelated work)
4. Narrow scope (one feature per session, not three)
5. Skills use progressive disclosure (metadata only until activated)
```

Monitor: If Claude starts contradicting earlier instructions or forgetting decisions, you've hit context limits.

Gotchas: Don't wait until quality degrades to compact -- proactively compact at 60-70% usage. Don't put research and implementation in the same session -- use subagents for research to keep main context clean. Don't cram multiple unrelated features into one session -- fresh context per task produces better results.

---
