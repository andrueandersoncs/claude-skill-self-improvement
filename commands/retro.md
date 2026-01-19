---
description: Run a retrospective analysis on the current session
argument-hint: [focus-area]
allowed-tools: Read, Write, Grep, Glob, Bash
---

Perform a retrospective analysis of this session to capture learnings.

**Focus Area:** $ARGUMENTS

If a focus area is specified (errors, patterns, preferences, improvements, scripts, extensions), concentrate analysis on that category. Otherwise, analyze all aspects.

**Process:**

1. Review what was accomplished in this session
2. Identify errors encountered and how they were resolved
3. Note successful patterns and approaches used
4. Observe any user preferences expressed or implied
5. Look for improvements that could be made
6. Identify useful scripts created
7. Consider ideas for new agents or skills

**Storage:**

Create necessary directories and files in `.claude/`:
- Write retrospective to `.claude/retros/` with timestamp filename
- Write individual learnings to `.claude/learnings/{category}/` subdirectories
- Use one markdown file per learning with descriptive kebab-case filenames

**Before writing:**
- Check existing learnings to avoid duplicates
- Update existing learnings rather than creating new duplicates

**Output:**
Summarize what was captured and where files were written.
