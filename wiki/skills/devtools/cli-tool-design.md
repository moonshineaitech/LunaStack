---
name: cli-tool-design
description: Use when designing or reviewing a command-line tool's interface — flags, subcommands, output, exit codes, or distribution. Produces a CLI interface spec covering human vs machine output modes, TTY-aware behavior, error UX, and an install story, aligned with current conventions (clig.dev-style).
---

# /cli-tool-design — Interfaces Humans Script and Scripts Trust

Use to design a CLI's surface: flags, subcommands, exit codes, JSON output, progress behavior, and distribution.

**Persona: CLI Product Designer.** Treats the terminal as a UI with two users — a human at a TTY and a script in a pipe — and designs for both explicitly. Specifies interface contracts before implementation. Does NOT invent novel flag conventions, print decorations to stdout, or break published flags without a deprecation cycle.

Structure follows the **noun-verb** pattern once you have more than ~3 operations (`tool db migrate`, like `gh pr create`); below that, plain flags beat premature subcommands. Honor the conventions users' fingers already know: `-h/--help` everywhere, `--version`, `-v` for verbose, `-q`, `-o/--output`, `--dry-run` for anything destructive, and `-` meaning stdin. The load-bearing contract is the stream split: **stdout is the product, stderr is the commentary** — logs, progress, and warnings go to stderr so `tool | jq` never chokes. Detect TTY (`isatty`) and adapt: colors and spinners on a TTY, plain lines when piped, and respect `NO_COLOR` and `--no-color`. Every tool that outputs data needs `--json` emitting a stable, documented schema (NDJSON for streams); treat that schema as a public API with the same compatibility bar as your flags. Exit codes are the API scripts actually check: 0 success, 1 generic failure, 2 usage error, and document anything domain-specific (avoid codes >125 — shells reserve them). Errors should name the problem, the likely cause, and the next command to try, in that order. For anything slower than ~1 second, show progress on stderr; for anything destructive, require confirmation on a TTY and `--yes` to bypass in scripts. Distribution: ship static single binaries (Go, Rust, or Zig-built) per platform, publish to Homebrew + a shell installer + GitHub Releases with checksums and Sigstore/cosign signatures, and build in a self-update check that is opt-out and never blocks execution. Rule: **stdout carries only the machine-parseable product; everything a human reads while waiting goes to stderr.**

BAD: "Print a fancy banner, progress bar, and the JSON result all to stdout" (any pipe into `jq` or a script gets ANSI garbage and breaks; users then screen-scrape). GOOD: "Result JSON to stdout under a versioned `--json` schema; spinner and log lines to stderr, auto-disabled when stdout isn't a TTY."

```
CLI INTERFACE SPEC
═══════════════════
Command: [tool] · Model: [flags-only | noun-verb subcommands]
Flags: [--json · --output · --dry-run · --yes · --no-color · -q/-v]
Streams: stdout=[data/schema vX] · stderr=[logs, progress] · TTY: [color/spinner on, plain when piped]
Exit codes: 0=[ok] · 1=[failure] · 2=[usage] · [n]=[domain-specific]
Errors: [what happened → probable cause → suggested next command]
Distribution: [brew · curl installer · GH release + checksums/sigstore] · Update: [opt-out check, non-blocking]
```

Skip when: writing a one-off internal script with a single known caller, or wrapping an existing CLI whose conventions you must mirror rather than redesign.

Gotchas: interactive prompts that fire in CI hang pipelines — gate every prompt on `isatty` and provide a flag equivalent; changing human-readable output breaks the users who screen-scraped because you shipped `--json` too late; a `--json` mode that still lets library log lines leak to stdout is worse than none; phoning home for updates or telemetry without a documented opt-out gets you uninstalled and named on the front page of Hacker News.
