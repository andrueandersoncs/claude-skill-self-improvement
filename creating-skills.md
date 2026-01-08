# Creating Skills

Reference for implementing new skills as part of self-improvement.

## Skill file structure

```
.claude/skills/[skill-name]/
├── SKILL.md           # Required: main skill file
├── reference.md       # Optional: detailed docs
└── scripts/           # Optional: utility scripts
    └── helper.py
```

## SKILL.md template

```yaml
---
name: [skill-name]
description: [What it does]. Use when [trigger conditions].
---

# [Skill Title]

## When to use
[Specific scenarios this skill applies to]

## How to [main action]

[Step-by-step instructions or key information]

## Examples

**Input:** [example input]
**Output:** [example output]

## Common mistakes
- [Mistake to avoid]
```

## Naming rules

- Use gerund form: `extracting-pdfs`, `validating-forms`
- Max 64 characters
- Lowercase, hyphens only
- Avoid: `helper`, `utils`, `tools`

## Description requirements

Must include BOTH:
1. What it does (third person)
2. When to use it (trigger terms)

**Good:** "Extracts tables from PDF files. Use when working with PDFs, invoices, or document parsing."

**Bad:** "Helps with documents"

## When to create a skill vs other options

| Situation | Create |
|-----------|--------|
| Need domain knowledge in context | Skill |
| Need to delegate multi-step work | Subagent |
| Need external data/API | MCP |
| Project-specific one-liner | CLAUDE.md |
