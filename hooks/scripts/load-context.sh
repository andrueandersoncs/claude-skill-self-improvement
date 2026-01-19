#!/bin/bash
# SessionStart hook: Notify Claude that learnings are available
# This script runs at session start to inject minimal context

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LEARNINGS_DIR="$PROJECT_DIR/.claude/learnings"

# Check if learnings directory exists
if [ -d "$LEARNINGS_DIR" ]; then
    # Count learnings in each category (handle missing directories)
    count_md_files() {
        local dir="$1"
        if [ -d "$dir" ]; then
            find "$dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' '
        else
            echo "0"
        fi
    }

    errors_count=$(count_md_files "$LEARNINGS_DIR/errors")
    patterns_count=$(count_md_files "$LEARNINGS_DIR/patterns")
    preferences_count=$(count_md_files "$LEARNINGS_DIR/preferences")
    improvements_count=$(count_md_files "$LEARNINGS_DIR/improvements")
    scripts_count=$(count_md_files "$LEARNINGS_DIR/scripts")
    extensions_count=$(count_md_files "$LEARNINGS_DIR/extensions")

    total=$((errors_count + patterns_count + preferences_count + improvements_count + scripts_count + extensions_count))

    if [ "$total" -gt 0 ]; then
        echo "[Self-Improvement Context]"
        echo "This project has $total learnings from previous sessions at .claude/learnings/"
        echo "Categories: errors($errors_count) patterns($patterns_count) preferences($preferences_count) improvements($improvements_count) scripts($scripts_count) extensions($extensions_count)"
        echo "Use the cross-session-learning skill when encountering errors or needing project context."
    fi
else
    # No learnings yet - minimal notification
    echo "[Self-Improvement] No previous learnings found. Session retrospectives will be captured at session end."
fi

exit 0
