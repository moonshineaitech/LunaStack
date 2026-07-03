#!/usr/bin/env bash
set -euo pipefail

# Security: refuse to run as root
[[ ${EUID:-$(id -u)} -eq 0 ]] && { echo "Error: do not run as root."; exit 1; }

LUNA_DIR="$(cd "$(dirname "$0")" && pwd)"
G='\033[0;32m'; D='\033[2m'; B='\033[1m'; R='\033[0m'
echo -e "\n${B}  ◑  LunaStack${R}\n${D}     249 protocols · 27 disciplines · 55 roles${R}\n"
MODE="${1:---core}"
FILTER=""
case "$MODE" in
  --core)    SD="$HOME/.claude/skills"; FILTER="$LUNA_DIR/distribution/core.txt"
             echo -e "${D}     Core pack: 25 highest-leverage skills (~2.5K discovery tokens)${R}"
             echo -e "${D}     Want everything? ./setup.sh --global installs all 249${R}" ;;
  --global)  SD="$HOME/.claude/skills"
             echo -e "${D}     Full install: all 249 skills (~25K discovery tokens)${R}" ;;
  --project) SD=".claude/skills" ;;
  --team)    SD="$HOME/.claude/skills"; echo -e "${D}     Team mode: SessionStart hook will auto-update${R}" ;;
  *) echo "Usage: ./setup.sh [--core | --global | --project | --team]"
     echo "  --core     25 highest-leverage skills (default, recommended)"
     echo "  --global   all 249 skills"
     echo "  --project  all skills, into ./.claude/skills of the current project"
     echo "  --team     all skills + auto-update hook"
     exit 1 ;;
esac

# Load core-pack allowlist if filtering
declare -A CORE=()
if [ -n "$FILTER" ]; then
  [ -f "$FILTER" ] || { echo "Error: missing $FILTER"; exit 1; }
  while IFS= read -r line; do
    line="${line%%#*}"; line="$(echo "$line" | tr -d ' \t')"
    [ -n "$line" ] && CORE["$line"]=1
  done < "$FILTER"
fi

mkdir -p "$SD"; c=0
for d in "$LUNA_DIR"/*/; do
  n="$(basename "$d")"
  # Security: only allow safe directory names (lowercase alphanumeric + hyphens)
  [[ "$n" =~ ^[a-z0-9][a-z0-9-]*$ ]] || continue
  [ -f "$d/SKILL.md" ] || continue
  if [ -n "$FILTER" ] && [ -z "${CORE[$n]:-}" ]; then continue; fi
  t="$SD/$n"
  [ -L "$t" ] && rm "$t"
  [ -d "$t" ] && continue
  ln -s "$d" "$t"
  c=$((c+1))
done
echo -e "${G}  ✓ $c skills installed${R}"
echo -e "${D}  Try: claude \"/luna\"${R}\n"
