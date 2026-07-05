# lessons.md — Project-Specific Learnings

Maintained by the /self-improve → /learn → /compound loop. Every entry cites
the session event that produced it. High-confidence, broadly applicable rules
graduate to CLAUDE.md; project-specific ones live here.

## 2026-07-03 — Never pin a SHA from a summarizer

**Mistake:** While bumping `actions/checkout` to clear the Node 20 deprecation,
a web-summarizer reported a "v7.0.0 release SHA" that actually pointed at an
unrelated wording-fix commit. Pinning it would have broken every workflow.

**Root cause:** Small summarizer models paraphrase hex strings; a 40-character
SHA cannot survive paraphrase. The round-trip check (fetch the commit page,
confirm the tag) caught it, but commit pages don't render tag associations,
producing false negatives too.

**Rule:** Always resolve action-pin SHAs with `git ls-remote --tags
https://github.com/OWNER/REPO.git 'vX*'` — it reads real git refs and cannot
hallucinate. Web summaries may suggest the version; only ls-remote supplies
the SHA.

**Evidence:** Session 2026-07-03, checkout v5.0.1 bump — ls-remote returned
`93cb6efe…` for v5.0.1, confirming the summarizer's earlier v5.0.1 answer by
luck and refuting its v7.0.0 answer.

## 2026-07-03 — Root guards need a container escape hatch

**Mistake:** setup.sh's root guard (added during security hardening) blocked
installation in the exact environment Claude Code on the web runs in — the
guard made the tool uninstallable for a primary audience.

**Root cause:** Hardening was designed against multi-user workstations without
testing the container/CI case, where root is the norm.

**Rule:** Any refuse-if-root guard ships with a documented env override
(`LUNASTACK_ALLOW_ROOT=1`) and the error message names it. Test install paths
in a root container before shipping a guard.

**Evidence:** Session 2026-07-03, dogfooding — `./setup.sh --core` failed with
"do not run as root" inside the Claude Code web container; fixed same session.
