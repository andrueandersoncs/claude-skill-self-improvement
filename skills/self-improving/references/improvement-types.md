# Improvement Types Reference

Detailed guide for implementing each type of self-improvement.

## Skills

**Purpose:** Capture domain knowledge that Claude lacks or frequently needs

**When to create:**
- Same information looked up 3+ times
- Domain-specific workflow that requires specialized knowledge
- User corrections about a particular topic

**Structure:**
```
.claude/skills/[name]/
├── SKILL.md          # Core knowledge (required)
├── references/       # Detailed documentation
├── examples/         # Working examples
└── scripts/          # Utility scripts
```

**SKILL.md Template:**
```markdown
---
name: skill-name
description: This skill should be used when [specific triggers].
version: 1.0.0
---

# Skill Title

[Core knowledge and procedures - keep under 2000 words]

## Additional Resources

- **`references/detailed.md`** - Extended documentation
```

**Naming:** Use gerund form (e.g., `extracting-pdf-tables`, `validating-configs`)

---

## Agents

**Purpose:** Automate repetitive multi-step workflows

**When to create:**
- Same sequence of steps performed 3+ times
- Complex workflow requiring coordination
- Task that benefits from autonomous operation

**Structure:**
```
.claude/agents/[name].md
```

**Agent Template:**
```markdown
---
name: agent-name
description: Use this agent when [conditions]. Examples:

<example>
Context: [Scenario]
user: "[Request]"
assistant: "[Response]"
<commentary>
[Why agent triggers]
</commentary>
</example>

model: inherit
color: blue
tools: ["Read", "Write", "Grep"]
---

You are [role description].

**Responsibilities:**
1. [Task 1]
2. [Task 2]

**Process:**
1. [Step 1]
2. [Step 2]

**Output Format:**
[What to return]
```

**Naming:** Role-based (e.g., `invoice-processor`, `test-runner`)

---

## Scripts

**Purpose:** Capture exact command sequences that work

**When to create:**
- Same commands run 3+ times
- Complex flags or options to remember
- Multi-step sequence that must run in order

**Template:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Description: [what this script does]
# Usage: ./script-name.sh [args]
# Example: ./script-name.sh input.txt

[script body]
```

**Naming:** `verb-noun.sh` (e.g., `extract-tables.sh`, `validate-config.sh`)

**Catalog:** Maintain index at `.claude/scripts/README.md`

---

## MCP Servers

**Purpose:** Integrate external data sources or tools

**When to add:**
- Need data from external API
- Want to use specialized tool
- Require database access

**Adding:**
```bash
claude mcp add --transport [stdio|sse] [name] [command-or-url]
```

**Configuration:** `.mcp.json` at project root

---

## CLAUDE.md Updates

**Purpose:** Persist project-specific patterns and preferences

**When to update:**
- User correction about project conventions
- Discovered pattern specific to this codebase
- Preference that should apply to all sessions

**What to include:**
- Code style preferences
- Architecture decisions
- Common file locations
- Project-specific terminology

**What NOT to include:**
- General programming knowledge
- Temporary workarounds
- Session-specific context

---

## Plugins

**Purpose:** Bundle improvements for sharing across projects

**When to create:**
- Improvements useful beyond single project
- Want to share with team or community
- Need versioning and distribution

**Structure:**
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json
├── skills/
├── commands/
├── agents/
└── hooks/
```

**Convert standalone to plugin:**
1. Create plugin directory structure
2. Move files from `.claude/` to plugin
3. Add `plugin.json` manifest
4. Update paths to use `${CLAUDE_PLUGIN_ROOT}`
