# Pattern Detection Queries

Advanced queries for analyzing retro and error logs.

## Retro Log Analysis

### Find Recurring "What Went Wrong" Themes

```bash
grep -h "What went wrong" -A5 .claude/retros/log.md | \
  grep "^-" | \
  sed 's/^- //' | \
  sort | uniq -c | sort -rn | head -10
```

### Count Retros by Month

```bash
grep "^## [0-9]" .claude/retros/log.md | \
  cut -d- -f1-2 | \
  sort | uniq -c
```

### Find Pending Decisions

```bash
grep "^\- \[ \]" .claude/retros/log.md
```

### Find Completed Decisions

```bash
grep "^\- \[x\]" .claude/retros/log.md
```

### List Decisions by Implementation Type

```bash
grep "^\- \[" .claude/retros/log.md | \
  grep -oE "→ [a-z.]+" | \
  sort | uniq -c | sort -rn
```

### Find Retros Without Implementations

```bash
awk '/^## [0-9]/{title=$0} /Implementation status/{getline; if(/pending/){print title}}' \
  .claude/retros/log.md
```

---

## Error Log Analysis

### Most Common Error Tools

```bash
grep "^\*\*Tool:\*\*" .claude/retros/errors.md | \
  cut -d: -f2 | \
  tr -d ' ' | \
  sort | uniq -c | sort -rn
```

### Error Categories Distribution

```bash
grep "^\*\*Category:\*\*" .claude/retros/errors.md | \
  cut -d: -f2 | \
  sort | uniq -c | sort -rn
```

### Find Preventable Errors Not Yet Addressed

```bash
awk '/Preventable: yes/{found=1} found && /Prevention:/{if(/\[how/){print prev} found=0} {prev=$0}' \
  .claude/retros/errors.md
```

### Errors by Date

```bash
grep "^## [0-9]" .claude/retros/errors.md | \
  cut -d: -f1 | \
  cut -c4- | \
  sort | uniq -c
```

### Recent Error Streak

```bash
tail -100 .claude/retros/errors.md | \
  grep "^## " | \
  wc -l
```

---

## Cross-Log Analysis

### Correlation: Errors Leading to Retro Decisions

```bash
# Find dates with both errors and retro entries
comm -12 \
  <(grep "^## [0-9]" .claude/retros/errors.md | cut -d: -f1 | cut -c4- | sort -u) \
  <(grep "^## [0-9]" .claude/retros/log.md | cut -d: -f1 | cut -c4- | sort -u)
```

### Find Improvements That Reduced Errors

```bash
# List tools with decreasing error frequency over time
# (Requires sufficient data)
awk '/^## [0-9]/{date=substr($2,1,7)} /Tool:/{tool=$2; count[date,tool]++}
  END{for(k in count) print k, count[k]}' .claude/retros/errors.md | \
  sort
```

---

## Improvement Tracking

### Skills Created

```bash
ls -la .claude/skills/*/SKILL.md 2>/dev/null | wc -l
```

### Agents Created

```bash
ls -la .claude/agents/*.md 2>/dev/null | wc -l
```

### Scripts Created

```bash
ls -la .claude/scripts/*.sh 2>/dev/null | wc -l
```

### Improvements by Type

```bash
echo "Skills: $(ls .claude/skills/*/SKILL.md 2>/dev/null | wc -l)"
echo "Agents: $(ls .claude/agents/*.md 2>/dev/null | wc -l)"
echo "Scripts: $(ls .claude/scripts/*.sh 2>/dev/null | wc -l)"
```

---

## Weekly Summary Generation

```bash
#!/usr/bin/env bash
set -euo pipefail

WEEK_START=$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d "7 days ago" +%Y-%m-%d)

echo "## Week of $WEEK_START"
echo ""
echo "### Retros This Week"
grep "^## $WEEK_START\|^## $(date +%Y-%m)" .claude/retros/log.md 2>/dev/null | wc -l | xargs echo "Count:"
echo ""
echo "### Errors This Week"
grep "^## $WEEK_START\|^## $(date +%Y-%m)" .claude/retros/errors.md 2>/dev/null | wc -l | xargs echo "Count:"
echo ""
echo "### Pending Decisions"
grep "^\- \[ \]" .claude/retros/log.md
echo ""
echo "### Top Error Categories"
grep "Category:" .claude/retros/errors.md | cut -d: -f2 | sort | uniq -c | sort -rn | head -3
```

---

## Trend Analysis

### Retros Per Week (Last 4 Weeks)

```bash
for i in 0 1 2 3; do
  week_start=$(date -v-${i}w -v-sun +%Y-%m-%d 2>/dev/null || date -d "$i weeks ago" +%Y-%m-%d)
  count=$(grep "^## $week_start" .claude/retros/log.md 2>/dev/null | wc -l)
  echo "$week_start: $count retros"
done
```

### Error Rate Trend

```bash
# Errors per 10 retros (rolling)
total_retros=$(grep "^## [0-9]" .claude/retros/log.md | wc -l)
total_errors=$(grep "^## [0-9]" .claude/retros/errors.md | wc -l)
if [ $total_retros -gt 0 ]; then
  rate=$(echo "scale=2; $total_errors * 10 / $total_retros" | bc)
  echo "Error rate: $rate errors per 10 retros"
fi
```

---

## Useful One-Liners

```bash
# Most recent retro title
grep "^## [0-9]" .claude/retros/log.md | tail -1

# Count of all logged items
wc -l .claude/retros/*.md

# Find retros mentioning specific topic
grep -l "API" .claude/retros/log.md && grep -B2 -A10 "API" .claude/retros/log.md

# Export retro titles to list
grep "^## [0-9]" .claude/retros/log.md | cut -c5-

# Find related errors and retros on same day
DATE="2025-01-15"
echo "=== Retros ===" && grep -A20 "^## $DATE" .claude/retros/log.md
echo "=== Errors ===" && grep -A10 "^## $DATE" .claude/retros/errors.md
```
