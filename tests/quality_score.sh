#!/usr/bin/env bash
# tests/quality_score.sh — Tier 2: Quality scoring
# Scores each skill on a 0-5 rubric and produces a report.
# This is the LunaStack equivalent of GStack's LLM-as-judge evals,
# but deterministic and free (no API calls).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
bold='\033[1m'; dim='\033[2m'; green='\033[0;32m'; yellow='\033[0;33m'; red='\033[0;31m'; reset='\033[0m'

total=0; total_score=0
grade_a=0; grade_b=0; grade_c=0; grade_f=0

echo -e "\n${bold}LunaStack Quality Scores${reset}\n"
echo "| Skill | Score | Frontmatter | Persona | Output | Gotchas | Length |"
echo "|---|---|---|---|---|---|---|"

for skill in "$REPO_DIR"/*/SKILL.md; do
  name="$(basename "$(dirname "$skill")")"
  [[ "$name" == tests ]] && continue
  score=0
  total=$((total + 1))

  # Criterion 1: Valid frontmatter with name + description (1 point)
  fm=""
  if head -1 "$skill" | grep -q '^---$'; then
    fm_block=$(sed -n '2,/^---$/p' "$skill")
    if echo "$fm_block" | grep -q '^name:' && echo "$fm_block" | grep -q '^description:'; then
      fm="Y"; score=$((score + 1))
    else fm="~"; fi
  else fm="N"; fi

  # Criterion 2: Has persona/role line (1 point)
  persona="N"
  if grep -qi 'Persona:\|Role:' "$skill"; then
    persona="Y"; score=$((score + 1))
  fi

  # Criterion 3: Has output format code block (1 point)
  output="N"
  if grep -q '```\|═══' "$skill"; then
    output="Y"; score=$((score + 1))
  fi

  # Criterion 4: Has gotchas or rules (1 point)
  gotchas="N"
  if grep -qi 'Gotchas:\|Rules:' "$skill"; then
    gotchas="Y"; score=$((score + 1))
  fi

  # Criterion 5: Adequate length — 15-100 lines (1 point)
  lines=$(wc -l < "$skill")
  length="N"
  if [ "$lines" -ge 15 ] && [ "$lines" -le 100 ]; then
    length="Y"; score=$((score + 1))
  elif [ "$lines" -ge 10 ]; then
    length="~"
  fi

  total_score=$((total_score + score))

  # Grade
  if [ "$score" -ge 5 ]; then grade_a=$((grade_a + 1));
  elif [ "$score" -ge 4 ]; then grade_b=$((grade_b + 1));
  elif [ "$score" -ge 3 ]; then grade_c=$((grade_c + 1));
  else grade_f=$((grade_f + 1)); fi

  # Only print non-perfect scores
  if [ "$score" -lt 5 ]; then
    echo "| /$name | $score/5 | $fm | $persona | $output | $gotchas | $length |"
  fi
done

avg=$(echo "scale=1; $total_score * 100 / ($total * 5)" | bc)

echo ""
echo -e "${bold}Summary${reset}"
echo -e "  Total skills:  $total"
echo -e "  Average score: ${avg}%"
echo -e "  ${green}Grade A (5/5):${reset}  $grade_a"
echo -e "  Grade B (4/5):  $grade_b"
echo -e "  ${yellow}Grade C (3/5):${reset}  $grade_c"
echo -e "  ${red}Grade F (<3/5):${reset} $grade_f"
echo ""

# Fail if average is below 70%
threshold=70
if [ "$(echo "$avg < $threshold" | bc)" -eq 1 ]; then
  echo -e "${red}${bold}BELOW THRESHOLD${reset} — average ${avg}% is below ${threshold}%"
  exit 1
else
  echo -e "${green}${bold}ABOVE THRESHOLD${reset} — average ${avg}% meets ${threshold}% target"
  exit 0
fi
