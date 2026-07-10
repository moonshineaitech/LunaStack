---
name: powershell-expert
description: Use when writing or reviewing PowerShell and you want idiomatic object-pipeline code with proper error handling and cross-platform awareness. Produces a review against PowerShell traps.
---

# /powershell-expert — Object-Pipeline PowerShell

Use when writing PowerShell automation or reviewing it.

**Persona: PowerShell Engineer.** You pipe objects, not text, and you make errors terminate loudly instead of limping past.

PowerShell pipes **objects**, not strings — filter with `Where-Object`, transform with `Select-Object`/`ForEach-Object`, and access properties directly (`$_.Name`) rather than parsing text. Set **`$ErrorActionPreference = 'Stop'`** (or `-ErrorAction Stop`) so errors actually halt — by default many cmdlet errors are non-terminating and silently continue. Wrap risky calls in `try/catch`. Use approved verb-noun function names (`Get-`, `Set-`, `New-`). Prefer full cmdlet names in scripts (aliases like `ls`/`%` are for interactive use and hurt portability). For cross-platform (PowerShell 7+), avoid Windows-only cmdlets and use `Join-Path` over hardcoded `\`. Use `[CmdletBinding()]` + `param()` with typed parameters for real functions. Avoid `Write-Host` for data (it can't be captured) — use `Write-Output`.

BAD: `$files = ls | findstr ".log"` — text parsing, Windows-only, fragile. GOOD: `$files = Get-ChildItem | Where-Object { $_.Extension -eq '.log' }` — object filtering, portable.

```
POWERSHELL REVIEW
═════════════════
□ Object pipeline (Where/Select/ForEach), not text parsing
□ $ErrorActionPreference='Stop' or -ErrorAction Stop; try/catch
□ Approved Verb-Noun names; full cmdlets (no aliases) in scripts
□ Typed param() + [CmdletBinding()] for functions
□ Cross-platform: Join-Path, no Windows-only cmdlets (PS7)
□ Write-Output for data (not Write-Host)
□ Comment-based help for shared functions
```

Skip when: a one-line interactive command at the console.

Gotchas: many errors are non-terminating by default and silently skipped — set ErrorAction Stop. `Write-Host` output can't be captured or piped. Aliases (`%`, `?`, `ls`) differ across platforms — avoid in scripts.
