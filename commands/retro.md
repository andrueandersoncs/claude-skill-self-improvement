---
description: Conduct a self-improvement retrospective on the current session
allowed-tools: Read, Write, Glob, Grep, Bash
argument-hint: [optional-title]
---

Conduct a structured self-improvement retrospective for this session.

## Setup

Ensure infrastructure exists:
```bash
mkdir -p .claude/retros .claude/scripts .claude/skills .claude/agents
```

## Reflection Process

### 1. Identify Friction Points

Review the session and identify:
- Where multiple attempts were needed
- Where the user provided corrections
- What context was missing that required asking
- What repetitive steps could be automated
- What errors occurred

### 2. Check Error Log

Review recent errors if available:
```bash
tail -30 .claude/retros/errors.md 2>/dev/null || echo "No error log yet"
```

### 3. Log the Retrospective

Append a new entry to `.claude/retros/log.md` with this format:

```markdown
## [Today's Date]: $ARGUMENTS

### Context
- [1-2 sentence task summary]
- [User's goal]

### What went wrong
- [Specific failures or inefficiencies]
- [Root causes]

### What went well
- [Successes worth repeating]

### Decisions
- [ ] [Concrete action] → [skill/agent/script/mcp/claude.md]

### Implementation status
- pending
```

If $ARGUMENTS is empty, use a brief descriptive title based on the session.

### 4. Validate Entry

Before finishing, verify:
1. At least one decision is actionable and concrete
2. Decisions specify implementation type
3. No vague anti-patterns ("be more careful", "everything went well")

### 5. Implement at Least One Decision

After logging, implement at least one pending decision:
- **Skill:** Create `.claude/skills/[name]/SKILL.md`
- **Agent:** Create `.claude/agents/[name].md`
- **Script:** Create `.claude/scripts/[name].sh` and update catalog
- **CLAUDE.md:** Add pattern or preference

Reference the self-improving skill for implementation details.

### 6. Update Implementation Status

After creating improvements, update the retro entry's implementation status with links to created files.

## Tips

- Focus on patterns, not just events
- Be specific about what failed and why
- Propose preventive measures, not just fixes
- If unsure what to improve, create a script for a repeated command sequence
