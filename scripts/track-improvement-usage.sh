#!/usr/bin/env bash
set -euo pipefail

# Description: Track effectiveness of implemented improvements
# Usage: ./track-improvement-usage.sh [list|report]
# Example: ./track-improvement-usage.sh report

RETRO_FILE=".claude/retros/log.md"
command="${1:-report}"

case "$command" in
  list)
    echo "=== Implemented Improvements ==="
    echo ""

    echo "### Skills"
    for skill in .claude/skills/*/SKILL.md; do
      if [ -f "$skill" ]; then
        name=$(dirname "$skill" | xargs basename)
        created=$(stat -f "%Sm" -t "%Y-%m-%d" "$skill" 2>/dev/null || stat -c "%y" "$skill" 2>/dev/null | cut -d' ' -f1)
        echo "- $name (created: $created)"
      fi
    done 2>/dev/null || echo "  No skills found"

    echo ""
    echo "### Agents"
    for agent in .claude/agents/*.md; do
      if [ -f "$agent" ]; then
        name=$(basename "$agent" .md)
        created=$(stat -f "%Sm" -t "%Y-%m-%d" "$agent" 2>/dev/null || stat -c "%y" "$agent" 2>/dev/null | cut -d' ' -f1)
        echo "- $name (created: $created)"
      fi
    done 2>/dev/null || echo "  No agents found"

    echo ""
    echo "### Scripts"
    for script in .claude/scripts/*.sh; do
      if [ -f "$script" ]; then
        name=$(basename "$script")
        created=$(stat -f "%Sm" -t "%Y-%m-%d" "$script" 2>/dev/null || stat -c "%y" "$script" 2>/dev/null | cut -d' ' -f1)
        echo "- $name (created: $created)"
      fi
    done 2>/dev/null || echo "  No scripts found"
    ;;

  report)
    echo "=== Improvement Effectiveness Report ==="
    echo ""

    # Count improvements
    skill_count=$(ls .claude/skills/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ' || echo "0")
    agent_count=$(ls .claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ' || echo "0")
    script_count=$(ls .claude/scripts/*.sh 2>/dev/null | wc -l | tr -d ' ' || echo "0")

    echo "### Summary"
    echo "- Skills: $skill_count"
    echo "- Agents: $agent_count"
    echo "- Scripts: $script_count"
    echo "- Total: $((skill_count + agent_count + script_count))"
    echo ""

    # Check for recurring issues after improvements
    if [ -f "$RETRO_FILE" ]; then
      echo "### Issue Recurrence After Improvements"

      # For each skill, check if its target issue still appears
      for skill in .claude/skills/*/SKILL.md; do
        if [ -f "$skill" ]; then
          name=$(dirname "$skill" | xargs basename)
          # Get creation date
          created=$(stat -f "%Sm" -t "%Y-%m-%d" "$skill" 2>/dev/null || stat -c "%y" "$skill" 2>/dev/null | cut -d' ' -f1)

          # Search for mentions after creation (simplified)
          recent_mentions=$(grep -c "$name" "$RETRO_FILE" 2>/dev/null || echo "0")

          if [ "$recent_mentions" -gt 1 ]; then
            echo "⚠️ $name: $recent_mentions mentions (may need refinement)"
          else
            echo "✅ $name: Working as expected"
          fi
        fi
      done 2>/dev/null
      echo ""
    fi

    # Pending decisions that could use existing improvements
    if [ -f "$RETRO_FILE" ]; then
      pending=$(grep -c "^\- \[ \]" "$RETRO_FILE" 2>/dev/null || echo "0")
      if [ "$pending" -gt 0 ]; then
        echo "### Pending Decisions"
        echo "$pending decisions still pending implementation"
        echo ""
        echo "Run: ./parse-retro-log.sh pending"
      fi
    fi
    ;;

  *)
    echo "Unknown command: $command"
    echo "Usage: ./track-improvement-usage.sh [list|report]"
    exit 1
    ;;
esac
