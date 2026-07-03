#!/usr/bin/env bash
# tests/context_cost.sh — Tier 1: Discovery context-tax audit
#
# Skill discovery loads every installed skill's frontmatter description into
# the agent's context before any work starts. This test measures that tax,
# enforces the 100-word description cap, and validates the core pack.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PACKS_DIR="$REPO_DIR/distribution/packs"
bold='\033[1m'; red='\033[0;31m'; green='\033[0;32m'; yellow='\033[0;33m'; dim='\033[2m'; reset='\033[0m'
errors=0

echo -e "\n${bold}LunaStack Discovery Context-Tax Audit${reset}\n"

desc_words() {
  sed -n '2,/^---$/p' "$1" | sed -n 's/^description: *//p' | wc -w
}

# --- Per-skill: enforce 100-word description cap, accumulate totals ---
total_words=0
count=0
heaviest=""
for skill in "$REPO_DIR"/*/SKILL.md; do
  name="$(basename "$(dirname "$skill")")"
  w=$(desc_words "$skill")
  total_words=$((total_words + w))
  count=$((count + 1))
  if [ "$w" -gt 100 ]; then
    printf "${red}FAIL${reset} /%s: description is %d words (max 100)\n" "$name" "$w"
    errors=$((errors + 1))
  fi
  heaviest+="$w /$name"$'\n'
done

# --- Packs: every entry in every pack must exist; compute per-pack cost ---
pack_report=""
if [ -d "$PACKS_DIR" ] && ls "$PACKS_DIR"/*.txt >/dev/null 2>&1; then
  for pack in "$PACKS_DIR"/*.txt; do
    pname="$(basename "$pack" .txt)"
    p_words=0
    p_count=0
    while IFS= read -r line; do
      line="${line%%#*}"; line="$(echo "$line" | tr -d ' \t')"
      [ -z "$line" ] && continue
      if [ ! -f "$REPO_DIR/$line/SKILL.md" ]; then
        printf "${red}FAIL${reset} pack '%s' lists /%s but no such skill exists\n" "$pname" "$line"
        errors=$((errors + 1))
        continue
      fi
      w=$(desc_words "$REPO_DIR/$line/SKILL.md")
      p_words=$((p_words + w))
      p_count=$((p_count + 1))
    done < "$pack"
    pack_report+="$(printf "  Pack %-8s %3d skills, %5d words ≈ %5d tokens" "$pname:" "$p_count" "$p_words" "$((p_words * 4 / 3))")"$'\n'
  done
else
  printf "${red}FAIL${reset} distribution/packs/ is missing or empty\n"
  errors=$((errors + 1))
fi

# Core pack is the recommended default — it must exist
if [ ! -f "$PACKS_DIR/core.txt" ]; then
  printf "${red}FAIL${reset} distribution/packs/core.txt is missing (setup.sh default)\n"
  errors=$((errors + 1))
fi

# Tokens ≈ words × 4/3 (typical English tokenization)
full_tokens=$((total_words * 4 / 3))

echo -e "${dim}Heaviest 8 descriptions:${reset}"
printf '%s' "$heaviest" | sort -rn | head -8 | awk '{printf "  %3d words  %s\n", $1, $2}'
echo ""
echo -e "${bold}Discovery cost${reset}"
printf "  Full install (--global): %3d skills, %5d words ≈ %5d tokens\n" "$count" "$total_words" "$full_tokens"
printf '%s' "$pack_report"
echo ""

if [ "$errors" -gt 0 ]; then
  echo -e "${red}${bold}FAILED${reset} — $errors context-cost issues"
  exit 1
else
  echo -e "${green}${bold}PASSED${reset} — all descriptions within budget, core pack valid"
fi
