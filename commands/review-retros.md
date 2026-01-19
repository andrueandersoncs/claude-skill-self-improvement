---
description: Analyze patterns across retrospective history
allowed-tools: Read, Grep, Glob, Bash
argument-hint: [days|all]
---

Analyze retrospective and error logs to identify patterns and pending work.

## Analysis Scope

If $ARGUMENTS is "all" or empty, analyze entire history.
If $ARGUMENTS is a number, analyze last N days.

## Step 1: Check Pending Decisions

Find uncompleted improvement decisions:
```bash
grep -n "^\- \[ \]" .claude/retros/log.md 2>/dev/null || echo "No pending decisions"
```

List each pending decision with its date and context.

## Step 2: Identify Recurring Issues

Find "What went wrong" themes that appear multiple times:
```bash
grep -h "What went wrong" -A5 .claude/retros/log.md 2>/dev/null | grep "^-" | sort | uniq -c | sort -rn | head -10
```

Highlight any issue appearing 3+ times as a priority for improvement.

## Step 3: Review Error Patterns

Check error log for recurring failures:
```bash
grep "^\*\*Tool:\*\*" .claude/retros/errors.md 2>/dev/null | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn | head -5
```

```bash
grep "^\*\*Category:\*\*" .claude/retros/errors.md 2>/dev/null | cut -d: -f2 | sort | uniq -c | sort -rn | head -5
```

## Step 4: Track Improvement Effectiveness

List existing improvements:
```bash
echo "=== Skills ===" && ls .claude/skills/*/SKILL.md 2>/dev/null || echo "None"
echo "=== Agents ===" && ls .claude/agents/*.md 2>/dev/null || echo "None"
echo "=== Scripts ===" && ls .claude/scripts/*.sh 2>/dev/null || echo "None"
```

Check if improvements addressed their target issues (any recurrence after creation).

## Step 5: Generate Summary Report

Produce a structured report:

```markdown
# Retrospective Analysis Report

## Pending Decisions
[List all uncompleted decisions with dates]

## Recurring Issues (Priority)
[Issues appearing 3+ times that need improvement]

## Error Patterns
[Most common error categories and tools]

## Existing Improvements
- Skills: [count]
- Agents: [count]
- Scripts: [count]

## Recommendations
1. [Most urgent pending decision]
2. [Recurring issue to address]
3. [Error pattern to prevent]
```

## Step 6: Suggest Next Actions

Based on the analysis, recommend:
1. Which pending decision to implement first
2. What recurring issue most needs a skill/agent
3. What error pattern needs prevention

Ask if the user wants to implement any of these improvements now.
