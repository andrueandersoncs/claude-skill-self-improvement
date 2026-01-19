---
name: Cross-Session Learning
description: This skill should be used when encountering an error or issue that may have been seen before, when starting work on a complex task that could benefit from past learnings, when the user asks about "project patterns", "how does this project work", "what have we learned", "past issues", or "previous sessions". Provides guidance on reading and applying learnings stored in .claude/learnings/.
version: 0.1.0
---

# Cross-Session Learning

Enable learning from past sessions by reading and applying stored knowledge from the project's `.claude/learnings/` directory.

## Purpose

This skill teaches how to access and apply learnings accumulated from previous sessions, including:
- Recurring errors and their solutions
- Successful patterns and approaches
- User preferences for this project
- Improvement ideas and pending enhancements
- Useful scripts for common tasks
- Ideas for new agents and skills

## When to Use

Activate this skill when:
- An error occurs that may have been encountered before
- Starting a complex task where past learnings could help
- The user asks about project context or patterns
- Planning an approach that could benefit from historical insight

## Learnings Directory Structure

Project learnings are stored in `.claude/learnings/` with one markdown file per learning:

```
.claude/learnings/
├── errors/           # Recurring errors and solutions
│   └── {error-name}.md
├── patterns/         # Successful approaches
│   └── {pattern-name}.md
├── preferences/      # User preferences
│   └── {preference-name}.md
├── improvements/     # Pending improvement ideas
│   └── {improvement-name}.md
├── scripts/          # Useful reusable scripts
│   └── {script-name}.md
└── extensions/       # Ideas for agents/skills
    └── {extension-name}.md
```

## Reading Learnings

### Check for Relevant Learnings

Before starting work, check if relevant learnings exist:

```bash
# List all learnings
ls -la .claude/learnings/*/

# Check specific category
ls .claude/learnings/errors/
```

### Search for Relevant Content

Use grep to find learnings matching the current context:

```bash
# Search for learnings related to a specific topic
grep -r "TypeScript" .claude/learnings/
grep -r "async" .claude/learnings/errors/
```

### Read Specific Learnings

When a relevant learning is found, read its full content to apply the knowledge.

## Learning File Format

Each learning file follows a structured markdown format:

```markdown
---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
source_session: retros/YYYY-MM-DD-HHmm.md
tags: [tag1, tag2]
---

# {Learning Title}

## Context
When this learning applies and how it was discovered.

## Key Insight
The core takeaway or solution.

## Application
How to apply this learning in practice.

## Related
Links to related learnings or external resources.
```

## Applying Learnings

### For Errors

When encountering an error:
1. Search `.claude/learnings/errors/` for similar errors
2. If found, read the solution and apply it
3. If not found, solve the error and consider creating a new learning

### For Patterns

When implementing a feature:
1. Check `.claude/learnings/patterns/` for relevant approaches
2. Apply successful patterns from past sessions
3. Adapt patterns to current context

### For Preferences

Before making style or approach decisions:
1. Check `.claude/learnings/preferences/` for user preferences
2. Follow established preferences unless explicitly overridden

### For Scripts

When performing repetitive tasks:
1. Check `.claude/learnings/scripts/` for existing utilities
2. Use existing scripts instead of rewriting
3. Store new useful scripts for future sessions

## Creating New Learnings

When a new insight emerges during a session:

1. Determine the category (errors, patterns, preferences, improvements, scripts, extensions)
2. Create a descriptive kebab-case filename
3. Follow the learning file format
4. Include source context from the current session

Example creation:
```bash
# Create new error learning
mkdir -p .claude/learnings/errors
```

Then write a learning file with the standard format.

## Best Practices

### Efficient Discovery
- Start with targeted searches rather than reading everything
- Use grep to filter by keywords before reading full files
- Check the most relevant category first

### Maintaining Quality
- Learnings should be actionable, not just observations
- Include enough context to understand when to apply
- Keep learnings focused - one insight per file
- Update existing learnings rather than creating duplicates

### Cross-Referencing
- Reference related learnings in the "Related" section
- Link to source retrospectives for full context
- Tag learnings for easier discovery

## Integration with Retrospectives

Learnings are extracted from session retrospectives stored in `.claude/retros/`. When reviewing learnings:
- Check the `source_session` frontmatter to find the original context
- Read the source retrospective for additional detail if needed

## Additional Resources

### Reference Files

For detailed category-specific guidance:
- **`references/category-formats.md`** - Detailed format for each learning category
