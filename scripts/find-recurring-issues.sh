#!/usr/bin/env bash
set -euo pipefail

# Description: Find recurring issues across retrospective log entries
# Usage: ./find-recurring-issues.sh [threshold]
# Example: ./find-recurring-issues.sh 3  (find issues appearing 3+ times)

RETRO_FILE=".claude/retros/log.md"
threshold="${1:-3}"

if [ ! -f "$RETRO_FILE" ]; then
  echo "No retro log found at $RETRO_FILE"
  exit 1
fi

echo "=== Recurring Issues (appearing ${threshold}+ times) ==="
echo ""

# Find recurring "What went wrong" themes
echo "### Friction Patterns"
grep -h "What went wrong" -A10 "$RETRO_FILE" 2>/dev/null | \
  grep "^-" | \
  sed 's/^- //' | \
  sort | uniq -c | sort -rn | \
  awk -v t="$threshold" '$1 >= t {print $0}'

echo ""

# Find recurring tools with issues
if [ -f ".claude/retros/errors.md" ]; then
  echo "### Problematic Tools"
  grep "^\*\*Tool:\*\*" ".claude/retros/errors.md" 2>/dev/null | \
    cut -d: -f2 | tr -d ' ' | \
    sort | uniq -c | sort -rn | \
    awk -v t="$threshold" '$1 >= t {print $0}'
  echo ""
fi

# Find recurring categories
echo "### Recurring Categories"
grep "→" "$RETRO_FILE" 2>/dev/null | \
  grep -oE "→ [a-z.]+" | \
  sort | uniq -c | sort -rn | \
  awk -v t="$threshold" '$1 >= t {print $0}'

echo ""
echo "---"
echo "Threshold: $threshold occurrences"
echo "To change threshold: ./find-recurring-issues.sh [number]"
