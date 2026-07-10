---
name: git-advanced-workflows
description: Use when a team needs a git history policy, a regression hunt via bisect, parallel work via worktrees, or recovery after a botched rebase/reset. Produces an explicit rebase-vs-merge policy, a bisect run plan, and a reflog-based recovery procedure instead of ad-hoc git flailing.
---

# /git-advanced-workflows — History as a Debugging Tool, Not a Diary

Use to set rebase/merge policy, run disciplined bisects, work in parallel with worktrees, and recover from git disasters via reflog.

**Persona: Git Surgeon.** Treats history as an engineered artifact optimized for future debugging. Writes explicit policy, scripts bisects, and recovers lost work calmly from reflog. Does NOT rewrite shared branches, force-push over teammates, or "fix" a mess by re-cloning and hand-copying files.

The policy that scales: **rebase locally, merge publicly**. Feature branches get `git rebase -i` (or `--autosquash` with `commit --fixup`) into a clean sequence of atomic, buildable commits before review; the default branch takes them via **squash-merge** if the branch is one logical change, or a `--no-ff` merge if each commit stands alone. Never rebase anything another human or agent has pulled — after a PR has review comments, push follow-up commits and squash at merge time so line comments survive. Enforce `git push --force-with-lease --force-if-includes` (never bare `--force`) via alias; bare force-push has zero legitimate uses on shared branches. History hygiene pays off exactly once: when `git bisect` finds your regression. Make bisect mechanical, not interactive — write a test script that exits 0/non-0 (exit 125 to skip unbuildable commits) and run `git bisect run ./repro.sh`; if the range exceeds ~1000 commits that's still only ~10 automated steps, so never eyeball-bisect what a script can. For parallel work — reviewing a PR while mid-feature, or running multiple coding agents — use `git worktree add ../repo-fix hotfix` instead of stash-juggling; worktrees share one object store, so they're near-free, but never check out the same branch in two worktrees. Disasters: almost nothing is lost for ~90 days. `git reflog` shows every HEAD move; recover a botched rebase with `git reset --hard HEAD@{n}` at the pre-rebase entry, resurrect a deleted branch with `git branch rescued <sha>`, and find orphaned commits with `git fsck --lost-found`. Rule: **Rebase only commits that exist on your machine alone; once pushed and pulled by anyone, history is append-only.**

BAD: "The rebase went wrong, so I deleted the clone and re-copied my changed files from a backup folder" (loses committed work that reflog held, and reintroduces whatever conflict caused the mess). GOOD: "`git reflog`, find `rebase (start)`, `git reset --hard HEAD@{7}`, redo the rebase one conflict at a time."

```
GIT WORKFLOW POLICY
═══════════════════
Integration: [squash-merge | no-ff merge] · Rebase allowed: [local/unshared only]
Force push: --force-with-lease --force-if-includes · Protected: [main, release/*]
Bisect: good=[tag/sha] bad=[sha] · script=[./repro.sh] (exit 0 pass / 1 fail / 125 skip)
Worktrees: [../repo-<task>] · one branch per worktree
Recovery: reflog entry=[HEAD@{n}] · action=[reset --hard | branch rescued <sha>]
```

Skip when: solo throwaway repo where history will never be debugged, or the team already has a written, enforced branch policy — follow it instead of relitigating.

Gotchas: squash-merging a stacked-PR chain breaks every child branch — rebase the stack with `--update-refs` or use tools like Graphite; `git bisect` lies when the bug is flaky, so make repro.sh run the failing test ~5 times before declaring good; reflog is per-clone and expires (~90 days default), so it cannot recover work from a deleted machine — push WIP branches; stash is where diffs go to die, prefer WIP commits you can rebase away.
