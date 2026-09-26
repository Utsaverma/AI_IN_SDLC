---
name: hospitality-pricing
description: Describe what this skill does and when to use it. Include keywords that help agents identify relevant tasks.
---

When implementing hotel pricing logic:

- Never override manually set prices.
- Always enforce minimum and maximum prices.
- Premium rooms have a maximum 25% dynamic uplift.
- Every automated price change requires an audit entry.
- Missing occupancy data must fail safely.
- Use Decimal-based arithmetic for monetary calculations.
- Never use floating-point arithmetic for money.
- Preserve the approved business rules from the pricing specification