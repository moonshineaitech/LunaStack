#!/usr/bin/env bash
# tests/validate_skills.sh — Tier 1: Static validation (free, <5s)
# Validates all 239 skills for structural correctness.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
errors=0
warnings=0
pass=0
total=0

red='\033[0;31m'; green='\033[0;32m'; yellow='\033[0;33m'; dim='\033[2m'; bold='\033[1m'; reset='\033[0m'

fail() { printf "${red}FAIL${reset} %s: %s\n" "$1" "$2"; errors=$((errors + 1)); }
warn() { printf "${yellow}WARN${reset} %s: %s\n" "$1" "$2"; warnings=$((warnings + 1)); }
ok() { pass=$((pass + 1)); }

echo -e "\n${bold}LunaStack Skill Validation — Tier 1${reset}\n"

# --- Test 1: Every skill dir has SKILL.md ---
echo -e "${dim}1. Checking SKILL.md presence...${reset}"
for dir in "$REPO_DIR"/*/; do
  [[ "$(basename "$dir")" == .* ]] && continue
  [[ "$(basename "$dir")" == tests ]] && continue
  [ -f "$dir/SKILL.md" ] || fail "$(basename "$dir")" "Missing SKILL.md"
done

# --- Test 2: Frontmatter ---
echo -e "${dim}2. Checking YAML frontmatter...${reset}"
for skill in "$REPO_DIR"/*/SKILL.md; do
  name="$(basename "$(dirname "$skill")")"
  total=$((total + 1))

  # Has opening ---
  head -1 "$skill" | grep -q '^---$' || { fail "$name" "Missing frontmatter opener"; continue; }

  # Has name field
  fm=$(sed -n '2,/^---$/p' "$skill")
  echo "$fm" | grep -q '^name:' || { fail "$name" "Missing 'name' in frontmatter"; continue; }

  # Has description field
  echo "$fm" | grep -q '^description:' || { fail "$name" "Missing 'description' in frontmatter"; continue; }

  # Name matches directory
  fm_name=$(echo "$fm" | sed -n 's/^name: *//p')
  if [ "$fm_name" != "$name" ]; then
    fail "$name" "Frontmatter name '$fm_name' doesn't match directory '$name'"
    continue
  fi

  # Description under 100 words
  desc=$(echo "$fm" | sed -n 's/^description: *//p')
  word_count=$(echo "$desc" | wc -w)
  if [ "$word_count" -gt 100 ]; then
    fail "$name" "Description is $word_count words (max 100)"
    continue
  fi

  ok
done

# --- Test 3: Content quality ---
echo -e "${dim}3. Checking content quality...${reset}"
has_output=0
has_gotchas=0
has_persona=0
for skill in "$REPO_DIR"/*/SKILL.md; do
  name="$(basename "$(dirname "$skill")")"

  # Check for output format (code block)
  if grep -q '```\|═══' "$skill"; then
    has_output=$((has_output + 1))
  else
    warn "$name" "No output format code block"
  fi

  # Check for gotchas/rules
  if grep -qi 'Gotchas:\|Rules:' "$skill"; then
    has_gotchas=$((has_gotchas + 1))
  fi

  # Check for persona
  if grep -qi 'Persona:\|Role:' "$skill"; then
    has_persona=$((has_persona + 1))
  fi

  # Content leakage check
  lines=$(wc -l < "$skill")
  if [ "$lines" -gt 200 ]; then
    fail "$name" "Suspiciously long ($lines lines) — possible content leakage"
  fi

  # Self-containment check
  if grep -q '^# [🔥🌀🏗️🔬🌐🛡️◑◍△▭⬡◇◎▸∞]' "$skill"; then
    fail "$name" "Contains discipline section header — leaked content from LunaStack.md"
  fi
done

# --- Test 4: Structural integrity ---
echo -e "${dim}4. Checking structural integrity...${reset}"
skill_count=$(ls -d "$REPO_DIR"/*/SKILL.md 2>/dev/null | wc -l)
if [ "$skill_count" -lt 230 ]; then
  fail "repo" "Expected ~239 skills, found only $skill_count"
fi

# Check for unsafe directory names
for dir in "$REPO_DIR"/*/; do
  [[ "$(basename "$dir")" == .* ]] && continue
  [[ "$(basename "$dir")" == tests ]] && continue
  dname="$(basename "$dir")"
  if ! [[ "$dname" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    fail "$dname" "Directory name contains unsafe characters"
  fi
done

# --- Report ---
echo ""
echo -e "${bold}Results${reset}"
echo -e "  Skills tested:   $total"
echo -e "  ${green}Passed:${reset}          $pass"
echo -e "  ${red}Failed:${reset}          $errors"
echo -e "  ${yellow}Warnings:${reset}        $warnings"
echo ""
echo -e "${bold}Quality Metrics${reset}"
output_pct=$((has_output * 100 / total))
gotchas_pct=$((has_gotchas * 100 / total))
persona_pct=$((has_persona * 100 / total))
echo -e "  Output format:   $has_output/$total (${output_pct}%)"
echo -e "  Gotchas/Rules:   $has_gotchas/$total (${gotchas_pct}%)"
echo -e "  Persona line:    $has_persona/$total (${persona_pct}%)"
echo ""

if [ "$errors" -gt 0 ]; then
  echo -e "${red}${bold}FAILED${reset} — $errors errors found"
  exit 1
else
  echo -e "${green}${bold}PASSED${reset} — all structural checks passed"
  exit 0
fi
