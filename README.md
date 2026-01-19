# Claude Self-Improvement Plugin

A comprehensive Claude Code plugin that enables systematic self-improvement through reflection, error tracking, cross-session learning, and autonomous implementation of skills, agents, and scripts.

## Features

### 🔄 Structured Retrospectives
- Conduct post-task reflections to identify friction points
- Log learnings persistently at `.claude/retros/log.md`
- Categorize gaps and map to appropriate solutions

### 🔍 Error Tracking & Diagnosis
- Automatic error logging via PostToolUse hooks
- Pattern detection across tool failures
- Root cause analysis and prevention strategies

### 📊 Cross-Session Learning
- Analyze patterns across multiple retrospectives
- Track improvement effectiveness over time
- Generate weekly summary reports

### 🤖 Autonomous Improvement
- Agents that create skills, agents, and scripts automatically
- Scaffold templates for rapid improvement creation
- Proactive triggers for reflection at session boundaries

## Installation

### As a Plugin

```bash
# Clone the repository
git clone git@github.com:andrueandersoncs/claude-self-improvement.git

# Install as plugin
claude plugin add ./claude-self-improvement

# Or test locally
cc --plugin-dir ./claude-self-improvement
```

### Plugin Structure

```
claude-self-improvement/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── skills/
│   ├── self-improving/       # Core reflection skill
│   ├── error-diagnosis/      # Error analysis skill
│   └── cross-session-learning/ # Pattern detection skill
├── commands/
│   ├── retro.md              # /retro - Manual reflection
│   ├── review-retros.md      # /review-retros - Pattern analysis
│   └── implement-pending.md  # /implement-pending - Create improvements
├── agents/
│   ├── retro-analyzer.md     # Analyzes retro history
│   └── improvement-implementer.md # Creates improvements autonomously
├── hooks/
│   ├── hooks.json            # Hook configuration
│   └── scripts/              # Hook scripts
└── scripts/                  # Utility scripts
```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `/retro [title]` | Conduct a retrospective on the current session |
| `/review-retros [days\|all]` | Analyze patterns across retro history |
| `/implement-pending [type\|all]` | Implement pending improvement decisions |

### Automatic Triggers

The plugin automatically suggests reflection when:
- **SessionEnd**: Prompts for retro if friction occurred
- **Stop**: Suggests capturing learnings after significant tasks
- **PostToolUse**: Logs errors for later analysis

### Skills

Skills activate automatically based on context:

- **self-improving**: Triggers on "thanks", "done", "reflect", or after difficulties
- **error-diagnosis**: Triggers when analyzing failures or error patterns
- **cross-session-learning**: Triggers when reviewing history or starting sessions

### Agents

Agents can be invoked via the Task tool:

- **retro-analyzer**: Deep analysis of retrospective patterns
- **improvement-implementer**: Autonomous creation of improvements

## How It Works

### 1. Reflection Workflow

```
Task Completion → Identify Friction → Categorize Gap → Log Retro → Implement Improvement
```

### 2. Gap Categories

| Gap Type | Solution | Location |
|----------|----------|----------|
| Missing knowledge | Create skill | `.claude/skills/` |
| Repetitive workflow | Create agent | `.claude/agents/` |
| Missing external data | Add MCP server | `claude mcp add` |
| Project patterns | Update memory | `CLAUDE.md` |
| Repeated commands | Create script | `.claude/scripts/` |

### 3. Error Tracking

Errors are automatically logged to `.claude/retros/errors.md`:
- Tool name and input
- Error message and category
- Resolution status
- Prevention recommendations

### 4. Cross-Session Learning

The plugin maintains awareness across sessions:
- Loads pending decisions at session start
- Detects recurring issues (3+ occurrences)
- Tracks improvement effectiveness

## Example Retro Entry

```markdown
## 2025-01-15: API Integration Task

### Context
- User needed to integrate Stripe payment processing
- Goal: implement checkout flow with webhooks

### What went wrong
- Forgot idempotency keys initially
- Webhook signature verification failed (raw body issue)
- Had to look up Stripe docs multiple times

### What went well
- Test mode made iteration safe
- Comprehensive error handling appreciated

### Decisions
- [x] Create Stripe integration skill → skill
- [x] Create webhook testing script → script
- [ ] Add API keys to env template → claude.md

### Implementation status
- Created `.claude/skills/integrating-stripe/SKILL.md`
- Created `.claude/scripts/test-stripe-webhook.sh`
```

## Utility Scripts

| Script | Purpose |
|--------|---------|
| `parse-retro-log.sh` | Extract and summarize retro information |
| `parse-error-log.sh` | Analyze error patterns |
| `scaffold-improvement.sh` | Generate improvement templates |
| `generate-weekly-summary.sh` | Create weekly learning reports |

## Reference Documentation

The `skills/*/references/` directories contain detailed documentation:
- Improvement type guides
- Real-world examples
- Pattern detection queries
- Common error solutions

## Configuration

### Hooks

Hooks are configured in `hooks/hooks.json`:
- **SessionEnd**: Prompt for retro
- **PostToolUse**: Log errors
- **Stop**: Suggest reflection
- **SessionStart**: Load context

### Customization

Edit hook configurations to adjust:
- Trigger sensitivity
- Error categories
- Prompt content
- Timeout values

## License

MIT
