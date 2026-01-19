---
name: error-diagnosis
description: This skill should be used when analyzing tool failures, diagnosing repeated errors, reviewing error logs, or when asked to "analyze errors", "why did that fail", "diagnose the problem", or "review error patterns". Provides systematic error analysis and pattern detection.
version: 1.0.0
---

# Error Diagnosis and Pattern Analysis

Systematically analyze tool failures and errors to identify root causes, patterns, and preventive improvements.

## Error Log Structure

Errors are tracked in `.claude/retros/errors.md`:

```markdown
## YYYY-MM-DD HH:MM: [Tool Name] Failure

### Error Details
- **Tool:** [tool name]
- **Input:** [relevant input parameters]
- **Error:** [error message]
- **Context:** [what was being attempted]

### Analysis
- **Root cause:** [why it failed]
- **Category:** [see categories below]
- **Preventable:** yes/no

### Resolution
- **Fix applied:** [what solved it]
- **Prevention:** [how to avoid in future]
```

## Error Categories

| Category | Description | Typical Prevention |
|----------|-------------|-------------------|
| **Input validation** | Bad parameters, wrong types | Add pre-checks |
| **Missing context** | Lacked necessary information | Ask upfront |
| **Wrong approach** | Incorrect tool/method choice | Add to skill knowledge |
| **External failure** | API/service issues | Add retry logic |
| **Permission denied** | Access restrictions | Document requirements |
| **Resource missing** | File/path doesn't exist | Verify before use |

## Analysis Workflow

### 1. Capture Error Context

When a tool fails, capture:
- Tool name and full input
- Error message and exit code
- What was being attempted
- Prior successful/failed attempts

### 2. Identify Root Cause

Ask:
- Was the input valid for this tool?
- Was the right tool chosen?
- Was necessary context available?
- Is this a recurring pattern?

### 3. Check for Patterns

Search error log for similar failures:
```bash
grep -i "[tool_name]" .claude/retros/errors.md | head -10
```

If same error appears 3+ times → create preventive improvement.

### 4. Determine Prevention

| Pattern | Prevention Type |
|---------|-----------------|
| Same input mistake | Add validation script |
| Wrong tool choice | Add to skill knowledge |
| Missing context | Update CLAUDE.md |
| Complex workflow | Create agent with guards |

## Pattern Detection Queries

Find recurring tool failures:
```bash
grep "^## " .claude/retros/errors.md | cut -d: -f3 | sort | uniq -c | sort -rn
```

Find most common categories:
```bash
grep "Category:" .claude/retros/errors.md | cut -d: -f2 | sort | uniq -c | sort -rn
```

Find preventable errors not yet addressed:
```bash
grep -A5 "Preventable: yes" .claude/retros/errors.md | grep "Prevention: \[how"
```

## Integration with Retros

When errors lead to improvements, link in retro:

```markdown
### Decisions
- [x] Add input validation for Bash commands → script
  - Related errors: 2025-01-15 12:30, 2025-01-14 09:15

### Implementation status
- Created `.claude/scripts/validate-bash-input.sh`
- Error pattern resolved
```

## Additional Resources

### Reference Files

- **`references/common-errors.md`** - Catalog of common errors and solutions
- **`references/error-prevention.md`** - Prevention strategies by error type

### Scripts

- **`${CLAUDE_PLUGIN_ROOT}/scripts/parse-error-log.sh`** - Extract error patterns
- **`${CLAUDE_PLUGIN_ROOT}/scripts/count-errors.sh`** - Summarize error frequencies
