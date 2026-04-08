#!/usr/bin/env bash
set -euo pipefail
LUNA_DIR="$(cd "$(dirname "$0")" && pwd)"
SD="${1:-$HOME/.claude/skills}"
c=0
for d in "$LUNA_DIR"/*/; do
  n="$(basename "$d")"
  [ -f "$d/SKILL.md" ] || continue
  t="$SD/$n"
  [ -L "$t" ] && rm "$t" && c=$((c+1))
done
echo "Removed $c symlinks."
