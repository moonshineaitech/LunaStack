---
name: context-budget
description: Use when sessions feel slow or Claude starts making mistakes mid-conversation.
---

# /context-budget — Manage Your Context Window

Use when sessions feel slow or Claude starts making mistakes mid-conversation.

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

---
