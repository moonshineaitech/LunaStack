#!/usr/bin/env bash
# Validates the wiki/skills/ library — same behavior-grade bar as core skills.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)/wiki/skills"
red='\033[0;31m'; green='\033[0;32m'; yellow='\033[0;33m'; bold='\033[1m'; reset='\033[0m'
err=0; n=0; hatch=0; ex=0; rule=0; out=0
[ -d "$ROOT" ] || { echo "no wiki/skills yet"; exit 0; }
while IFS= read -r f; do
  n=$((n+1)); name="$(basename "$f" .md)"
  head -1 "$f" | grep -q '^---$' || { printf "${red}FAIL${reset} %s: no frontmatter\n" "$name"; err=$((err+1)); continue; }
  fm=$(sed -n '2,/^---$/p' "$f")
  echo "$fm" | grep -q '^name:' || { printf "${red}FAIL${reset} %s: no name\n" "$name"; err=$((err+1)); }
  echo "$fm" | grep -q '^description:' || { printf "${red}FAIL${reset} %s: no description\n" "$name"; err=$((err+1)); }
  fn=$(echo "$fm" | sed -n 's/^name: *//p'); [ "$fn" = "$name" ] || { printf "${red}FAIL${reset} %s: name!=file (%s)\n" "$name" "$fn"; err=$((err+1)); }
  grep -qi 'Skip when' "$f" && hatch=$((hatch+1)) || { printf "${yellow}WARN${reset} %s: no escape hatch\n" "$name"; }
  grep -qi 'BAD' "$f" && grep -qi 'GOOD' "$f" && ex=$((ex+1)) || { printf "${yellow}WARN${reset} %s: no BAD/GOOD\n" "$name"; }
  grep -qiE 'Persona:|Role:' "$f" || { printf "${red}FAIL${reset} %s: no persona\n" "$name"; err=$((err+1)); }
  grep -q '```\|═══' "$f" && out=$((out+1)) || { printf "${red}FAIL${reset} %s: no output block\n" "$name"; err=$((err+1)); }
  grep -qiE 'Gotchas:|Rules:' "$f" || { printf "${red}FAIL${reset} %s: no gotchas\n" "$name"; err=$((err+1)); }
  wc=$(echo "$fm" | sed -n 's/^description: *//p' | wc -w); [ "$wc" -le 100 ] || { printf "${red}FAIL${reset} %s: desc %sw>100\n" "$name" "$wc"; err=$((err+1)); }
done < <(find "$ROOT" -name '*.md' ! -name 'INDEX.md' ! -name 'README.md')
echo ""
printf "${bold}wiki/skills: %d skills | escape-hatch %d | BAD/GOOD %d | output %d${reset}\n" "$n" "$hatch" "$ex" "$out"
if [ "$err" -gt 0 ]; then printf "${red}${bold}FAILED — %d errors${reset}\n" "$err"; exit 1; else printf "${green}${bold}PASSED${reset}\n"; fi
