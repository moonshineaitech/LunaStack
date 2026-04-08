#!/usr/bin/env bash
set -euo pipefail
LUNA_DIR="$(cd "$(dirname "$0")" && pwd)"
G='\033[0;32m'; D='\033[2m'; B='\033[1m'; R='\033[0m'
echo -e "\n${B}  ◑  LunaStack${R}\n${D}     239 protocols · 26 disciplines · 55 roles${R}\n"
MODE="${1:---global}"
case "$MODE" in
  --global)  SD="$HOME/.claude/skills" ;;
  --project) SD=".claude/skills" ;;
  --team)    SD="$HOME/.claude/skills"; echo -e "${D}     Team mode: SessionStart hook will auto-update${R}" ;;
  *) echo "Usage: ./setup.sh [--global | --project | --team]"; exit 1 ;;
esac
mkdir -p "$SD"; c=0
for d in "$LUNA_DIR"/*/; do
  n="$(basename "$d")"
  [ -f "$d/SKILL.md" ] || continue
  t="$SD/$n"
  [ -L "$t" ] && rm "$t"
  [ -d "$t" ] && continue
  ln -s "$d" "$t"
  c=$((c+1))
done
echo -e "${G}  ✓ $c skills installed${R}"
echo -e "${D}  Try: claude \"/luna\"${R}\n"
