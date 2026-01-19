#!/usr/bin/env bash
set -euo pipefail

# Description: Generate scaffolding for new improvements (skills, agents, scripts)
# Usage: ./scaffold-improvement.sh [type] [name]
# Types: skill, agent, script

if [ $# -lt 2 ]; then
  echo "Usage: ./scaffold-improvement.sh [skill|agent|script] [name]"
  echo "Example: ./scaffold-improvement.sh skill extracting-pdf-tables"
  exit 1
fi

type="$1"
name="$2"
date=$(date +%Y-%m-%d)

case "$type" in
  skill)
    dir=".claude/skills/$name"
    mkdir -p "$dir/references"

    cat > "$dir/SKILL.md" << EOF
---
name: $name
description: This skill should be used when [specific triggers].
version: 1.0.0
---

# ${name//-/ }

[Brief overview of what this skill provides]

## When to Use

[Describe specific scenarios and trigger phrases]

## Core Knowledge

[Main content - keep under 2000 words]

## Process

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Additional Resources

- **\`references/detailed.md\`** - Extended documentation

---
*Created: $date*
EOF

    cat > "$dir/references/detailed.md" << EOF
# ${name//-/ } - Detailed Reference

Extended documentation for the $name skill.

## [Section 1]

[Detailed content]

## [Section 2]

[Detailed content]

---
*Created: $date*
EOF

    echo "Created skill at $dir/"
    echo "Files:"
    ls -la "$dir/"
    ;;

  agent)
    mkdir -p ".claude/agents"
    file=".claude/agents/$name.md"

    cat > "$file" << EOF
---
name: $name
description: Use this agent when [conditions]. Examples:

<example>
Context: [Scenario description]
user: "[User request]"
assistant: "[How assistant responds]"
<commentary>
[Why this agent should trigger]
</commentary>
</example>

model: inherit
color: blue
tools: ["Read", "Write", "Grep"]
---

You are [role description].

**Your Core Responsibilities:**
1. [Responsibility 1]
2. [Responsibility 2]

**Process:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Output Format:**
[What to return]

**Quality Standards:**
- [Standard 1]
- [Standard 2]

---
*Created: $date*
EOF

    echo "Created agent at $file"
    ;;

  script)
    mkdir -p ".claude/scripts"
    file=".claude/scripts/$name.sh"

    cat > "$file" << EOF
#!/usr/bin/env bash
set -euo pipefail

# Description: [what this script does]
# Usage: ./$name.sh [args]
# Example: ./$name.sh input.txt
# Created: $date

# Validate arguments
if [ \$# -lt 1 ]; then
  echo "Usage: ./$name.sh [args]"
  exit 1
fi

# Main script logic
echo "Running $name..."

# TODO: Implement script logic

echo "Done."
EOF

    chmod +x "$file"

    # Update script catalog
    if [ -f ".claude/scripts/README.md" ]; then
      echo "| $name.sh | [purpose] | \`./$name.sh [args]\` |" >> ".claude/scripts/README.md"
    else
      cat > ".claude/scripts/README.md" << EOF
# Script Library

| Script | Purpose | Usage |
|--------|---------|-------|
| $name.sh | [purpose] | \`./$name.sh [args]\` |
EOF
    fi

    echo "Created script at $file"
    echo "Updated catalog at .claude/scripts/README.md"
    ;;

  *)
    echo "Unknown type: $type"
    echo "Supported types: skill, agent, script"
    exit 1
    ;;
esac
