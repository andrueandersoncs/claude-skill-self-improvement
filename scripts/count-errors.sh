#!/usr/bin/env bash
set -euo pipefail

# Description: Summarize error frequencies from the error log
# Usage: ./count-errors.sh [by-tool|by-category|by-date|summary]
# Example: ./count-errors.sh summary

ERROR_FILE=".claude/retros/errors.md"
command="${1:-summary}"

if [ ! -f "$ERROR_FILE" ]; then
  echo "No error log found at $ERROR_FILE"
  exit 1
fi

case "$command" in
  by-tool)
    echo "=== Errors by Tool ==="
    grep "^\*\*Tool:\*\*" "$ERROR_FILE" | \
      cut -d: -f2 | tr -d ' ' | \
      sort | uniq -c | sort -rn
    ;;

  by-category)
    echo "=== Errors by Category ==="
    grep "^\*\*Category:\*\*" "$ERROR_FILE" | \
      cut -d: -f2 | tr -d ' ' | \
      sort | uniq -c | sort -rn
    ;;

  by-date)
    echo "=== Errors by Date ==="
    grep "^## [0-9]" "$ERROR_FILE" | \
      cut -d: -f1 | cut -c4- | \
      sort | uniq -c
    ;;

  summary)
    echo "=== Error Summary ==="
    echo ""

    total=$(grep -c "^## [0-9]" "$ERROR_FILE" 2>/dev/null || echo "0")
    echo "Total errors logged: $total"
    echo ""

    if [ "$total" -gt 0 ]; then
      echo "### By Tool (Top 5)"
      grep "^\*\*Tool:\*\*" "$ERROR_FILE" | \
        cut -d: -f2 | tr -d ' ' | \
        sort | uniq -c | sort -rn | head -5
      echo ""

      echo "### By Category (Top 5)"
      grep "^\*\*Category:\*\*" "$ERROR_FILE" | \
        cut -d: -f2 | tr -d ' ' | \
        sort | uniq -c | sort -rn | head -5
      echo ""

      # Count unresolved
      unresolved=$(grep -c "Fix applied:.*pending\|Fix applied:.*\[pending\]" "$ERROR_FILE" 2>/dev/null || echo "0")
      echo "### Resolution Status"
      echo "Unresolved: $unresolved"
      echo "Resolved: $((total - unresolved))"
      echo ""

      # Most recent
      echo "### Most Recent Error"
      grep "^## [0-9]" "$ERROR_FILE" | tail -1
    fi
    ;;

  *)
    echo "Unknown command: $command"
    echo "Usage: ./count-errors.sh [by-tool|by-category|by-date|summary]"
    exit 1
    ;;
esac
