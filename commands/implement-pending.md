---
description: Implement pending improvement decisions from retrospectives
allowed-tools: Read, Write, Glob, Grep, Bash
argument-hint: [improvement-type|all]
---

Implement pending improvement decisions from the retrospective log.

## Step 1: Find Pending Decisions

Extract all uncompleted decisions:
```bash
grep -B10 "^\- \[ \]" .claude/retros/log.md 2>/dev/null | grep -E "(^## |^\- \[ \])"
```

## Step 2: Filter by Type (if specified)

If $ARGUMENTS specifies a type (skill, agent, script, mcp, claude.md):
- Filter to only decisions of that type
- Show matching decisions

If $ARGUMENTS is "all" or empty:
- Show all pending decisions
- Ask which to implement

## Step 3: Implement Each Decision

For each decision to implement:

### For Skills
1. Determine skill name (gerund form: `extracting-x`, `validating-y`)
2. Create directory: `mkdir -p .claude/skills/[name]`
3. Create SKILL.md with:
   - Frontmatter (name, description with triggers, version)
   - Core knowledge (under 2000 words)
   - Reference to supporting files
4. Create references/ for detailed content if needed

### For Agents
1. Determine agent name (role-based: `invoice-processor`, `test-runner`)
2. Create `.claude/agents/[name].md` with:
   - Frontmatter (name, description with examples, model, color, tools)
   - System prompt with responsibilities, process, output format
3. Include 2-3 triggering examples in description

### For Scripts
1. Determine script name (`verb-noun.sh`)
2. Create `.claude/scripts/[name].sh` with:
   - Shebang and set -euo pipefail
   - Description, usage, and example comments
   - Script body
3. Make executable: `chmod +x .claude/scripts/[name].sh`
4. Update `.claude/scripts/README.md` catalog

### For CLAUDE.md Updates
1. Read existing CLAUDE.md (or create if missing)
2. Add new pattern/preference in appropriate section
3. Keep entries concise and actionable

### For MCP Servers
1. Determine server configuration needed
2. Run: `claude mcp add --transport [type] [name] [url-or-command]`
3. Document in CLAUDE.md

## Step 4: Update Retro Log

After implementing each decision:
1. Mark decision as completed: `- [x]` instead of `- [ ]`
2. Update implementation status section with links to created files

Use Edit tool to update `.claude/retros/log.md`:
```markdown
### Decisions
- [x] [Completed action] → [type]

### Implementation status
- Created `.claude/[path]/[file]`
```

## Step 5: Verify Implementation

After all implementations:
1. List created files to confirm
2. Test any scripts for basic functionality
3. Report summary of what was implemented

## Tips

- Implement skills/agents for recurring patterns (3+ occurrences)
- Implement scripts for repeated command sequences
- Keep CLAUDE.md updates minimal and focused
- Prefer editing existing improvements over creating new ones
