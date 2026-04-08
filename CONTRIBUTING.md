# Contributing to LunaStack

## Protocol Structure

Every protocol is a Markdown file with YAML frontmatter:

```yaml
---
name: protocol-name
description: One paragraph. What it does + when it activates. This is what the agent reads during discovery (~100 tokens). Make it count.
---
```

Followed by the protocol body:

```markdown
# /protocol-name — Human-Readable Title

[When to use: one line describing the trigger condition.]

**Persona: [Role Name].** [Who the agent becomes. Include priorities and what the agent is NOT.]

[Procedure as inline prose or numbered steps. Include output format as a code block if applicable.]

Gotchas: [Common mistakes and edge cases, inline.]
```

## Actual Convention

LunaStack uses a **flat prose format** — not headed sections. Here's a real example (`/inquiry`):

```markdown
---
name: inquiry
description: Use when the user has a vague idea but hasn't defined the problem clearly yet.
---

# /inquiry — Problem Discovery

**Role: Product Strategist.** You understand problems before solving them.

Ask four questions, one at a time. Wait for each answer.

**Q1: Problem** — "What problem are we solving, and who specifically has this problem?"
**Q2: Alternative** — "What do they do today instead? Why do they tolerate it?"
**Q3: Switch** — "What would make someone switch?"
**Q4: Evidence** — "What evidence do we have? What would prove us wrong?"

Then produce:
\```
INQUIRY BRIEF
═════════════
Problem:         [1 sentence]
User:            [specific person]
...
\```

Gotchas: Don't accept vague answers. Don't solution during discovery.
```

## Rules for Writing Protocols

1. **Description is discovery.** The frontmatter description is all the agent reads when scanning for relevant protocols. It must answer: what does this do? When should it activate? Keep it under 100 words.

2. **Persona is required.** Start with a bold **Persona** line stating who the agent IS. This prevents behavioral bleeding between protocols.

3. **Concrete output format.** Include at least one code block showing the exact output structure. The agent should never have to guess what "done" looks like.

4. **Gotchas line.** End with a `Gotchas:` line listing common mistakes. Brief and inline — not a headed section.

5. **Self-contained.** Each SKILL.md contains ONLY that skill's content. No content from other protocols, sections, or the monolithic LunaStack.md.

6. **Progressive disclosure.** Keep skills concise. Reference material (checklists, templates) goes in the procedure body, not in the frontmatter.

## Discipline Assignment

Protocols belong to the discipline that matches their cognitive mode:

| If it's about... | It belongs in... |
|---|---|
| Understanding the problem | `inquiry/` |
| Designing the system | `architecture/` |
| Defining what to build | `specification/` |
| Writing and fixing code | `construction/` |
| Proving quality | `verification/` |
| Design and UX quality | `craft/` |
| Releasing to production | `delivery/` |
| Learning and memory | `memory/` |
| Managing the system itself | `meta/` |

## Naming Conventions

- Protocol files: `kebab-case` directory with `SKILL.md` inside (e.g., `dependency-review/SKILL.md`)
- Protocol commands: `/kebab-case` (e.g., `/dependency-review`)
- Directory names must match the `name:` field in frontmatter exactly

## Testing Your Protocol

1. Install LunaStack in a test project
2. Invoke your protocol with a realistic scenario
3. Check: Does the output match the documented format?
4. Check: Does the agent stay in persona throughout?
5. Check: Does the agent correctly identify when NOT to use the protocol?

## Pull Request Process

1. Create your protocol directory with `SKILL.md` in the correct discipline
2. Test with at least one realistic scenario
3. Submit PR with: protocol file, example invocation output, and a brief description of what problem the protocol solves
4. Ensure CI passes (frontmatter validation, content leakage check)
