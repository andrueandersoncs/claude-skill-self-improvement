---
name: self-improving
description: This skill should be used when the user says "thanks", "done", "that's all", asks to "reflect", "do a retro", "what did you learn", or when Claude encounters repeated difficulties (3+ attempts), user corrections, or completes significant multi-step tasks. Provides structured self-reflection and improvement implementation.
version: 1.0.0
---

# Self-Improvement Through Reflection

Systematically improve by logging retrospectives and implementing concrete changes to skills, agents, MCPs, plugins, scripts, and workflows.

## Core Workflow

### 1. Ensure Infrastructure

```bash
mkdir -p .claude/retros .claude/scripts .claude/skills .claude/agents
```

### 2. Log to Retro File

Maintain persistent log at `.claude/retros/log.md` using this format:

```markdown
## YYYY-MM-DD: [Brief title]

### Context
- Task/session summary (1-2 sentences)
- User's goal

### What went wrong
- [Specific failure or inefficiency]
- [Root cause if identifiable]

### What went well
- [Specific success worth repeating]

### Decisions
- [ ] [Concrete action] → [type: skill/agent/mcp/plugin/script/claude.md]

### Implementation status
- [Link to created file, or "pending"]
```

### 3. Identify Friction Points

Ask these questions during reflection:
- Where were multiple attempts needed?
- Where did the user provide corrections?
- What context was missing that required asking?
- What repetitive steps could be automated?
- What errors occurred and why?

### 4. Categorize and Implement

| Gap Type | Solution | Location |
|----------|----------|----------|
| Missing domain knowledge | Create skill | `.claude/skills/[name]/SKILL.md` |
| Repetitive workflow | Create agent | `.claude/agents/[name].md` |
| Missing external data | Add MCP server | `claude mcp add` |
| Project-specific patterns | Update memory | `CLAUDE.md` |
| Reusable commands | Create script | `.claude/scripts/[name].sh` |
| Shareable improvements | Create plugin | `[name]/.claude-plugin/` |

## Script Library

Build reusable scripts at `.claude/scripts/`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Description: [what this script does]
# Usage: ./script-name.sh [args]
# Example: ./script-name.sh input.txt output.csv
```

**Naming:** `verb-noun.sh` (e.g., `extract-tables.sh`, `validate-config.sh`)

Maintain index at `.claude/scripts/README.md`.

## Validation Checklist

Before completing a retro:
1. At least one decision is actionable and concrete
2. Implementation status updated (link or "pending")
3. No vague anti-patterns (see below)
4. Decisions specify implementation type
5. New scripts added to catalog with documentation

## When to Trigger

**Always trigger after:**
- User signals completion ("thanks", "done", "that's all")
- Multi-step task completes
- 3+ attempts at something
- User correction of approach

**Ask before triggering when:**
- Task was trivial
- No friction occurred
- Similar retro done recently

## Anti-patterns

| Avoid | Do Instead |
|-------|------------|
| "Everything went smoothly" | Identify at least one improvement |
| "I should be more careful" | Specify what check to add |
| Log without implementing | Complete at least one decision |
| Create skill for one-off | Only automate recurring patterns |
| Vague "improve X" | Concrete "Create skill that does Y" |

## Additional Resources

### Reference Files

- **`references/improvement-types.md`** - Detailed guide for each improvement type
- **`references/retro-examples.md`** - Real-world retro entry examples

### Scripts

- **`${CLAUDE_PLUGIN_ROOT}/scripts/parse-retro-log.sh`** - Extract pending decisions from retro log
- **`${CLAUDE_PLUGIN_ROOT}/scripts/scaffold-improvement.sh`** - Generate improvement file templates
