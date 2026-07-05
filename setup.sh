#!/usr/bin/env bash
set -euo pipefail

# Security: refuse to run as root on multi-user systems.
# Containers and CI legitimately run as root (Claude Code on the web does) —
# set LUNASTACK_ALLOW_ROOT=1 to override in those environments.
if [[ ${EUID:-$(id -u)} -eq 0 && "${LUNASTACK_ALLOW_ROOT:-}" != "1" ]]; then
  echo "Error: refusing to run as root. In a container/CI, set LUNASTACK_ALLOW_ROOT=1."
  exit 1
fi

LUNA_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKS_DIR="$LUNA_DIR/distribution/packs"
G='\033[0;32m'; D='\033[2m'; B='\033[1m'; R='\033[0m'

usage() {
  echo "Usage: ./setup.sh [--core | --pack NAME | --global | --project | --team | --list-packs]"
  echo "  --core        25 highest-leverage skills (default, recommended)"
  echo "  --pack NAME   a curated pack (see --list-packs)"
  echo "  --global      all 249 skills"
  echo "  --project     all skills, into ./.claude/skills of the current project"
  echo "  --team        all skills + auto-update hook"
  echo "  --list-packs  show available packs"
  exit "${1:-1}"
}

list_packs() {
  echo -e "${B}Available packs${R} (combine by running setup.sh once per pack):\n"
  for p in "$PACKS_DIR"/*.txt; do
    name="$(basename "$p" .txt)"
    count=$(grep -cv '^\s*#\|^\s*$' "$p" || true)
    desc=$(head -1 "$p" | sed 's/^# *//')
    printf "  ${G}%-10s${R} %2d skills  ${D}%s${R}\n" "$name" "$count" "$desc"
  done
  exit 0
}

echo -e "\n${B}  ◑  LunaStack${R}\n${D}     249 protocols · 27 disciplines · 55 roles${R}\n"
MODE="${1:---core}"
FILTER=""
SD="$HOME/.claude/skills"
case "$MODE" in
  --core)      FILTER="$PACKS_DIR/core.txt"
               echo -e "${D}     Core pack: 25 highest-leverage skills. More: ./setup.sh --list-packs${R}" ;;
  --pack)      PACK="${2:-}"
               [ -n "$PACK" ] || usage
               [[ "$PACK" =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "Error: invalid pack name"; exit 1; }
               FILTER="$PACKS_DIR/$PACK.txt"
               [ -f "$FILTER" ] || { echo "Error: no pack named '$PACK'."; list_packs; }
               echo -e "${D}     Pack: $PACK${R}" ;;
  --global)    echo -e "${D}     Full install: all 249 skills${R}" ;;
  --project)   SD=".claude/skills" ;;
  --team)      echo -e "${D}     Team mode: SessionStart hook will auto-update${R}" ;;
  --list-packs) list_packs ;;
  --help|-h)   usage 0 ;;
  *)           usage ;;
esac

# Load pack allowlist if filtering
declare -A PICK=()
if [ -n "$FILTER" ]; then
  while IFS= read -r line; do
    line="${line%%#*}"; line="$(echo "$line" | tr -d ' \t')"
    [ -n "$line" ] && PICK["$line"]=1
  done < "$FILTER"
fi

mkdir -p "$SD"; c=0
for d in "$LUNA_DIR"/*/; do
  n="$(basename "$d")"
  # Security: only allow safe directory names (lowercase alphanumeric + hyphens)
  [[ "$n" =~ ^[a-z0-9][a-z0-9-]*$ ]] || continue
  [ -f "$d/SKILL.md" ] || continue
  if [ -n "$FILTER" ] && [ -z "${PICK[$n]:-}" ]; then continue; fi
  t="$SD/$n"
  [ -L "$t" ] && rm "$t"
  [ -d "$t" ] && continue
  ln -s "$d" "$t"
  c=$((c+1))
done
echo -e "${G}  ✓ $c skills installed${R}"
echo -e "${D}  Try: claude \"/luna\"${R}\n"
