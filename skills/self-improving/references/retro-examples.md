# Retrospective Examples

Real-world examples of effective retrospective entries.

## Example 1: PDF Processing Task

```markdown
## 2025-01-08: PDF form filling task

### Context
- User asked me to extract data from invoices and fill a spreadsheet
- Goal: automate monthly invoice processing

### What went wrong
- Tried using PyPDF2 first, which couldn't extract tables
- Didn't know user's spreadsheet column format, had to ask twice
- Repeated the same extraction logic for each invoice manually

### What went well
- Once I found pdfplumber, extraction worked reliably
- User appreciated the validation step before writing

### Decisions
- [x] Create skill for PDF table extraction → skill
- [x] Create invoice-processing agent that handles the full workflow → agent
- [ ] Add spreadsheet column format to CLAUDE.md → claude.md

### Implementation status
- Created `.claude/skills/extracting-pdf-tables/SKILL.md`
- Created `.claude/agents/invoice-processor.md`
```

**Why this is good:**
- Specific about what failed and why
- Identifies root causes (wrong library, missing context)
- Concrete decisions with implementation types
- Tracks completion status

---

## Example 2: Build System Issues

```markdown
## 2025-01-10: React build optimization

### Context
- User reported slow build times in their React app
- Goal: reduce build time from 45s to under 20s

### What went wrong
- Initially suggested generic optimizations without profiling
- User had to correct me that they use Vite, not webpack
- Spent time on irrelevant webpack configurations

### What went well
- After understanding the stack, found the bottleneck (large dependencies)
- Dynamic imports reduced bundle by 40%

### Decisions
- [x] Add build tool detection step to performance workflow → skill
- [ ] Update CLAUDE.md with project's build tooling → claude.md

### Implementation status
- Created `.claude/skills/optimizing-builds/SKILL.md` with detection step
```

**Why this is good:**
- Honest about the wrong approach taken
- Links user correction to improvement
- Creates preventive measure (detection step)

---

## Example 3: API Integration

```markdown
## 2025-01-12: Stripe integration

### Context
- User wanted to add Stripe payment processing
- Goal: implement checkout flow with webhook handling

### What went wrong
- Forgot to handle idempotency keys, causing duplicate charges in testing
- Webhook signature verification failed initially due to raw body parsing
- Had to look up Stripe API docs multiple times

### What went well
- Test mode made iteration safe
- User liked the comprehensive error handling

### Decisions
- [x] Create Stripe integration skill with common gotchas → skill
- [x] Create script for webhook testing → script
- [ ] Add Stripe test keys to project env template → claude.md

### Implementation status
- Created `.claude/skills/integrating-stripe/SKILL.md`
- Created `.claude/scripts/test-stripe-webhook.sh`
```

**Why this is good:**
- Documents specific technical gotchas
- Creates both knowledge (skill) and tooling (script)
- Captures learnings for future integrations

---

## Example 4: Database Migration

```markdown
## 2025-01-14: PostgreSQL schema migration

### Context
- User needed to add new columns to production database
- Goal: zero-downtime migration

### What went wrong
- Initial migration would lock table for too long
- Didn't consider that NOT NULL requires default
- Had to ask about current data volume

### What went well
- Batched approach worked without locking
- Rollback script was never needed but gave user confidence

### Decisions
- [x] Create migration checklist skill → skill
- [x] Create migration template script → script
- [x] Create migration-runner agent → agent

### Implementation status
- Created `.claude/skills/running-migrations/SKILL.md`
- Created `.claude/scripts/run-migration.sh`
- Created `.claude/agents/migration-runner.md`
```

**Why this is good:**
- Full implementation chain (skill + script + agent)
- Addresses both knowledge and automation
- Comprehensive improvement coverage

---

## Anti-pattern Examples

### Too Vague

```markdown
## 2025-01-15: Various tasks

### What went wrong
- Some things didn't work the first time

### Decisions
- [ ] Be more careful next time
```

**Problems:** No specifics, no actionable improvements

### No Implementation

```markdown
## 2025-01-16: API work

### What went wrong
- Rate limiting caused failures
- Had to retry requests manually

### Decisions
- [ ] Handle rate limiting better → skill
- [ ] Add retry logic → script

### Implementation status
- pending
- pending
```

**Problems:** Decisions logged but never implemented

### Over-engineering

```markdown
## 2025-01-17: Simple typo fix

### Context
- Fixed a typo in README

### Decisions
- [ ] Create spell-checking skill → skill
- [ ] Create spell-checking agent → agent
- [ ] Add pre-commit spell check hook → hook

### Implementation status
- pending
```

**Problems:** Massive overkill for one-off task

---

## Template for New Entries

```markdown
## YYYY-MM-DD: [Brief descriptive title]

### Context
- [1-2 sentences about the task]
- [User's goal]

### What went wrong
- [Specific failure or inefficiency]
- [Root cause]

### What went well
- [Success worth repeating]

### Decisions
- [ ] [Concrete action] → [skill/agent/script/mcp/claude.md]

### Implementation status
- [Link or "pending"]
```
