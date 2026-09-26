# AI in SDLC Workshop — End-to-End Hospitality Pricing POC

## 1. Workshop Objective

Build one realistic, end-to-end hospitality product change and use it to demonstrate multiple AI-in-SDLC concepts in a single coherent workflow:

- Spec-Driven Development (SDD)
- Agent Skills
- AI Agents / Subagents
- Hooks
- MCP (Model Context Protocol)
- AI-assisted implementation
- AI-powered PR review
- Test generation and validation
- Convergence back to the specification
- CI/CD

The core message of the workshop:

> **AI does not replace the SDLC. It changes how SDLC activities are performed and introduces new engineering control mechanisms.**

---

# 2. POC Use Case

## Product: Smart Demand-Based Hotel Pricing

A hotel chain currently uses a basic pricing engine:

```text
Room Price = Base Room Price
```

The business wants to introduce dynamic pricing.

### Business Requirement

> Automatically increase or decrease room prices based on occupancy and demand, while ensuring that prices always comply with business rules and revenue-manager overrides.

Example pricing rules:

| Occupancy | Price Adjustment |
|---|---:|
| < 40% | Base Price |
| 40%–70% | +10% |
| 70%–85% | +20% |
| > 85% | +35% |

### Business Constraints

- Minimum room price: **₹2,000**
- Maximum room price: **₹20,000**
- Automated pricing must never increase a price by more than **40%** in one calculation.
- Premium rooms have a maximum dynamic uplift of **25%**.
- A manually overridden price must never be overwritten by the automated pricing engine.
- Every automated price change must be auditable.
- Missing or invalid occupancy data must fail safely.

---

# 3. Why This Use Case Works for the Workshop

This use case is intentionally small in implementation size but rich in engineering concerns.

It gives us:

- Ambiguous requirements to analyze
- A real specification to create
- Architecture decisions
- Domain-specific knowledge
- Specialized agents
- Guardrails
- External-system interaction through MCP
- Tests and edge cases
- A deliberately flawed implementation
- A PR review scenario
- A final convergence step

The same business scenario is therefore used from:

```text
Business Request
      ↓
Specification
      ↓
Architecture
      ↓
Implementation
      ↓
Testing
      ↓
PR Review
      ↓
Convergence
```

---

# 4. End-to-End AI-Native SDLC Story

```text
                    BUSINESS REQUEST
                           ↓
                     SDD / SPEC
                           ↓
              ┌────────────┴────────────┐
              ↓                         ↓
           SKILLS                  ARCHITECTURE
              ↓                         ↓
              └────────────┬────────────┘
                           ↓
                         AGENTS
                           ↓
                           MCP
                           ↓
                     IMPLEMENTATION
                           ↓
                         HOOKS
                           ↓
                          TESTS
                           ↓
                           PR
                           ↓
                   PR REVIEW AGENT
                           ↓
                       CONVERGENCE
                           ↓
                        RELEASE
```

---

# 5. Step 1 — Start With a Vague Business Requirement

Do **not** give the AI a perfect specification.

Start with:

```text
We need dynamic pricing for hotel rooms.
Prices should change based on occupancy and demand,
but revenue managers should still be able to override prices.
```

Ask the AI:

```text
Analyze this requirement.

Identify:
1. Ambiguities
2. Missing business rules
3. Functional requirements that need clarification
4. Non-functional requirements
5. Edge cases
6. Questions that must be answered before implementation

Do not write code.
```

Expected output should identify questions such as:

```text
1. What occupancy thresholds trigger price changes?
2. What is the minimum room price?
3. What is the maximum room price?
4. Can premium rooms follow the same rules?
5. Can automated pricing overwrite manual overrides?
6. How frequently is price recalculated?
7. What happens when occupancy data is unavailable?
8. How are pricing changes audited?
```

## Teaching Point

The AI should not automatically jump from:

```text
Requirement → Code
```

Instead:

```text
Requirement
    ↓
Clarification
    ↓
Specification
```

---

# 6. Step 2 — Introduce SDD / Spec Kit

The specification becomes the source of truth.

The core SDD lifecycle used in the workshop:

```text
Specify
   ↓
Plan
   ↓
Tasks
   ↓
Implement
   ↓
Converge
```

Create a feature directory:

```text
/specs
    /smart-pricing
        spec.md
        plan.md
        tasks.md
```

---

# 7. `spec.md`

The specification should contain at least:

## 7.1 Functional Requirements

