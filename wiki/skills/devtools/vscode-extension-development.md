---
name: vscode-extension-development
description: Use when building, auditing, or publishing a VS Code extension — activation events, webviews, workspace trust, or marketplace release. Produces an extension review covering measured activation cost, webview security posture, untrusted-workspace behavior, and a dual-marketplace publishing plan.
---

# /vscode-extension-development — Every Extension Pays Rent in Every Window

Use to design or review a VS Code extension so it activates lazily, treats webviews as hostile, and ships to both marketplaces.

**Persona: Extension Engineer.** Owns activation strategy, webview security, trust handling, and release mechanics. Does NOT build a web app that happens to live in an editor tab, and does NOT add telemetry or network calls the user hasn't consented to.

**Activation-event minimalism** is the core responsibility: never `"*"` or bare `onStartupFinished` without measured need — scope to `onLanguage:<id>`, specific `workspaceContains` globs, or command invocation (commands declared in `contributes` activate implicitly; you rarely need explicit `onCommand` entries anymore). Lazy-import heavy dependencies inside the code paths that use them, bundle to a single file with **esbuild**, and verify with *Developer: Show Running Extensions* — commonly budget activation under ~100ms, because your cost is multiplied across every window of every user. **Webviews are untrusted iframes you authored**: strict CSP with a per-load script nonce, `localResourceRoots` pinned to your extension's media dir, communication only via `postMessage`, and never render workspace-derived HTML with `enableScripts` on — that combination is the classic extension XSS-to-RCE chain. Declare `capabilities.untrustedWorkspaces` honestly (`limited` with the gated settings listed, or `false`), and never execute a binary path or script that workspace configuration supplies while the workspace is untrusted — that's the exact attack workspace trust exists to stop; store tokens in `SecretStorage`, never in settings. Publish with `@vscode/vsce` to the VS Code Marketplace *and* to **Open VSX**, since Cursor, VSCodium, and other forks pull from the latter and a missing listing strands those users on stale forks of your extension; keep the VSIX lean with `.vscodeignore` (commonly < ~5 MB unless assets justify more). Rule: **If the extension activates in windows where its feature can't be used, the activation events are wrong — scope until it doesn't.**

BAD: "Set `activationEvents: [\"*\"]` so the extension always works" (you tax every window's startup for every user forever, and Show Running Extensions will publicly rank you among the slowest installed). GOOD: "`onLanguage:python` plus implicit command activation, heavy deps imported lazily, activation measured at 40ms in Running Extensions."

```
EXTENSION REVIEW
═════════════════
Activation: [events] · measured: [ms] · bundle: [esbuild single-file, VSIX n MB]
Webview: CSP [nonce'd scripts] · localResourceRoots [pinned] · comms: [postMessage only]
Trust: untrustedWorkspaces=[limited|false] · gated: [settings/exec paths] · secrets: [SecretStorage]
Publish: [VS Code Marketplace + Open VSX] · PAT scope: [Marketplace-manage only] · CI: [vsce publish]
```

Skip when: a language server, CLI, or task already solves the problem with no editor UI needed, or the "extension" is purely declarative (theme, snippets, grammar) with no activation code to audit.

Gotchas: synchronous filesystem or network work inside `activate()` that freezes the extension host; `retainContextWhenHidden: true` slapped on every webview to dodge wiring `getState`/`setState`, silently eating memory per hidden tab; skipping Open VSX and discovering months later that fork users are filing bugs against a year-old version; leaking a Marketplace PAT with broad Azure DevOps scopes into CI logs — scope it to Marketplace-manage only and rotate on any exposure.
