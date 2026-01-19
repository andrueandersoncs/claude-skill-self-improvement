#!/usr/bin/env bash
set -euo pipefail

# Description: Extract and summarize information from the retrospective log
# Usage: ./parse-retro-log.sh [command]
# Commands:
#   pending    - List pending decisions
#   completed  - List completed decisions
#   themes     - Find recurring themes
#   recent     - Show last N retros (default 5)
#   stats      - Show statistics

RETRO_FILE=".claude/retros/log.md"

if [ ! -f "$RETRO_FILE" ]; then
  echo "No retro log found at $RETRO_FILE"
  exit 1
fi

command="${1:-stats}"

case "$command" in
  pending)
    echo "=== Pending Decisions ==="
    grep -B5 "^\- \[ \]" "$RETRO_FILE" | grep -E "(^## |^\- \[ \])" || echo "No pending decisions"
    ;;

  completed)
    echo "=== Completed Decisions ==="
    grep "^\- \[x\]" "$RETRO_FILE" || echo "No completed decisions"
    ;;

  themes)
    echo "=== Recurring Themes (What went wrong) ==="
    grep -h "What went wrong" -A5 "$RETRO_FILE" | grep "^-" | sed 's/^- //' | sort | uniq -c | sort -rn | head -10
    ;;

  recent)
    count="${2:-5}"
    echo "=== Last $count Retros ==="
    grep "^## [0-9]" "$RETRO_FILE" | tail -"$count"
    ;;

  stats)
    echo "=== Retro Statistics ==="
    total=$(grep -c "^## [0-9]" "$RETRO_FILE" 2>/dev/null || echo "0")
    pending=$(grep -c "^\- \[ \]" "$RETRO_FILE" 2>/dev/null || echo "0")
    completed=$(grep -c "^\- \[x\]" "$RETRO_FILE" 2>/dev/null || echo "0")

    echo "Total retros: $total"
    echo "Pending decisions: $pending"
    echo "Completed decisions: $completed"

    if [ "$total" -gt 0 ]; then
      first_date=$(grep "^## [0-9]" "$RETRO_FILE" | head -1 | cut -d: -f1 | cut -c4-)
      last_date=$(grep "^## [0-9]" "$RETRO_FILE" | tail -1 | cut -d: -f1 | cut -c4-)
      echo "Date range: $first_date to $last_date"
    fi
    ;;

  *)
    echo "Unknown command: $command"
    echo "Usage: ./parse-retro-log.sh [pending|completed|themes|recent|stats]"
    exit 1
    ;;
esac
