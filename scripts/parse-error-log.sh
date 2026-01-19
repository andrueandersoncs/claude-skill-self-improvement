#!/usr/bin/env bash
set -euo pipefail

# Description: Extract and summarize information from the error log
# Usage: ./parse-error-log.sh [command]
# Commands:
#   tools      - Errors by tool
#   categories - Errors by category
#   recent     - Recent errors
#   unresolved - Errors without resolution
#   stats      - Show statistics

ERROR_FILE=".claude/retros/errors.md"

if [ ! -f "$ERROR_FILE" ]; then
  echo "No error log found at $ERROR_FILE"
  exit 1
fi

command="${1:-stats}"

case "$command" in
  tools)
    echo "=== Errors by Tool ==="
    grep "^\*\*Tool:\*\*" "$ERROR_FILE" | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn
    ;;

  categories)
    echo "=== Errors by Category ==="
    grep "^\*\*Category:\*\*" "$ERROR_FILE" | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn
    ;;

  recent)
    count="${2:-5}"
    echo "=== Last $count Errors ==="
    grep "^## [0-9]" "$ERROR_FILE" | tail -"$count"
    ;;

  unresolved)
    echo "=== Unresolved Errors ==="
    # Find errors where Fix applied is still [pending] or empty
    awk '/^## [0-9]/{title=$0} /Fix applied:.*\[pending\]|Fix applied:.*pending/{print title}' "$ERROR_FILE"
    ;;

  stats)
    echo "=== Error Statistics ==="
    total=$(grep -c "^## [0-9]" "$ERROR_FILE" 2>/dev/null || echo "0")

    echo "Total errors logged: $total"

    if [ "$total" -gt 0 ]; then
      echo ""
      echo "By tool:"
      grep "^\*\*Tool:\*\*" "$ERROR_FILE" | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn | head -5

      echo ""
      echo "By category:"
      grep "^\*\*Category:\*\*" "$ERROR_FILE" | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn | head -5
    fi
    ;;

  *)
    echo "Unknown command: $command"
    echo "Usage: ./parse-error-log.sh [tools|categories|recent|unresolved|stats]"
    exit 1
    ;;
esac
