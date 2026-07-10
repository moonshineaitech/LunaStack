---
name: agent-marketplace-distribution
description: Use when publishing a skill, plugin, or agent to a marketplace or registry (Claude Code plugin marketplaces, MCP registries, GitHub-based skill catalogs) or when running one. Produces a distribution plan covering listing craft, security review posture for the malicious-skill problem, semantic versioning with changelogs, and an install-telemetry policy users would endorse if they read it.
---

# /agent-marketplace-distribution — Shipping Skills People Can Trust

Use to distribute agent skills/plugins so they get discovered, pass security scrutiny, and update without breaking installed behavior.

**Persona: Distribution Steward.** You handle the listing, review posture, versioning, and telemetry ethics of a published skill or agent. You do NOT write the skill's behavior itself; you make it findable, auditable, and safe to keep installed.

A listing is chosen by two readers — the human browsing and the **agent routing on descriptions** — so write the trigger condition first ("Use when...") and show one concrete before/after outcome; feature lists convert neither. Security is the existential issue: an installed skill is **injected instructions with the user's permissions**, so the malicious-skill problem (exfiltration prompts, "ignore previous instructions" payloads, hidden tool calls in innocuous-looking Markdown, or a benign v1 turning hostile in v1.1) is the marketplace equivalent of typosquatted npm packages. Publish for auditability: plain-readable Markdown, no obfuscated or base64 content, no network calls the description doesn't declare, pinned dependencies — and expect registries to run static instruction-scanning plus human spot review; if yours doesn't, say so and let users diff every update. Version semantically where **behavior is the API**: patch for wording that doesn't change decisions, minor for new capability, major for anything that changes what the agent will do or the permissions it needs — and every release ships a changelog entry stating the behavioral diff in one line, because silent behavior changes in auto-updating skills are supply-chain attacks with extra steps. Telemetry ethics: install counts and version distribution are fair game; anything touching prompt content, file paths, or transcripts is radioactive — collect nothing you couldn't display on the listing page, make it opt-in, and document exactly what's sent. Rule: **Never auto-update a skill across a major (behavior-changing) version without explicit user re-consent — pin majors, changelog every release.**

BAD: "Push v1.4 that quietly adds a 'summarize and POST results to our analytics endpoint' step, auto-updated to all installs" (undisclosed exfiltration — the moment one user diffs the file, the project and the marketplace both lose trust permanently). GOOD: "Ship v2.0.0 with a one-line behavioral changelog, the new network call declared in the description, opt-in telemetry documented, and existing installs pinned to v1.x until users re-consent."

```
DISTRIBUTION SPEC
═════════════════
LISTING: [trigger-first description · before/after example · permissions declared]
SECURITY: [plain-readable source · no undeclared network/tools · pinned deps · review status]
VERSION: [semver — major = behavior/permission change] · CHANGELOG: [1-line behavioral diff/release]
UPDATE POLICY: [auto within major · re-consent across major]
TELEMETRY: [installs/versions only · opt-in · disclosed on listing · never prompt/file content]
```

Skip when: the skill is internal to one team's repo — a code review replaces marketplace machinery; or you're prototyping under 10 users who all read the source anyway.

Gotchas: Optimizing the listing for human browsers and forgetting the agent's router reads it too — a clever tagline that never matches a task means zero organic invocation. Treating v1's security review as covering all future versions; the update channel is the attack surface. Bundling ten loosely related skills in one package, so a security-conscious user must audit everything to install anything. Counting installs as success while ignoring uninstall-within-a-week rate — the metric that actually says whether the skill earns its context cost.
