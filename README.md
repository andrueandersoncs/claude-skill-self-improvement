# Claude Code Self-Improvement Kit

A starter kit for enabling Claude Code to systematically improve itself through reflection, retrospectives, and automated implementation of new skills and subagents.

## What's Included

### Skills

**`self-improving`** - Enables Claude to conduct self-reflection after tasks, identify friction points, and implement concrete improvements:
- Maintains a persistent retro log at `.claude/retros/log.md`
- Categorizes gaps (missing knowledge → skill, repetitive workflow → agent, external data → MCP)
- Provides templates and guidance for implementing improvements

**`claude-skill-authoring-skill`** (submodule) - Guides creation of effective Claude skills with proper structure, naming conventions, and progressive disclosure patterns.

### Reference Documentation

- `SKILLS.md` - Complete guide to creating and managing Claude Code skills
- `SUBAGENTS.md` - Guide to creating custom subagents
- `HOOKS.md` - Documentation for Claude Code hooks system
- `MCP.md` - Model Context Protocol server configuration
- `OUTPUT_STYLES.md` - Output formatting options

## Installation

Clone the repository with submodules:

```bash
git clone --recursive git@github.com:andrueandersoncs/claude-skill-self-improvement.git
```

Or if already cloned:

```bash
git submodule update --init --recursive
```

## Usage

### Triggering Retrospectives

The self-improving skill activates automatically when:
- You complete a significant task
- You say "thanks", "done", or "that's all for now"
- Claude needed 3+ attempts at something
- You explicitly ask Claude to reflect

Or invoke it manually:

```
/self-improving
```

### How It Works

1. **Reflect** - Claude identifies friction points: multiple attempts, user corrections, missing context, repetitive steps
2. **Categorize** - Determines the type of gap and appropriate solution
3. **Log** - Records the retrospective in `.claude/retros/log.md`
4. **Implement** - Creates the skill, agent, MCP config, or CLAUDE.md update

### Example Retro Entry

```markdown
## 2025-01-08: PDF form filling task

### Context
- User asked me to extract data from invoices and fill a spreadsheet
- Goal: automate monthly invoice processing

### What went wrong
- Tried using PyPDF2 first, which couldn't extract tables
- Didn't know user's spreadsheet column format, had to ask twice

### What went well
- Once I found pdfplumber, extraction worked reliably

### Decisions
- [x] Create skill for PDF table extraction → skill
- [x] Create invoice-processing agent → agent

### Implementation status
- Created `.claude/skills/extracting-pdf-tables/SKILL.md`
- Created `.claude/agents/invoice-processor.md`
```

## Project Structure

```
.claude/
├── retros/
│   └── log.md              # Persistent retrospective log
└── skills/
    ├── self-improving/     # Self-reflection skill
    │   ├── SKILL.md
    │   ├── creating-skills.md
    │   └── creating-agents.md
    └── claude-skill-authoring-skill/  # Skill authoring guide (submodule)
```

## Gap Types and Solutions

| Gap Type | Solution |
|----------|----------|
| Missing domain knowledge | Create a skill |
| Repetitive multi-step workflow | Create a subagent |
| Missing external data/tools | Add an MCP server |
| Project-specific patterns | Update CLAUDE.md |
| Reusable script needed | Create script in `.claude/scripts/` |

## License

MIT