```text
FR-01
The system shall calculate a dynamic room price based on occupancy.

FR-02
The system shall enforce a minimum room price of ₹2,000.

FR-03
The system shall enforce a maximum room price of ₹20,000.

FR-04
The system shall respect manually overridden prices.

FR-05
The system shall apply a maximum uplift of 25% to premium rooms.

FR-06
The system shall record every automated price change.

FR-07
The system shall fail safely when occupancy data is unavailable or invalid.
```

## 7.2 Acceptance Criteria

```text
Given occupancy is 50%
When the price is calculated
Then a 10% uplift is applied.

Given occupancy is 80%
When the price is calculated
Then a 20% uplift is applied.

Given occupancy is 90%
When the price is calculated
Then the normal uplift is 35%.

Given the room is premium
And the calculated uplift is greater than 25%
Then the uplift is capped at 25%.

Given the calculated price is below ₹2,000
Then the final price is ₹2,000.

Given the calculated price is above ₹20,000
Then the final price is ₹20,000.

Given a manual override exists
When automated pricing runs
Then the manual price remains unchanged.

Given occupancy data is missing
When pricing is calculated
Then the system must fail safely and must not produce an unsafe price.
```

## 7.3 Non-Goals

```text
The feature will not:

- Change booking availability
- Change room inventory
- Modify reservations
- Implement payment processing
- Replace the revenue manager
```

---

# 8. Step 3 — Create the Architecture

Ask the AI:

```text
Based strictly on the approved product and feature specifications,
design the application architecture.

Separate:
- Frontend
- Backend
- Pricing engine
- Persistence
- External integrations

Do not introduce technology choices without justification.

Document important technical decisions separately as ADRs.
```

Generate:

```text
docs/
    architecture.md
    adr/
        ADR-001-pricing-engine.md
        ADR-002-money-representation.md
```

---

# 9. Specification vs ADR

This is an important teaching point.

## Specification

Describes:

> **What the system must do**

Example:

```text
Premium rooms must never receive more than 25% dynamic uplift.
```

## ADR

Describes:

> **Which technical decision we made and why**

Example:

```text
ADR-002
Use Decimal-based monetary arithmetic instead of floating-point
arithmetic for pricing calculations.
```

Conceptually:

```text
Requirement
    ↓
Specification
    ↓
Implementation choices
    ↓
ADR records important technical decisions
```

A large product can have:

```text
Product
 ├── Feature Spec A
 ├── Feature Spec B
 ├── Feature Spec C
 │
 ├── ADR-001
 ├── ADR-002
 └── ADR-003
```

A feature can have a specification, and the technical choices made while implementing it can be captured in ADRs.

---

# 10. Step 4 — Demonstrate an Agent Skill

Create a project skill:

```text
.github/
    skills/
        hospitality-pricing/
            SKILL.md
```

Example `SKILL.md`:

```text
# Hospitality Pricing Skill

When implementing hotel pricing logic:

- Never override manually set prices.
- Always enforce minimum and maximum prices.
- Premium rooms have a maximum 25% dynamic uplift.
- Every automated price change requires an audit entry.
- Missing occupancy data must fail safely.
- Use Decimal-based arithmetic for monetary calculations.
- Never use floating-point arithmetic for money.
- Preserve the approved business rules from the pricing specification.
```

Ask the agent:

```text
Implement Smart Demand-Based Pricing
using the approved specification and the
hospitality-pricing skill.

Do not modify unrelated functionality.
```

The conceptual flow becomes:

```text
Prompt
  +
Repository
  +
Specification
  +
Hospitality Skill
        ↓
      Agent
        ↓
  Implementation
```

## Teaching Point

A skill is reusable knowledge and instructions:

> **"Here is how this type of work should be done."**

It gives the agent domain-specific guidance without embedding the same instructions in every prompt.

---

# 11. Step 5 — Demonstrate Specialized Agents / Subagents

Do not make one agent responsible for everything.

Create specialized roles:

```text
agents/
    pricing-analyst.md
    test-engineer.md
    security-reviewer.md
```

## Pricing Analyst Agent

Responsibility:

```text
Review the pricing specification,
existing pricing code and pricing-related issues.

Output:
- Business-rule analysis
- Risks
- Edge cases
- Recommended changes
```

## Test Engineer Agent

Responsibility:

```text
Review the pricing specification.

Identify:
- Missing unit tests
- Missing integration tests
- Boundary conditions
- Negative scenarios
- Concurrency / double-booking style edge cases
```

