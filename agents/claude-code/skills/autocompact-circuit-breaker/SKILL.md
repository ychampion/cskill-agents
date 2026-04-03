---
name: autocompact-circuit-breaker
description: "Break the autocompact retry loop after several consecutive failures to avoid hammering shared APIs."
metadata:
  author: ychampion
---

# SKILL: Autocompact Circuit Breaker
**Domain:** context-management  
**Trigger:** Apply when autocompact failures repeat and the service must stop retrying to avoid API storms.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Track consecutive autocompact failures via the caller-provided auto compact tracking state. After each failure, increment the counter, log a warning once the configured limit is reached, and return the updated count instead of throwing. The loop uses this counter to skip further auto-compact attempts as long as the limit is exceeded, effectively acting as a circuit breaker that keeps doomed sessions from flooding the service.

## Key Rules
- Add one to the failure counter on every exception (unless it’s a user abort).
- When the counter reaches the policy limit, log the breaker trip so telemetry reveals the gap.
- Return was compacted false plus consecutive failures so callers can persist the new state.
- Use the counter to skip auto-compact early on future turns rather than re-running the failed path.
- Reset the counter on a successful compaction so normal behavior resumes.

## Example Application
After three consecutive failures hitting the context limit, auto compact if needed stops retrying, logs `circuit breaker tripped`, and the tracker causes the next turn to skip compaction until a successful run resets the counter.

## Anti-Patterns (What NOT to do)
- Don’t let the controller keep retrying with the same broken context; the breaker exists to keep it quiet.
- Don’t swallow failure logs — future debugging relies on the warning emitted when the limit trips.
