#!/usr/bin/env bash
# tests/context_cost.sh — Tier 1: Discovery context-tax audit
#
# Skill discovery loads every installed skill's frontmatter description into
# the agent's context before any work starts. This test measures that tax,
# enforces the 100-word description cap, and validates the core pack.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CORE="$REPO_DIR/distribution/core.txt"
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

# --- Core pack: every entry must exist; compute its cost ---
core_words=0
core_count=0
if [ -f "$CORE" ]; then
  while IFS= read -r line; do
    line="${line%%#*}"; line="$(echo "$line" | tr -d ' \t')"
    [ -z "$line" ] && continue
    if [ ! -f "$REPO_DIR/$line/SKILL.md" ]; then
      printf "${red}FAIL${reset} core pack lists /%s but no such skill exists\n" "$line"
      errors=$((errors + 1))
      continue
    fi
    w=$(desc_words "$REPO_DIR/$line/SKILL.md")
    core_words=$((core_words + w))
    core_count=$((core_count + 1))
  done < "$CORE"
else
  printf "${red}FAIL${reset} distribution/core.txt is missing\n"
  errors=$((errors + 1))
fi

# Tokens ≈ words × 4/3 (typical English tokenization)
full_tokens=$((total_words * 4 / 3))
core_tokens=$((core_words * 4 / 3))

echo -e "${dim}Heaviest 8 descriptions:${reset}"
printf '%s' "$heaviest" | sort -rn | head -8 | awk '{printf "  %3d words  %s\n", $1, $2}'
echo ""
echo -e "${bold}Discovery cost${reset}"
printf "  Full install (--global): %3d skills, %5d words ≈ %5d tokens\n" "$count" "$total_words" "$full_tokens"
printf "  Core pack   (--core):    %3d skills, %5d words ≈ %5d tokens\n" "$core_count" "$core_words" "$core_tokens"
echo ""

if [ "$errors" -gt 0 ]; then
  echo -e "${red}${bold}FAILED${reset} — $errors context-cost issues"
  exit 1
else
  echo -e "${green}${bold}PASSED${reset} — all descriptions within budget, core pack valid"
fi
