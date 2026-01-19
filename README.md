# Claude Self-Improvement Plugin

A Claude Code plugin that enables session introspection and cross-session learning. Claude automatically captures learnings at the end of each session and applies them in future sessions.

## Features

- **Automatic Retrospectives**: Session end hook triggers analysis of errors, patterns, and insights
- **Cross-Session Learning**: Learnings persist in `.claude/learnings/` for future sessions
- **Proactive Context Loading**: Session start hook notifies Claude of available learnings
- **Manual Controls**: Commands for on-demand retrospectives and learning review

## Installation

```bash
# Install via plugin directory
claude --plugin-dir /path/to/claude-self-improvement

# Or copy to your project
cp -r claude-self-improvement /your/project/.claude-plugin/
```

## Commands

### /retro [focus-area]

Run a retrospective analysis on the current session.

```
/retro              # Analyze all aspects
/retro errors       # Focus on errors encountered
/retro patterns     # Focus on successful patterns
```

### /review-retros [category|search-term]

Browse and search past retrospectives and learnings.

```
/review-retros              # Show summary of all learnings
/review-retros errors       # List all error learnings
/review-retros typescript   # Search for "typescript" across learnings
/review-retros 2024-01-15   # Show retrospectives from that date
```

## How It Works

### Session Start

The `SessionStart` hook runs `load-context.sh` which:
1. Checks if `.claude/learnings/` exists
2. Counts learnings in each category
3. Outputs a brief notification to Claude about available learnings

Example output:
```
[Self-Improvement Context]
This project has 12 learnings from previous sessions at .claude/learnings/
Categories: errors(3) patterns(4) preferences(2) improvements(1) scripts(1) extensions(1)
Use the cross-session-learning skill when encountering errors or needing project context.
```

### Session End

The `Stop` hook triggers the `retro-analyzer` agent which:
1. Analyzes the session for valuable insights
2. Categorizes findings into learning types
3. Writes retrospective to `.claude/retros/`
4. Writes individual learnings to `.claude/learnings/{category}/`

### During Session

The `cross-session-learning` skill activates when Claude:
- Encounters an error that may have been seen before
- Starts a complex task that could benefit from past learnings
- Hears keywords like "project patterns", "past issues", "previous sessions"

## Directory Structure

Learnings are stored in your project's `.claude/` directory:

```
.claude/
├── retros/                      # Session retrospectives
│   └── 2024-01-15-1423.md
└── learnings/
    ├── errors/                  # Recurring errors + solutions
    │   └── typescript-strict-null-checks.md
    ├── patterns/                # Successful approaches
    │   └── effect-error-handling.md
    ├── preferences/             # User preferences
    │   └── testing-approach.md
    ├── improvements/            # Improvement ideas queue
    │   └── add-retry-logic.md
    ├── scripts/                 # Useful reusable scripts
    │   └── find-unused-exports.md
    └── extensions/              # Agent/skill ideas
        └── agent-test-generator.md
```

## Learning Categories

| Category | Purpose | Example |
|----------|---------|---------|
| **errors** | Recurring errors and their solutions | TypeScript strict mode issues |
| **patterns** | Successful approaches to repeat | Effect-TS error handling pattern |
| **preferences** | User's expressed preferences | Prefers bun over jest |
| **improvements** | Ideas for future enhancements | Add retry logic to API calls |
| **scripts** | Useful scripts to preserve | Find unused exports |
| **extensions** | Ideas for new agents/skills | Test generator agent |

## Learning File Format

Each learning follows a structured format:

```markdown
---
created: 2024-01-15
last_updated: 2024-01-15
source_session: retros/2024-01-15-1423.md
tags: [typescript, error, strict-mode]
---

# TypeScript Strict Null Checks

## Context
When this applies and how it was discovered.

## Key Insight
The core solution or takeaway.

## Application
How to apply this in practice.

## Related
Links to related learnings.
```

## Components

| Component | Type | Purpose |
|-----------|------|---------|
| `cross-session-learning` | Skill | How to read and apply stored learnings |
| `retro-analyzer` | Agent | Analyzes sessions and extracts learnings |
| `/retro` | Command | Manual retrospective |
| `/review-retros` | Command | Browse past learnings |
| `SessionStart` hook | Hook | Load context notification |
| `Stop` hook | Hook | Trigger automatic retrospective |

## Configuration

No configuration required. Learnings are stored in your project's `.claude/` directory automatically.

## License

MIT
