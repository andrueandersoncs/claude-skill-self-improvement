#!/usr/bin/env bash
set -euo pipefail

# Description: Log tool errors to the error tracking file
# Called by: PostToolUse hook for Bash, Write, Edit, Read tools
# Input: JSON via stdin with tool_name, tool_input, tool_result

# Read input from stdin
input=$(cat)

# Extract fields
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')
tool_result=$(echo "$input" | jq -r '.tool_result // ""')
tool_input=$(echo "$input" | jq -c '.tool_input // {}')

# Check if this is an error (non-zero exit, error message, or failure indicator)
is_error=false

# Check for common error patterns
if echo "$tool_result" | grep -qiE "(error|failed|denied|not found|no such|permission|exception|traceback)" 2>/dev/null; then
  is_error=true
fi

# If not an error, exit silently
if [ "$is_error" = false ]; then
  exit 0
fi

# Ensure error log directory exists
mkdir -p .claude/retros

# Get timestamp
timestamp=$(date +"%Y-%m-%d %H:%M")

# Determine error category
category="unknown"
if echo "$tool_result" | grep -qi "permission denied"; then
  category="permission"
elif echo "$tool_result" | grep -qi "not found\|no such"; then
  category="missing_resource"
elif echo "$tool_result" | grep -qi "syntax\|parse"; then
  category="syntax"
elif echo "$tool_result" | grep -qi "timeout"; then
  category="timeout"
elif echo "$tool_result" | grep -qi "connection\|network"; then
  category="network"
else
  category="execution"
fi

# Truncate tool_result if too long (keep first 500 chars)
truncated_result=$(echo "$tool_result" | head -c 500)
if [ ${#tool_result} -gt 500 ]; then
  truncated_result="${truncated_result}... [truncated]"
fi

# Append to error log
cat >> .claude/retros/errors.md << EOF

## ${timestamp}: ${tool_name} Failure

### Error Details
- **Tool:** ${tool_name}
- **Input:** \`${tool_input}\`
- **Error:** ${truncated_result}
- **Context:** [auto-logged by hook]

### Analysis
- **Root cause:** [to be analyzed]
- **Category:** ${category}
- **Preventable:** [to be determined]

### Resolution
- **Fix applied:** [pending]
- **Prevention:** [how to avoid in future]

---
EOF

# Output for Claude context (stderr goes to Claude)
echo "{\"systemMessage\": \"Error logged to .claude/retros/errors.md for later analysis\"}" >&2

exit 0
