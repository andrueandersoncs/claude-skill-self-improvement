---
name: cross-session-learning
description: This skill should be used when reviewing patterns across multiple sessions, asked to "analyze past retros", "what patterns do you see", "review learning history", "check past sessions", or when starting a new session to load prior learnings. Provides cross-session pattern detection and knowledge synthesis.
version: 1.0.0
---

# Cross-Session Learning and Pattern Detection

Analyze retrospective history to identify recurring patterns, track improvement effectiveness, and ensure learnings persist across sessions.

## Session Start Checklist

At the beginning of each session, review:

### 1. Pending Implementations

```bash
grep -A2 "^\- \[ \]" .claude/retros/log.md
```

Address uncompleted decisions before starting new work.

### 2. Recent Patterns

Check last 5 retros for recurring themes:
```bash
tail -200 .claude/retros/log.md | grep "### What went wrong" -A3
```

### 3. Error Trends

Review recent errors:
```bash
tail -50 .claude/retros/errors.md | grep "^## " | tail -5
```

### 4. Existing Resources

Before creating new improvements, check what exists:
- `.claude/skills/` - existing skills
- `.claude/agents/` - existing agents
- `.claude/scripts/README.md` - script catalog

## Pattern Detection

### Identifying Recurring Issues

An issue is recurring if it appears in 3+ retros. Search for:

```bash
# Find repeated "What went wrong" themes
grep -h "What went wrong" -A5 .claude/retros/log.md | \
  grep "^-" | sort | uniq -c | sort -rn | head -10
```

### Tracking Improvement Effectiveness

After implementing an improvement, track if the problem recurs:

```markdown
## Improvement Tracking

| Improvement | Created | Problem Recurred? | Notes |
|-------------|---------|-------------------|-------|
| pdf-extraction skill | 2025-01-08 | No | Working well |
| validate-input script | 2025-01-10 | Yes (1x) | Needs refinement |
```

Maintain this in `.claude/retros/improvements.md`.

### Pattern Categories

| Pattern Type | Indicator | Action |
|--------------|-----------|--------|
| **Knowledge gap** | Same question asked 3+ times | Create skill |
| **Workflow friction** | Same multi-step process repeated | Create agent |
| **Tool misuse** | Same tool error repeated | Add to skill or script |
| **Context missing** | Same info requested repeatedly | Update CLAUDE.md |
| **Script gap** | Same commands typed repeatedly | Create script |

## Synthesis Reports

### Weekly Summary

Generate a weekly learning summary:

```markdown
## Week of YYYY-MM-DD

### Retros Completed: N

### Top Issues
1. [Most common friction point]
2. [Second most common]
3. [Third most common]

### Improvements Made
- [x] [Improvement 1]
- [x] [Improvement 2]

### Pending
- [ ] [Still needs implementation]

### Patterns to Watch
- [Emerging pattern not yet addressed]
```

### Improvement ROI

Track which improvements provide most value:

| Improvement | Times Useful | Errors Prevented | Worth It? |
|-------------|--------------|------------------|-----------|
| pdf-skill | 12 | 8 | Yes |
| validate.sh | 3 | 2 | Yes |
| temp-agent | 1 | 0 | Remove |

Remove low-value improvements to reduce complexity.

## Cross-Session Memory

### What to Remember

Persist across sessions in CLAUDE.md:
- User preferences discovered through corrections
- Project-specific patterns
- Tool combinations that work well
- Common gotchas for this codebase

### What NOT to Persist

Avoid cluttering memory with:
- One-time decisions
- Temporary workarounds
- Session-specific context

## Additional Resources

### Reference Files

- **`references/pattern-queries.md`** - Advanced grep/awk queries for pattern detection
- **`references/synthesis-templates.md`** - Templates for summary reports

### Scripts

- **`${CLAUDE_PLUGIN_ROOT}/scripts/generate-weekly-summary.sh`** - Create weekly learning report
- **`${CLAUDE_PLUGIN_ROOT}/scripts/find-recurring-issues.sh`** - Detect patterns across retros
- **`${CLAUDE_PLUGIN_ROOT}/scripts/track-improvement-usage.sh`** - Monitor improvement effectiveness
