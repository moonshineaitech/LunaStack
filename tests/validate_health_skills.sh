#!/usr/bin/env bash
# Safety gate for wiki/skills/health/ — every health skill MUST carry a
# non-diagnostic disclaimer AND an emergency-escalation path. This is the
# health-domain equivalent of /red-team's authorization gate.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)/wiki/skills/health"
red='\033[0;31m'; green='\033[0;32m'; bold='\033[1m'; reset='\033[0m'
[ -d "$ROOT" ] || { echo "no health skills yet"; exit 0; }
err=0; n=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  n=$((n+1)); name="$(basename "$f" .md)"
  # 1. Non-diagnostic disclaimer present
  grep -qiE 'not [a-z ]{0,30}(medical (advice|direction|treatment|nutrition therapy|counsel)|a diagnosis|a clinician|a doctor|a substitute|diagnos)|educational (support|information)|(general |personal )?wellness education|not diagnos' "$f" \
    || { printf "${red}FAIL${reset} %s: no non-diagnostic disclaimer\n" "$name"; err=$((err+1)); }
  # 2. Emergency escalation present
  grep -qiE '911|988|emergency (number|department|room|services)|call your local emergency|seek emergency' "$f" \
    || { printf "${red}FAIL${reset} %s: no emergency-escalation path\n" "$name"; err=$((err+1)); }
  # 3. Defer-to-professional cue
  grep -qiE 'licensed|clinician|doctor|physician|healthcare (professional|provider)|pharmacist|professional' "$f" \
    || { printf "${red}FAIL${reset} %s: no defer-to-professional cue\n" "$name"; err=$((err+1)); }
  # 4. Must NOT claim to diagnose (forbidden phrasing).
  #    Exclude BAD:/GOOD: example lines — they legitimately demonstrate what NOT to say.
  if grep -viE '^(BAD|GOOD):' "$f" | grep -qiE 'you are diagnosed with|your diagnosis is|(you|it) (definitely|certainly) (have|is) (a )?[a-z]+ (disease|condition|cancer)' ; then
    printf "${red}FAIL${reset} %s: contains diagnostic assertion outside an example (forbidden)\n" "$name"; err=$((err+1));
  fi
done < <(find "$ROOT" -name '*.md' ! -name 'README.md')
echo ""
printf "${bold}health skills: %d checked (disclaimer + escalation + defer + no-diagnosis)${reset}\n" "$n"
if [ "$err" -gt 0 ]; then printf "${red}${bold}SAFETY GATE FAILED — %d issues${reset}\n" "$err"; exit 1; else printf "${green}${bold}SAFETY GATE PASSED${reset}\n"; fi