## Security Reviewer Agent

Responsibility:

```text
Review the implementation for:
- Authorization issues
- Unsafe inputs
- Auditability
- Secret exposure
- Unintended data access
```

Conceptually:

```text
                         MAIN AGENT
                              │
                ┌─────────────┼─────────────┐
                ↓             ↓             ↓
          Pricing Agent   Test Agent   Security Agent
```

## Teaching Point

An agent is not just a chatbot prompt.

It can have:

- A role
- Tools
- Context
- Skills
- Goals
- Guardrails
- A defined output

This allows work to be delegated and specialized.

---

# 12. Step 6 — Demonstrate Hooks

Create a repository hook conceptually such as:

```text
.github/
    hooks/
        pricing-guard.json
```

A useful workshop hook:

> Before the agent modifies pricing logic, ensure that the approved specification exists and that pricing tests are present.

Another safe demo hook:

> Prevent the agent from modifying production deployment configuration during the workshop.

Conceptual flow:

```text
Agent wants to execute a tool
            ↓
       Pre-tool Hook
            ↓
   Is the operation allowed?
       /              \
     NO                YES
     ↓                  ↓
   BLOCK             Execute
```

Example policy:

```text
IF file_path belongs to production configuration
THEN DENY operation

IF pricing implementation changes
AND specs/smart-pricing/spec.md does not exist
THEN DENY operation

IF pricing implementation changes
AND required pricing tests are absent
THEN DENY operation
```

## Teaching Point

A skill says:

> **"You should do it this way."**

A hook says:

> **"This action is not allowed unless the condition is satisfied."**

This distinction is extremely valuable when discussing AI safety and engineering controls.

---

# 13. Step 7 — Demonstrate MCP

Now give the agent a reason to access information outside the immediate prompt.

A good MCP demonstration is GitHub.

Create a GitHub issue:

```text
#247

Revenue managers report that premium rooms
are occasionally exceeding the approved
dynamic pricing uplift.
```

Now ask:

```text
Investigate issue #247.

Review:
- The issue
- Relevant repository context
- Pricing implementation
- Recent changes

Identify the likely cause.

Do not modify code yet.
```

Conceptual flow:

```text
Natural language request
          ↓
        Agent
          ↓
       MCP Client
          ↓
       MCP Server
          ↓
        GitHub
          ↓
   Context / data returned
          ↓
        Agent
          ↓
      Analysis
```

The key teaching point:

> **MCP provides a standardized way for an AI system to interact with tools and external systems.**

Instead of manually copying GitHub information into a prompt:

```text
AI → MCP → GitHub
```

---

# 14. Step 8 — Make the MCP Scenario Meaningful

The agent discovers:

```text
The implementation allows premium rooms
to receive the standard 35% uplift.

The specification says premium rooms
must be capped at 25%.
```

Now ask:

```text
Update the specification to explicitly capture this rule.

Then create an implementation plan.

Do not modify production code yet.
```

This demonstrates an important SDD concept:

```text
Problem discovered
       ↓
Specification updated
       ↓
Implementation planned
       ↓
Implementation changed
```

rather than:

```text
Problem discovered
       ↓
Quick code patch
```

---

# 15. Step 9 — Implement the Feature

Now ask:

```text
Implement the Smart Demand-Based Pricing feature
strictly from the approved specification.

Use the hospitality-pricing skill.

Use the existing architecture.

Do not modify unrelated functionality.

Generate or update tests where required.
```

A simple implementation could contain:

```text
src/
    pricing/
        pricing_engine.py
        pricing_rules.py
        audit.py
```

Possible logic:

```python
base_price
occupancy
room_type
manual_override
        ↓
calculate_uplift()
        ↓
apply_room_type_cap()
        ↓
apply_min_max_price()
        ↓
respect_manual_override()
        ↓
record_audit_event()
        ↓
final_price
```

---

# 16. Step 10 — Generate Tests With AI

Ask:

```text
Based on the approved pricing specification,
generate unit and integration tests covering:

- Happy path
- Occupancy boundaries
- Minimum price
- Maximum price
- Premium room uplift cap
- Manual override
- Missing occupancy data
- Invalid occupancy values
- Audit entry creation
```

Example test matrix:

