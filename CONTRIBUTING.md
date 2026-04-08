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

[Persona paragraph: who the agent becomes when this protocol activates.
 Include who the agent is NOT — anti-persona prevents mode confusion.]

## Procedure
[Step-by-step, numbered or headed sections]

## Output
[Exact format the protocol produces, with example]

## Anti-Patterns
[Common mistakes when using this protocol — with explanations]
```

## Rules for Writing Protocols

1. **Description is discovery.** The frontmatter description is all the agent reads when scanning for relevant protocols. It must answer: what does this do? When should it activate? Keep it under 100 words.

2. **Persona + Anti-Persona.** Every protocol starts with who the agent IS and who it IS NOT. This prevents behavioral bleeding between protocols.

3. **Concrete output format.** Every protocol defines its exact output structure with a real example. The agent should never have to guess what "done" looks like.

4. **Anti-patterns are mandatory.** List 3-5 common mistakes with explanations. Anti-patterns teach the agent what NOT to do, which is often more important than what to do.

5. **Escape hatches.** Include when NOT to use this protocol. No protocol is universal.

6. **Progressive disclosure.** If the protocol has reference material (checklists, templates), put it in the procedure section — not in the frontmatter. Only load what's needed when it's needed.

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

- Protocol files: `kebab-case.md` (e.g., `dependency-review.md`)
- Protocol commands: `/kebab-case` (e.g., `/dependency-review`)
- Discipline SKILL.md: The main entry point for each discipline. Contains the primary protocol for that discipline.
- Additional protocols: Separate files in the discipline directory.

## Testing Your Protocol

1. Install LunaStack in a test project
2. Invoke your protocol with a realistic scenario
3. Check: Does the output match the documented format?
4. Check: Does the agent stay in persona throughout?
5. Check: Does the agent correctly identify when NOT to use the protocol?
6. Check: Is the token cost reasonable? (Measure with `/lunastack-status`)

## Pull Request Process

1. Create your protocol file in the correct discipline directory
2. Update `SKILL.md` (root) to include your protocol in the discipline table
3. Test with at least one realistic scenario
4. Submit PR with: protocol file, updated SKILL.md, and a brief description of what problem the protocol solves
