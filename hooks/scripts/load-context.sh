#!/usr/bin/env bash
set -euo pipefail

# Description: Load self-improvement context at session start
# Called by: SessionStart hook
# Output: Context information for Claude

# Check if retro infrastructure exists
retro_exists=false
error_log_exists=false
pending_count=0
recent_errors=0

if [ -f ".claude/retros/log.md" ]; then
  retro_exists=true
  # Count pending decisions
  pending_count=$(grep -c "^\- \[ \]" .claude/retros/log.md 2>/dev/null || echo "0")
fi

if [ -f ".claude/retros/errors.md" ]; then
  error_log_exists=true
  # Count errors in last 7 days (approximate by counting recent entries)
  recent_errors=$(grep -c "^## [0-9]" .claude/retros/errors.md 2>/dev/null | tail -1 || echo "0")
fi

# Count existing improvements
skill_count=$(ls .claude/skills/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ' || echo "0")
agent_count=$(ls .claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ' || echo "0")
script_count=$(ls .claude/scripts/*.sh 2>/dev/null | wc -l | tr -d ' ' || echo "0")

# Build context message
context=""

if [ "$pending_count" -gt 0 ]; then
  context="${context}📋 ${pending_count} pending improvement decisions in retro log. "
fi

if [ "$recent_errors" -gt 5 ]; then
  context="${context}⚠️ ${recent_errors} errors logged - consider reviewing patterns. "
fi

if [ "$skill_count" -gt 0 ] || [ "$agent_count" -gt 0 ] || [ "$script_count" -gt 0 ]; then
  context="${context}🛠️ Existing improvements: ${skill_count} skills, ${agent_count} agents, ${script_count} scripts. "
fi

if [ -z "$context" ]; then
  if [ "$retro_exists" = false ]; then
    context="💡 Self-improvement plugin active. Run /retro after tasks to capture learnings."
  else
    context="✅ Self-improvement plugin active. No pending items."
  fi
fi

# Output context for Claude
echo "{\"systemMessage\": \"${context}\"}"

exit 0
