---
name: dependency-upgrade-strategy
description: Use when dependencies are months stale, a security advisory just landed, or upgrade PRs pile up unmerged. Establishes an update cadence (security same-week), Renovate-class automation with auto-merge tiers, major-version quarantine, and lockfile hygiene. Produces a dependency update policy.
---

# /dependency-upgrade-strategy — Small Steps, Never Behind

Use to keep dependencies continuously current through automated, tiered updates — so upgrades stay boring and security patches ship the week they land, not during a panicked audit.

**Persona: Dependency Steward.** You set the update cadence, automation rules, and merge tiers for third-party code. You do NOT chase every 0.0.1 release by hand or vendor-fork libraries to dodge upgrades — you make staying current the cheap default.

The core insight: upgrade pain is superlinear in staleness — ten patch bumps merged weekly cost minutes each, while the same delta after 18 months is a migration project — so the strategy is **cadence, not heroics**. Run **Renovate** (or Dependabot, but Renovate's grouping/scheduling is stronger) with tiered rules: patch and minor updates of well-tested deps **auto-merge on green CI** (this is safe exactly in proportion to your test suite — no meaningful coverage, no auto-merge); group noisy ecosystems (all `@types/*`, monorepo-published families) into single PRs; schedule non-urgent updates weekly to cap churn. **Security advisories are a different lane**: patch-level fixes for reachable vulnerabilities ship **same-week, commonly within 72h for critical CVSS** — use `osv-scanner`/`npm audit`/`pip-audit` in CI plus reachability analysis to skip false alarms in code paths you never call. **Major versions get quarantine**: never auto-merged; a human reads the changelog/migration guide, upgrades in a dedicated PR with no other changes, and waits — let a new major bake in the wild ~2-4 weeks before adopting unless it carries a security fix, which also dodges supply-chain attacks that ride hijacked releases (pin exact versions + lockfile, enable provenance/signature checks like npm provenance or `cargo vet`, and consider a cooldown rule in Renovate). **Lockfile hygiene**: the lockfile is the build — commit it always, forbid `latest`/floating ranges resolving at install time in CI (use `npm ci`/frozen-lockfile), and treat any CI install that mutates the lockfile as a failure. Rule: **Patch/minor auto-merge on green CI weekly; security fixes same-week (~72h for critical); majors quarantined behind a human review and a ~2-4 week bake period.**

BAD: "We'll upgrade everything during the annual platform week" (18 months of drift means transitive conflicts, abandoned migration guides, and a CVE you couldn't patch because the fix only exists on a major you never took). GOOD: "Renovate auto-merged 14 patch bumps this week on green CI; the React 20 major sits in a quarantine PR with the migration guide summarized, merging after its 3-week bake."

```
DEPENDENCY UPDATE POLICY
════════════════════════
Automation:  [Renovate|Dependabot] · schedule: [weekly] · groups: [@types/*, ecosystem families]
Auto-merge:  patch+minor on green CI · prerequisite: [test coverage adequate? y/n]
Security:    scanner: [osv-scanner/audit] · SLA: critical ~72h · reachability check: [tool]
Majors:      quarantine PR · changelog reviewed by: [owner] · bake: [~2-4 wks] · one major per PR
Supply chain: exact pins + lockfile · frozen install in CI · provenance/cooldown: [config]
Stale list:  deps >1 major behind: [list, each with owner + plan or written waiver]
```

Skip when: a frozen or end-of-life system with no network exposure — pin everything and change nothing. Internal-only tools with trivial blast radius can run monthly instead of weekly.

Gotchas: auto-merge without real test coverage just automates breakage into main. Upgrading a major together with feature changes makes the inevitable bisect useless — one major per PR, nothing else in it. Deleting and regenerating the lockfile to "fix" a conflict silently upgrades everything at once. Zero-day adoption of fresh releases is a supply-chain exposure — the ~2-4 week cooldown would have skipped most hijacked-package incidents; security patches are the one exception.
