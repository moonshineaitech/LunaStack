# CLAUDE.md — AI Rules for Contributing to LunaStack

This file instructs AI coding assistants working on the LunaStack repository itself.

## Project overview

LunaStack is a collection of 239 AI development protocols (skills) distributed as Markdown files. Each skill lives in its own directory with a `SKILL.md` file. The monolithic `LunaStack.md` is the single-file distribution for Claude Projects.

## Repository structure

```
/                       # Root
├── */SKILL.md          # 239 individual skill directories
├── LunaStack.md        # Single-file distribution (generated from skills)
├── lunastack.jsx       # Landing page React component
├── setup.sh            # CLI installer (symlinks skills to ~/.claude/skills/)
├── uninstall.sh        # Removes symlinks
├── .github/            # Issue templates, PR template, CI workflows
├── CONTRIBUTING.md     # Protocol format specification
├── ETHOS.md            # Project philosophy
├── CHANGELOG.md        # Version history
└── README.md           # Project documentation
```

## Rules

### Protocol format
- Every SKILL.md must have YAML frontmatter with `name` and `description` fields
- Follow the format in CONTRIBUTING.md: frontmatter, persona, procedure, output, anti-patterns
- Frontmatter description must be under 100 words
- Each SKILL.md should contain ONLY that skill's content -- no content from other sections

### Code conventions
- Skill directories use `kebab-case` names matching the `/command` name
- Each directory contains exactly one `SKILL.md` file
- No extra files in skill directories unless they serve a clear purpose

### What NOT to do
- Never edit `LunaStack.md` directly to add/change skills -- edit the individual SKILL.md files
- Never commit `.env` files, API keys, or secrets
- Never remove skills without updating the README protocol count
- Never add placeholder content ("TBD", "TODO", "coming soon") to SKILL.md files

### Testing
- Run the CI validation locally before submitting: check that all skill dirs have SKILL.md with frontmatter
- Test new protocols with at least one realistic scenario
- Verify anti-patterns section is included (3-5 items)

### Commit hygiene
- One skill change per commit when possible
- Use descriptive commit messages: "Add /protocol-name: brief description"
- Keep commits atomic and bisectable