| Scenario | Expected Result |
|---|---|
| Occupancy 30% | Base price |
| Occupancy 50% | +10% |
| Occupancy 80% | +20% |
| Occupancy 90% | +35% |
| Premium + 90% occupancy | Max +25% |
| Calculated < ₹2,000 | ₹2,000 |
| Calculated > ₹20,000 | ₹20,000 |
| Manual override | Override preserved |
| Missing occupancy | Safe failure |
| Automated price change | Audit entry |

---

# 17. Step 11 — Intentionally Introduce a Bad Implementation

This is critical for the PR-review portion.

Introduce one or more realistic defects:

```python
final_price = base_price * (1 + uplift_percentage)
```

Potential defects:

1. Floating-point arithmetic is used for money.
2. Manual overrides are not checked.
3. Premium-room uplift is not capped.
4. Audit records are missing.
5. Invalid occupancy is not handled safely.

The objective is not to trick the attendees.

The objective is to demonstrate:

> **AI can generate code, but another AI workflow can independently challenge that code.**

---

# 18. Step 12 — Create the Pull Request

Create a PR such as:

```text
feat: implement smart demand-based pricing
```

PR contains:

```text
- Pricing implementation
- Tests
- Specification reference
- Architecture reference
```

Now trigger the PR review agent.

---

# 19. Step 13 — PR Review Agent

The reviewer should evaluate the PR against:

```text
Pull Request
     +
Specification
     +
Architecture
     +
ADRs
     +
Hospitality Skill
```

Prompt:

```text
Review this pull request against the approved specification.

For every finding provide:

- Severity
- File
- Line
- Problem
- Why it violates the specification
- Recommended fix

Focus on:
- Functional correctness
- Business rules
- Monetary correctness
- Edge cases
- Test coverage
- Security
- Auditability

Do not approve code simply because it compiles.
```

Expected findings:

```text
CRITICAL
Manual override can be overwritten.

HIGH
Premium-room uplift can exceed the 25% limit.

MEDIUM
Currency calculations use floating-point arithmetic.

MEDIUM
Audit record is missing for automated price changes.

LOW
Additional boundary tests are recommended.
```

The key concept:

> **The PR review agent is validating implementation against an explicit engineering contract, not merely giving generic code feedback.**

---

# 20. Step 14 — Convergence

This is the final and most important SDD step.

Prompt:

```text
Resolve all PR review findings.

Then:

1. Re-run the relevant tests.
2. Verify the implementation against the approved specification.
3. Verify the acceptance criteria.
4. Verify the relevant ADRs.
5. Report any remaining gaps.
6. Do not mark the feature complete if the implementation
   still violates the specification.
```

The process becomes:

```text
SPECIFICATION
      ↓
IMPLEMENTATION
      ↓
TESTS
      ↓
PR REVIEW
      ↓
FIX
      ↓
RE-TEST
      ↓
CONVERGENCE
      ↓
READY
```

This is a strong final demonstration because AI is not simply generating code once.

It is helping the team continuously bring the implementation back into alignment with the intended behavior.

---

# 21. Recommended Repository Structure

```text
ai-hotel-pricing/
│
├── .github/
│   │
│   ├── skills/
│   │   └── hospitality-pricing/
│   │       └── SKILL.md
│   │
│   ├── hooks/
│   │   └── pricing-guard.json
│   │
│   └── workflows/
│       └── ci.yml
│
├── specs/
│   └── smart-pricing/
│       ├── spec.md
│       ├── plan.md
│       └── tasks.md
│
├── src/
│   └── pricing/
│       ├── pricing_engine.py
│       ├── pricing_rules.py
│       └── audit.py
│
├── tests/
│   ├── test_pricing.py
│   ├── test_override.py
│   └── test_premium_rooms.py
│
├── agents/
│   ├── pricing-analyst.md
│   ├── test-engineer.md
│   └── security-reviewer.md
│
├── docs/
│   ├── architecture.md
│   └── adr/
│       ├── ADR-001-pricing-engine.md
│       └── ADR-002-money-representation.md
│
└── README.md
```

---

# 22. What Each AI-SDLC Concept Does

| Concept | Role in the POC |
|---|---|
| **SDD / Spec Kit** | Creates a structured source of truth for requirements and implementation |
| **Skill** | Gives the agent reusable hospitality/pricing-specific knowledge |
| **Agent** | Performs specialized reasoning and delegates work |
| **Hook** | Enforces deterministic guardrails around agent actions |
| **MCP** | Connects the agent to GitHub / external systems and context |
| **AI Implementation** | Converts the approved specification into code |
| **AI Test Generation** | Converts acceptance criteria into executable tests |
| **PR Review Agent** | Independently validates implementation against specification and engineering rules |
| **Convergence** | Brings implementation back into alignment with the specification |
| **CI/CD** | Automatically validates the resulting change |

