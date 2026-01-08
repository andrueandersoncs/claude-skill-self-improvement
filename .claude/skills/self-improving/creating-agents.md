# Creating Subagents

Reference for implementing new subagents as part of self-improvement.

## Agent file location

```
.claude/agents/[agent-name].md    # Project-level
~/.claude/agents/[agent-name].md  # User-level (all projects)
```

## Agent template

```markdown
---
name: [agent-name]
description: [What it does]. Use [when/how often].
tools: [tool1], [tool2]  # Optional: omit to inherit all tools
model: sonnet  # Optional: sonnet, opus, haiku, or inherit
---

You are a [role] specializing in [domain].

## When invoked

1. [First step]
2. [Second step]
3. [Continue until done]

## Your approach

- [Key behavior 1]
- [Key behavior 2]

## Output format

[What to return to the main conversation]
```

## Configuration fields

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | lowercase, hyphens |
| `description` | Yes | Include "use proactively" if auto-trigger desired |
| `tools` | No | Comma-separated; omit = inherit all |
| `model` | No | Default: sonnet |

## Common tool sets

**Read-only exploration:**
```yaml
tools: Read, Grep, Glob, Bash
```

**Code modification:**
```yaml
tools: Read, Edit, Write, Bash, Grep, Glob
```

**Full access:**
```yaml
# Omit tools field entirely
```

## When to create an agent vs skill

| Need | Create |
|------|--------|
| Separate context for complex work | Agent |
| Knowledge/guidance in main context | Skill |
| Repetitive multi-step workflow | Agent |
| Reference information | Skill |

## Triggering agents

**Automatic:** Include "use proactively" in description
```yaml
description: Reviews code for security issues. Use proactively after code changes.
```

**Explicit:** User or Claude invokes by name
```
> Use the code-reviewer agent to check my changes
```

## Example: Test runner agent

```markdown
---
name: test-runner
description: Runs tests and fixes failures. Use proactively after code changes.
tools: Read, Edit, Bash, Grep, Glob
---

You are a test automation specialist.

## When invoked

1. Run the project's test suite
2. If tests fail, analyze the failure
3. Fix the failing code (not the test, unless test is wrong)
4. Re-run to verify fix
5. Report what was fixed

## Your approach

- Preserve original test intent
- Make minimal fixes
- Run tests after each fix to verify

## Output format

Return a summary:
- Tests run: [count]
- Passed: [count]
- Fixed: [list of fixes made]
```
