---
name: self-improving
description: Conducts self-reflection and debriefs on task performance. Use after completing significant tasks, at session end, when explicitly asked to reflect, or when encountering repeated difficulties.
allowed-tools: Read, Write, Glob, Grep, Bash
user-invocable: true
---

# Self-Improvement Through Reflection

Systematically improve by logging retrospectives and implementing concrete changes to skills, subagents, MCPs, and workflows.

## Setup

Ensure the retros directory exists:
```bash
mkdir -p .claude/retros
```

## Retro log

Maintain a persistent log at `.claude/retros/log.md`. See [templates/retro-template.md](templates/retro-template.md) for a copyable template.

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
- [ ] [Concrete action to take] → [implementation type: skill/agent/mcp/script/claude.md]

### Implementation status
- [Link to created/updated file, or "pending"]
```

## How to reflect

Reflection is not summarizing what happened. It's identifying *patterns* that should change future behavior.

### Step 1: Identify friction points

- Where did I need multiple attempts?
- Where did the user correct me?
- What context did I lack that I had to ask for?
- What repetitive steps could be automated?

### Step 2: Categorize the gap

| Gap type | Solution |
|----------|----------|
| Missing domain knowledge | Create a skill with that knowledge |
| Repetitive multi-step workflow | Create a subagent to handle it |
| Missing external data/tools | Add an MCP server |
| Project-specific patterns | Update CLAUDE.md |
| Reusable script needed | Create script in `.claude/scripts/` |

### Step 3: Implement the improvement

After logging, create the improvement:

- **Skill:** `.claude/skills/[name]/SKILL.md` - See [creating-skills.md](creating-skills.md)
- **Agent:** `.claude/agents/[name].md` - See [creating-agents.md](creating-agents.md)
- **MCP:** `claude mcp add --transport [type] [name] [url-or-command]`
- **Memory:** Update `CLAUDE.md` with patterns or preferences

## Validation

After logging a retro, verify:

1. At least one decision is actionable and concrete
2. Implementation status is updated (link or "pending")
3. No vague anti-patterns exist (see below)
4. Decisions specify the type (skill/agent/mcp/script/claude.md)

Run this checklist before considering the retro complete.

## Example retro entry

```markdown
## 2025-01-08: PDF form filling task

### Context
- User asked me to extract data from invoices and fill a spreadsheet
- Goal: automate monthly invoice processing

### What went wrong
- Tried using PyPDF2 first, which couldn't extract tables
- Didn't know user's spreadsheet column format, had to ask twice
- Repeated the same extraction logic for each invoice manually

### What went well
- Once I found pdfplumber, extraction worked reliably
- User appreciated the validation step before writing

### Decisions
- [x] Create skill for PDF table extraction → skill
- [x] Create invoice-processing agent that handles the full workflow → agent
- [ ] Add spreadsheet column format to CLAUDE.md → claude.md

### Implementation status
- Created `.claude/skills/extracting-pdf-tables/SKILL.md`
- Created `.claude/agents/invoice-processor.md`
```

## When to trigger retros

**Always trigger after:**
- User says "thanks", "done", "that's all for now"
- A multi-step task completes
- You needed 3+ attempts at something
- User explicitly corrected your approach

**Ask before triggering when:**
- Task was trivial (< 2 minutes)
- No friction occurred
- Similar retro was done recently

## Reviewing past retros

Before starting new sessions, check `.claude/retros/log.md` for:
- Pending implementations (unchecked decisions)
- Patterns across multiple retros
- Previously solved problems (don't re-learn)

## Anti-patterns

| Don't do this | Do this instead |
|---------------|-----------------|
| "Everything went smoothly" | Identify at least one improvement opportunity |
| "I should be more careful" | Specify what check or process to add |
| Log without implementing | Complete at least one decision per retro |
| Create skill for one-off task | Only automate recurring patterns |
| Vague decisions like "improve X" | Concrete: "Create skill that does Y" |
