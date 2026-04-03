---
name: circular-safe-tool-registry-loading
description: "Safely assemble the tool registry when optional tools have circular dependencies or heavy side effects."
metadata:
  author: ychampion
---

# SKILL: Circular-Safe Tool Registry Loading
**Domain:** Tool Orchestration  
**Trigger:** Use when optional tools depend on the main registry or on each other, and eager imports would create cycles or unnecessary startup work.  
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Keep registry assembly as a simple ordered list, but place any cyclic or expensive tool behind a tiny lazy loader. That loader imports and constructs the tool only when the registry is being composed and the relevant feature is enabled. The loader returns either one tool or nothing, and the registry flattens those results in a stable order. This breaks circular dependency chains, keeps disabled features cold, and preserves one authoritative registry surface.

## Key Rules
- Wrap any tool that would trigger a cycle or heavy initialization in a zero-argument lazy loader.
- Apply the same feature gate at the loader boundary so disabled tool branches never initialize.
- Keep registry assembly deterministic: each loader should return one tool or no value, and the final list should preserve a fixed order.
- Document why each lazy loader exists so future maintainers do not inline it and reintroduce the cycle.

## Example Application
If a collaborative workspace tool depends on the same registry module that is trying to list it, move that tool behind a lazy loader and call the loader only when the collaboration feature is enabled. The registry still exposes the full surface, but startup no longer hits a circular import.

## Anti-Patterns (What NOT to do)
- Don’t import mutually dependent tools at the top level of both modules; that recreates the cycle you are trying to avoid.
- Don’t hide feature gating deep inside tool constructors; keep the gating decision at the registry edge.
- Don’t instantiate the same optional tool from multiple ad hoc call sites; let one registry pass own ordering and construction.
