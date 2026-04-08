#!/usr/bin/env bash
# tests/validate_integrity.sh — Tier 1: Cross-reference integrity
# Checks that LunaStack.md, README, setup.sh, and SKILL.md dirs are consistent.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
errors=0
bold='\033[1m'; red='\033[0;31m'; green='\033[0;32m'; dim='\033[2m'; reset='\033[0m'

fail() { printf "${red}FAIL${reset} %s\n" "$1"; errors=$((errors + 1)); }

echo -e "\n${bold}LunaStack Integrity Checks${reset}\n"

# --- Check 1: Every skill dir is referenced in LunaStack.md ---
echo -e "${dim}1. Checking all skills referenced in LunaStack.md...${reset}"
for skill in "$REPO_DIR"/*/SKILL.md; do
  name="$(basename "$(dirname "$skill")")"
  if ! grep -q "/$name" "$REPO_DIR/LunaStack.md"; then
    fail "/$name exists as skill dir but not referenced in LunaStack.md"
  fi
done

# --- Check 2: Every command in LunaStack.md index has a skill dir ---
echo -e "${dim}2. Checking LunaStack.md command index matches dirs...${reset}"
# Extract commands from the Available commands line
commands=$(sed -n 's/.*Available commands: //p' "$REPO_DIR/LunaStack.md" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | sed 's|^/||')
for cmd in $commands; do
  if [ ! -d "$REPO_DIR/$cmd" ]; then
    fail "/$cmd listed in LunaStack.md index but no directory exists"
  fi
done

# --- Check 3: setup.sh can find all skills ---
echo -e "${dim}3. Checking setup.sh compatibility...${reset}"
setup_count=0
for d in "$REPO_DIR"/*/; do
  n="$(basename "$d")"
  [[ "$n" =~ ^[a-z0-9][a-z0-9-]*$ ]] || continue
  [ -f "$d/SKILL.md" ] || continue
  setup_count=$((setup_count + 1))
done
dir_count=$(ls -d "$REPO_DIR"/*/SKILL.md 2>/dev/null | wc -l)
if [ "$setup_count" -ne "$dir_count" ]; then
  fail "setup.sh would install $setup_count skills but $dir_count exist ($(( dir_count - setup_count )) have unsafe names)"
fi

# --- Check 4: No duplicate skill names ---
echo -e "${dim}4. Checking for duplicate frontmatter names...${reset}"
dupes=$(for f in "$REPO_DIR"/*/SKILL.md; do sed -n 's/^name: *//p' "$f"; done | sort | uniq -d)
if [ -n "$dupes" ]; then
  fail "Duplicate frontmatter names found: $dupes"
fi

# --- Check 5: AGENTS.md completeness (if it exists) ---
if [ -f "$REPO_DIR/AGENTS.md" ]; then
  echo -e "${dim}5. Checking AGENTS.md completeness...${reset}"
  for skill in "$REPO_DIR"/*/SKILL.md; do
    name="$(basename "$(dirname "$skill")")"
    if ! grep -q "/$name" "$REPO_DIR/AGENTS.md"; then
      fail "/$name not listed in AGENTS.md"
    fi
  done
else
  echo -e "${dim}5. AGENTS.md not found, skipping...${reset}"
fi

# --- Report ---
echo ""
if [ "$errors" -gt 0 ]; then
  echo -e "${red}${bold}FAILED${reset} — $errors integrity issues found"
  exit 1
else
  echo -e "${green}${bold}PASSED${reset} — all integrity checks passed"
  exit 0
fi
