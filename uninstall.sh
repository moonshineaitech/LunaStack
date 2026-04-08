#!/usr/bin/env bash
set -euo pipefail

# Security: refuse to run as root
[[ ${EUID:-$(id -u)} -eq 0 ]] && { echo "Error: do not run as root."; exit 1; }

LUNA_DIR="$(cd "$(dirname "$0")" && pwd)"
SD="${1:-$HOME/.claude/skills}"

# Security: validate target path contains .claude/skills
case "$SD" in
  */.claude/skills|*/.claude/skills/) ;;
  *) echo "Error: target path must end with .claude/skills (got: $SD)"; echo "Use --force as second arg to override."; [[ "${2:-}" == "--force" ]] || exit 1 ;;
esac

c=0
for d in "$LUNA_DIR"/*/; do
  n="$(basename "$d")"
  [[ "$n" =~ ^[a-z0-9][a-z0-9-]*$ ]] || continue
  [ -f "$d/SKILL.md" ] || continue
  t="$SD/$n"
  [ -L "$t" ] && rm "$t" && c=$((c+1))
done
echo "Removed $c symlinks from $SD."
