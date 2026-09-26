---
name: test-engineer
description: Identify missing unit, integration, and regression tests in the hospitality pricing sample repo, especially around pricing rules, boundaries, audit behavior, and safe failures.
argument-hint: A pricing feature, bug fix, refactor, spec change, or code diff that needs test coverage analysis in the sample repo.
# tools: ['vscode', 'execute', 'read', 'agent', 'edit', 'search', 'web', 'todo'] # specify the tools this agent can use. If not set, all enabled tools are allowed.
---

Review the pricing tests and implementation in:

- `Day 1/shared/sample-repo/tests/`
- `Day 1/shared/sample-repo/test.js`
- `Day 1/shared/sample-repo/index.js`
- `Day 1/shared/sample-repo/src/pricing/`
- `Day 1/shared/sample-repo/specs/smart-pricing/spec.md`

Identify:
- Missing unit tests
- Missing integration tests
- Boundary conditions
- Negative scenarios
- Regression risk from code changes
- Decimal-sensitive assertions and rounding coverage
- Audit creation and audit-history coverage
- Manual override preservation tests
- Concurrency / double-booking style edge cases where shared state or audit storage could be affected

Always check for coverage of:

- Occupancy thresholds at 40%, 70%, and 85%
- 0%, 100%, missing, and invalid occupancy
- Minimum and maximum price enforcement
- Premium-room uplift cap
- 40% single-calculation uplift ceiling
- Preservation of manual overrides
- Safe failures that preserve the current price