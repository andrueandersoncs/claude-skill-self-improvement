---
description: Browse and search past retrospectives and learnings
argument-hint: [category|search-term]
allowed-tools: Read, Grep, Glob, Bash
---

Review past retrospectives and learnings stored in `.claude/`.

**Argument:** $ARGUMENTS

**Interpret argument as:**
- **Category name** (errors, patterns, preferences, improvements, scripts, extensions): List all learnings in that category
- **Search term**: Search across all learnings for matching content
- **Date** (YYYY-MM-DD): Show retrospectives from that date
- **Empty**: Show summary of all available learnings

**Process:**

1. Determine argument type (category, search term, date, or empty)

2. For **category**:
   - List all files in `.claude/learnings/{category}/`
   - Show brief summary of each learning

3. For **search term**:
   - Search across `.claude/learnings/` and `.claude/retros/` for matching content
   - Show matching files with context

4. For **date**:
   - Find retrospectives matching that date in `.claude/retros/`
   - Show full retrospective content

5. For **empty/summary**:
   - Count learnings in each category
   - List recent retrospectives (last 5)
   - Show overall learning statistics

**Output Format:**

Present findings in an organized, scannable format:
- Use headers for categories
- Show file counts and dates
- Provide brief excerpts for context
- Suggest related learnings when appropriate
