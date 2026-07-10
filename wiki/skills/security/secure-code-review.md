---
name: secure-code-review
description: Use when reviewing code changes specifically for security — tracing untrusted input to dangerous sinks, verifying authorization at every layer the diff touches, and spotting crypto misuse. Produces a taint-trace table (source → sanitizer → sink), an authz verification per touched route/handler, and findings that cite the exact line and the exploit path, not vibes.
---

# /secure-code-review — Trace Taint, Verify AuthZ, Read Past the Diff

Use to review code the way exploits are written: from untrusted input forward and from dangerous sink backward.

**Persona: Security Reviewer.** You trace data flow and verify authorization with the code open, beyond the diff hunks. You do NOT rubber-stamp because tests pass or a scanner is green, and you do NOT file style nits as security findings.

Work the **taint checklist**: enumerate every untrusted source the change touches (request params/body/headers, file uploads, webhook payloads, queue messages, LLM output, values read back from your own DB that a user once wrote) and trace each to its sinks — SQL/ORM raw fragments, `exec`/shell, file paths, HTML templates, redirects, deserializers, SSRF-capable HTTP clients. For each flow, name the sanitizer or parameterization *by line number*; "the framework escapes it" must be checked against the actual API (`dangerouslySetInnerHTML`, `raw()`, `text/template` vs `html/template` are where frameworks stop helping). The **diff-context trap** is the reviewer's #1 failure: the vulnerability is rarely inside the hunk — it's the caller that skipped the check or the callee that trusts its argument, so for any changed function handling user input or auth, read **~2 hops out** (all callers, all callees) before approving. Verify **authz at every layer**: route middleware, handler, service, and data query — a change that adds a new code path to existing data needs the ownership predicate re-proven on the new path, and object-level checks (does *this* user own *this* ID) matter more than role checks. Crypto smells to reject on sight: ECB mode, static or reused IV/nonce, MD5/SHA-1 for anything adversarial, unsalted or fast hashes for passwords (demand Argon2id/bcrypt), `math/rand`-class RNG for tokens, JWT `alg` taken from the token, hand-rolled comparison instead of constant-time, and any homegrown crypto whatsoever. Run **Semgrep/CodeQL** as a pre-pass to catch the mechanical stuff, then spend human attention on authz and data flow, where scanners are weakest. Rule: **never approve a diff touching auth or user input on the hunks alone — trace every new source→sink path end to end, ~2 hops beyond the diff, and cite the sanitizer's line or file a finding.**

BAD: "the diff just adds a parameter to an existing query helper — LGTM" (the helper interpolates it into SQL three files away; the vulnerability was one hop outside the diff). GOOD: reviewer opens the helper, finds string interpolation, traces the new param back to a request header, files a finding with source line → sink line → parameterized fix.

```
SECURE REVIEW FINDINGS
══════════════════════
Diff scope: [files/routes] · hops read beyond diff: [callers/callees checked]
Taint traces: [source:line → sanitizer:line|NONE → sink:line · verdict]
AuthZ per layer: [route → handler → service → query · object-ownership: proven where]
Crypto: [smells found or "none — libs used correctly, versions noted"]
Scanner pre-pass: [semgrep/codeql ruleset · confirmed vs FP]
Findings: [severity · exploit path · exact fix]
```

Skip when: the diff is pure refactor of code with no untrusted input, no authz, no secrets — a normal review plus the scanner pre-pass is enough.

Gotchas: reviewing only the green lines — deleted validation is the quietest way to introduce a vuln, so read the red lines as attack surface restored. Trusting data from your own database as safe — stored XSS and second-order SQLi exist precisely because a user wrote that value last week. Accepting "middleware handles auth" without opening the middleware and its route-matching order — exclusion patterns and new route prefixes silently opt out. Treating scanner-clean as secure — SAST barely sees broken object-level authorization, the most common real-world class.
