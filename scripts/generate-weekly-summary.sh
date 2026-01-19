#!/usr/bin/env bash
set -euo pipefail

# Description: Generate a weekly self-improvement summary report
# Usage: ./generate-weekly-summary.sh [weeks-back]
# Example: ./generate-weekly-summary.sh 0  (current week)
# Example: ./generate-weekly-summary.sh 1  (last week)

weeks_back="${1:-0}"

# Calculate week start date (macOS and Linux compatible)
if date -v-"${weeks_back}"w +%Y-%m-%d > /dev/null 2>&1; then
  # macOS
  week_start=$(date -v-"${weeks_back}"w -v-sun +%Y-%m-%d)
  week_end=$(date -v-"${weeks_back}"w -v+6d -v-sun +%Y-%m-%d)
else
  # Linux
  week_start=$(date -d "${weeks_back} weeks ago last sunday" +%Y-%m-%d)
  week_end=$(date -d "${weeks_back} weeks ago next saturday" +%Y-%m-%d)
fi

RETRO_FILE=".claude/retros/log.md"
ERROR_FILE=".claude/retros/errors.md"

echo "# Weekly Self-Improvement Summary"
echo "## Week of $week_start to $week_end"
echo ""

# Count retros this week
if [ -f "$RETRO_FILE" ]; then
  retro_count=$(grep "^## $week_start\|^## " "$RETRO_FILE" | grep -c "^## [0-9]" 2>/dev/null || echo "0")
  echo "### Retrospectives: $retro_count"
  echo ""

  # List retro titles
  grep "^## [0-9]" "$RETRO_FILE" | while read -r line; do
    retro_date=$(echo "$line" | cut -d: -f1 | cut -c4-)
    if [[ "$retro_date" > "$week_start" ]] || [[ "$retro_date" == "$week_start" ]]; then
      if [[ "$retro_date" < "$week_end" ]] || [[ "$retro_date" == "$week_end" ]]; then
        echo "- $line"
      fi
    fi
  done
  echo ""

  # Pending decisions
  pending=$(grep -c "^\- \[ \]" "$RETRO_FILE" 2>/dev/null || echo "0")
  echo "### Pending Decisions: $pending"
  if [ "$pending" -gt 0 ]; then
    grep "^\- \[ \]" "$RETRO_FILE" | head -5
    if [ "$pending" -gt 5 ]; then
      echo "... and $((pending - 5)) more"
    fi
  fi
  echo ""
else
  echo "### Retrospectives: No retro log found"
  echo ""
fi

# Error summary
if [ -f "$ERROR_FILE" ]; then
  error_count=$(grep -c "^## [0-9]" "$ERROR_FILE" 2>/dev/null || echo "0")
  echo "### Errors Logged: $error_count total"
  echo ""

  if [ "$error_count" -gt 0 ]; then
    echo "**By Tool:**"
    grep "^\*\*Tool:\*\*" "$ERROR_FILE" | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn | head -3
    echo ""

    echo "**By Category:**"
    grep "^\*\*Category:\*\*" "$ERROR_FILE" | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn | head -3
    echo ""
  fi
else
  echo "### Errors: No error log found"
  echo ""
fi

# Existing improvements
echo "### Existing Improvements"
skill_count=$(ls .claude/skills/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ' || echo "0")
agent_count=$(ls .claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ' || echo "0")
script_count=$(ls .claude/scripts/*.sh 2>/dev/null | wc -l | tr -d ' ' || echo "0")

echo "- Skills: $skill_count"
echo "- Agents: $agent_count"
echo "- Scripts: $script_count"
echo ""

# Recurring themes
if [ -f "$RETRO_FILE" ]; then
  echo "### Recurring Themes"
  themes=$(grep -h "What went wrong" -A5 "$RETRO_FILE" 2>/dev/null | grep "^-" | sed 's/^- //' | sort | uniq -c | sort -rn | head -3)
  if [ -n "$themes" ]; then
    echo "$themes"
  else
    echo "No recurring themes detected"
  fi
  echo ""
fi

echo "---"
echo "*Generated: $(date +"%Y-%m-%d %H:%M")*"
