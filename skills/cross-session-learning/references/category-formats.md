# Learning Category Formats

Detailed format specifications for each learning category in `.claude/learnings/`.

## Errors Category

**Location**: `.claude/learnings/errors/`
**Filename**: Descriptive kebab-case, e.g., `typescript-strict-null-checks.md`

```markdown
---
created: 2024-01-15
last_updated: 2024-01-15
source_session: retros/2024-01-15-1423.md
tags: [typescript, type-error, strict-mode]
frequency: 3
---

# TypeScript Strict Null Checks Error

## Error Signature
```
Type 'string | undefined' is not assignable to type 'string'
```

## Root Cause
Accessing optional properties without null checks when `strictNullChecks` is enabled.

## Solution
Use optional chaining (`?.`) or nullish coalescing (`??`):
```typescript
// Before (error)
const name = user.profile.name;

// After (fixed)
const name = user.profile?.name ?? 'Unknown';
```

## Prevention
- Enable `strictNullChecks` from project start
- Use `NonNullable<T>` utility type where appropriate
- Add explicit type guards for optional values

## Related
- patterns/defensive-typing.md
```

---

## Patterns Category

**Location**: `.claude/learnings/patterns/`
**Filename**: Descriptive kebab-case, e.g., `effect-error-handling.md`

```markdown
---
created: 2024-01-10
last_updated: 2024-01-18
source_session: retros/2024-01-10-0915.md
tags: [effect, error-handling, functional]
success_count: 5
---

# Effect Error Handling Pattern

## Context
When working with Effect-TS for error handling in this project.

## Pattern
Use `Effect.gen` with typed errors:

```typescript
const fetchUser = (id: string) => Effect.gen(function* () {
  const response = yield* Effect.tryPromise({
    try: () => fetch(`/api/users/${id}`),
    catch: (e) => new NetworkError({ cause: e })
  });

  if (!response.ok) {
    yield* Effect.fail(new HttpError({ status: response.status }));
  }

  return yield* Effect.tryPromise({
    try: () => response.json(),
    catch: (e) => new ParseError({ cause: e })
  });
});
```

## Benefits
- Type-safe error handling
- Composable operations
- Traceable error chains

## When to Apply
- Any async operations in this project
- Operations with multiple failure modes
- Code that needs error recovery

## Anti-Patterns
- Catching and re-throwing without typed errors
- Using `Effect.promise` without error typing
- Mixing Effect with raw try/catch

## Related
- errors/effect-fiber-interruption.md
- scripts/effect-boilerplate.md
```

---

## Preferences Category

**Location**: `.claude/learnings/preferences/`
**Filename**: Descriptive kebab-case, e.g., `testing-approach.md`

```markdown
---
created: 2024-01-08
last_updated: 2024-01-20
source_session: retros/2024-01-08-1100.md
tags: [testing, bun, preferences]
---

# Testing Approach Preference

## Preference
User prefers:
- Bun test runner over Jest
- Minimal mocking, prefer integration tests
- Test file co-location with source files
- Descriptive test names without "should"

## Examples

**Preferred**:
```typescript
// src/user.test.ts (co-located)
test("fetchUser returns user data for valid ID", async () => {
  const user = await fetchUser("123");
  expect(user.name).toBe("Test User");
});
```

**Avoid**:
```typescript
// tests/user.test.ts (separate directory)
it("should return user data", () => {
  // Heavy mocking setup
});
```

## Commands
```bash
# Run all tests
bun test

# Run specific test file
bun test src/user.test.ts

# Watch mode
bun test --watch
```

## Related
- patterns/test-factory-functions.md
```

---

## Improvements Category

**Location**: `.claude/learnings/improvements/`
**Filename**: Descriptive kebab-case, e.g., `add-retry-logic.md`

```markdown
---
created: 2024-01-19
source_session: retros/2024-01-19-1630.md
tags: [enhancement, reliability, api]
priority: medium
status: pending
---

# Add Retry Logic to API Calls

## Opportunity
During session, noticed API calls failing intermittently due to network issues. Adding retry logic would improve reliability.

## Proposed Implementation
Use exponential backoff with Effect's retry combinators:

```typescript
const withRetry = <R, E, A>(effect: Effect.Effect<R, E, A>) =>
  Effect.retry(effect, Schedule.exponential(100).pipe(
    Schedule.compose(Schedule.recurs(3))
  ));
```

## Affected Areas
- `src/api/client.ts`
- `src/services/external.ts`

## Effort Estimate
Small - one utility function, update call sites

## User Note
Identified during 2024-01-19 session when external API was flaky.

## Related
- errors/api-timeout-errors.md
- patterns/effect-error-handling.md
```

---

## Scripts Category

**Location**: `.claude/learnings/scripts/`
**Filename**: Descriptive kebab-case, e.g., `find-unused-exports.md`

```markdown
---
created: 2024-01-12
last_updated: 2024-01-12
source_session: retros/2024-01-12-0900.md
tags: [utility, cleanup, typescript]
---

# Find Unused Exports Script

## Purpose
Identify exported functions/types that are not imported anywhere in the project.

## Script
```bash
#!/bin/bash
# Find all exported symbols and check if they're imported

# Get all exports
exports=$(grep -rh "^export " src/ | sed 's/export //' | grep -oP '(?:const|function|class|type|interface) \K\w+')

# Check each export for imports
for exp in $exports; do
  count=$(grep -r "import.*$exp" src/ | wc -l)
  if [ "$count" -eq 0 ]; then
    echo "Unused: $exp"
  fi
done
```

## Usage
```bash
# Run from project root
bash .claude/learnings/scripts/find-unused-exports.sh
```

## Output Example
```
Unused: legacyHelper
Unused: DeprecatedType
Unused: oldUtilityFn
```

## Notes
- May have false positives for dynamically imported symbols
- Check re-exports in index files
- Some exports may be intentionally public API

## Related
- improvements/cleanup-unused-code.md
```

---

## Extensions Category

**Location**: `.claude/learnings/extensions/`
**Filename**: Descriptive kebab-case, e.g., `agent-test-generator.md`

```markdown
---
created: 2024-01-17
source_session: retros/2024-01-17-1400.md
tags: [agent, testing, automation]
priority: low
status: idea
---

# Test Generator Agent Idea

## Concept
An agent that automatically generates test files for new code, following project conventions.

## Trigger Conditions
- After writing a new module without tests
- User asks "generate tests for X"
- PostToolUse hook after Write to .ts files

## Capabilities Needed
- Read existing test patterns from project
- Understand testing preferences from .claude/learnings/preferences/
- Generate co-located test files
- Use bun test runner conventions

## Example Output
For a new `src/utils/format.ts`:
```typescript
// src/utils/format.test.ts
import { formatDate, formatCurrency } from "./format";

test("formatDate handles ISO strings", () => {
  expect(formatDate("2024-01-15")).toBe("Jan 15, 2024");
});

test("formatCurrency adds proper symbols", () => {
  expect(formatCurrency(100, "USD")).toBe("$100.00");
});
```

## Implementation Notes
- Could use existing test-generator from plugin-dev as reference
- Need to integrate with cross-session-learning for preferences
- Should respect .claude/learnings/patterns/ for test patterns

## Related
- preferences/testing-approach.md
- patterns/test-factory-functions.md
```