---

# 23. Recommended Workshop Flow

## Part 1 — Business Requirement

Show:

```text
"We need dynamic hotel pricing..."
```

Ask AI to identify ambiguity.

### Concept demonstrated

**AI-assisted requirements analysis**

---

## Part 2 — SDD

Convert the requirement into:

```text
spec.md
plan.md
tasks.md
```

### Concept demonstrated

**Spec-Driven Development**

---

## Part 3 — Architecture

Generate:

```text
architecture.md
ADR-001
ADR-002
```

### Concept demonstrated

**AI-assisted system design and decision documentation**

---

## Part 4 — Skill

Introduce:

```text
hospitality-pricing/SKILL.md
```

### Concept demonstrated

**Reusable domain knowledge for agents**

---

## Part 5 — Agent

Delegate work to:

```text
Pricing Analyst
Test Engineer
Security Reviewer
```

### Concept demonstrated

**Specialized agents / subagents**

---

## Part 6 — Hook

Attempt an unsafe or non-compliant agent action.

Hook blocks it.

### Concept demonstrated

**Deterministic AI guardrails**

---

## Part 7 — MCP

Create GitHub issue #247.

Ask the agent to investigate using GitHub context.

### Concept demonstrated

**Tool and external-system connectivity through MCP**

---

## Part 8 — Implementation

Generate the feature from the specification.

### Concept demonstrated

**Specification → implementation**

---

## Part 9 — Testing

Generate and execute tests.

### Concept demonstrated

**AI-assisted verification**

---

## Part 10 — PR Review Agent

Open a PR containing an intentionally flawed implementation.

### Concept demonstrated

**Independent AI code review**

---

## Part 11 — Convergence

Resolve review findings and verify against the specification.

### Concept demonstrated

**Implementation convergence with SDD**

---

# 24. The Core Workshop Message

Start the workshop with the traditional view:

```text
Requirement
    ↓
Developer interpretation
    ↓
Code
    ↓
Tests
    ↓
PR
    ↓
Human review
```

Then show the AI-native model:

```text
                    BUSINESS REQUEST
                           ↓
                       SDD / SPEC
                           ↓
                 ┌─────────┴─────────┐
                 ↓                   ↓
              SKILLS            ARCHITECTURE
                 ↓                   ↓
                 └─────────┬─────────┘
                           ↓
                         AGENTS
                           ↓
                           MCP
                           ↓
                    IMPLEMENTATION
                           ↓
                         HOOKS
                           ↓
                          TESTS
                           ↓
                           PR
                           ↓
                   PR REVIEW AGENT
                           ↓
                      CONVERGENCE
                           ↓
                        RELEASE
```

Final takeaway:

> **AI should not be treated as a single coding assistant. An AI-native SDLC combines specifications, domain knowledge, specialized agents, deterministic guardrails, external tools, automated verification and continuous convergence.**

---

# 25. Practical Workshop Scope

Keep the actual application deliberately small.

The implementation itself can be:

```text
One pricing engine
+
A few APIs/functions
+
A small persistence layer
+
Unit tests
```

The complexity of the workshop should come from the **engineering workflow**, not from a huge application.

This keeps the live demo understandable while still demonstrating:

```text
Requirements
→ Specification
→ Architecture
→ ADRs
→ Skills
→ Agents
→ Hooks
→ MCP
→ Coding
→ Testing
→ PR Review
→ Convergence
```

---

# 26. Suggested Demo Environment

For a browser-first workshop:

```text
Google AI Studio
+
GitHub
+
GitHub Codespaces
+
GitHub Copilot / GitHub-hosted AI capabilities
+
GitHub Actions
```

The goal is to minimize attendee setup and avoid requiring attendees to purchase API credits.

Use synthetic hotel data and a non-sensitive repository. Do not place organizational source code, credentials, customer information, secrets, or confidential requirements into personal accounts.

---

# 27. Final One-Line Narrative

The entire workshop can be summarized as:

> **"Let's take one ambiguous hotel-pricing business request and follow it through an AI-native SDLC — from specification to architecture, agent skills, specialized agents, hooks, MCP, implementation, automated review and final convergence."**
