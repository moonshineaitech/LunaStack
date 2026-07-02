#!/usr/bin/env bash
# build.sh — Generates LunaStack.md from the individual SKILL.md files.
#
# The individual */SKILL.md files are the single source of truth.
# Discipline grouping and ordering come from AGENTS.md.
# Section headers/intros come from distribution/sections.md.
# Static appendix (Flow Maps, Worked Examples, etc.) from distribution/appendix.md.
#
# Usage: ./build.sh [--check]
#   --check  Build to a temp file and diff against LunaStack.md (CI sync gate).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$REPO_DIR/LunaStack.md"
MODE="${1:-}"

AGENTS="$REPO_DIR/AGENTS.md"
SECTIONS="$REPO_DIR/distribution/sections.md"
HEADER="$REPO_DIR/distribution/header.md"
APPENDIX="$REPO_DIR/distribution/appendix.md"

for f in "$AGENTS" "$SECTIONS" "$HEADER" "$APPENDIX"; do
  [ -f "$f" ] || { echo "ERROR: missing $f" >&2; exit 1; }
done

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# --- Collect skill list in AGENTS.md order, grouped by section ---
# AGENTS.md format: "## Section Name (N)" then table rows "| /skill | desc |"
mapfile -t agents_lines < "$AGENTS"

# --- Build the commands index (alphabetical) ---
commands=$(for d in "$REPO_DIR"/*/SKILL.md; do
  printf '/%s\n' "$(basename "$(dirname "$d")")"
done | sort | paste -sd ', ' -)
count=$(ls -d "$REPO_DIR"/*/SKILL.md | wc -l | tr -d ' ')

# --- Emit header with substitutions ---
sed -e "s|{{COMMANDS}}|${commands}|" -e "s|{{COUNT}}|${count}|" "$HEADER" >> "$TMP"

# --- Helper: emit one section's header+intro from sections.md ---
emit_section_block() {
  local name="$1"
  awk -v name="$name" '
    $0 == "<!-- SECTION: " name " -->" { found=1; next }
    found && /^<!-- SECTION: / { exit }
    found { print }
  ' "$SECTIONS"
}

# --- Helper: emit one skill body (frontmatter stripped, H1 demoted to H2) ---
emit_skill() {
  local skill="$1"
  local file="$REPO_DIR/$skill/SKILL.md"
  [ -f "$file" ] || { echo "ERROR: no SKILL.md for /$skill (listed in AGENTS.md)" >&2; return 1; }
  awk '
    NR == 1 && /^---$/ { infm=1; next }
    infm && /^---$/ { infm=0; body=1; next }
    infm { next }
    body || NR > 1 {
      # Demote the top-level "# /name — Title" heading to "## /name — Title"
      if (!demoted && /^# \//) { sub(/^# /, "## "); demoted=1 }
      print
    }
  ' "$file"
}

# --- Walk AGENTS.md: sections in order, skills in order ---
current_section=""
emitted=0
for line in "${agents_lines[@]}"; do
  if [[ "$line" =~ ^##\ (.+)\ \(([0-9]+)\)$ ]]; then
    current_section="${BASH_REMATCH[1]}"
    printf '\n' >> "$TMP"
    block=$(emit_section_block "$current_section")
    if [ -z "$block" ]; then
      echo "ERROR: no section block for '$current_section' in distribution/sections.md" >&2
      exit 1
    fi
    printf '%s\n' "$block" >> "$TMP"
  elif [[ "$line" =~ ^\|\ /([a-z0-9-]+)\ \| ]] && [ -n "$current_section" ]; then
    skill="${BASH_REMATCH[1]}"
    printf '\n' >> "$TMP"
    emit_skill "$skill" >> "$TMP"
    emitted=$((emitted + 1))
  fi
done

# --- Appendix + END ---
printf '\n---\n\n' >> "$TMP"
cat "$APPENDIX" >> "$TMP"
printf '\n# END\n' >> "$TMP"

# --- Sanity checks ---
if [ "$emitted" -ne "$count" ]; then
  echo "ERROR: emitted $emitted protocols but $count skill dirs exist" >&2
  exit 1
fi
proto_count=$(grep -c '^## /' "$TMP")
if [ "$proto_count" -ne "$count" ]; then
  echo "ERROR: generated file has $proto_count '## /' headings, expected $count" >&2
  exit 1
fi

if [ "$MODE" = "--check" ]; then
  if diff -q "$OUT" "$TMP" > /dev/null 2>&1; then
    echo "OK: LunaStack.md is in sync with skill files ($count protocols)."
  else
    echo "OUT OF SYNC: LunaStack.md does not match the skill files." >&2
    echo "Run ./build.sh and commit the result." >&2
    diff "$OUT" "$TMP" | head -20 >&2 || true
    exit 1
  fi
else
  mv "$TMP" "$OUT"
  trap - EXIT
  size=$(du -h "$OUT" | cut -f1)
  lines=$(wc -l < "$OUT")
  echo "Built LunaStack.md: $count protocols, $lines lines, $size."
fi
