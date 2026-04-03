---
name: capability-pool-resolution
description: "Resolve an agent’s tool intent and disallowed lists into the actual pool the agent can use, honoring wildcard, async, and teammate allowances."
metadata:
  author: ychampion
---

# SKILL: Capability Pool Resolution
**Domain:** tool-resolution
**Trigger:** Apply this pattern when an agent declares requested tools/disallowedTools and you must compute the exact capabilities available to that agent thread.
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Start from the tools that are actually available to the current thread, then apply the active deny rules before resolving any requested names. Parse each requested tool spec into a normalized form that can represent exact names, wildcards, and optional subtype restrictions for special tool families. Expand the request against the filtered pool, preserve the original request order for valid matches, and record invalid requests with explicit reasons. If the caller effectively asked for "everything allowed," surface that as a first-class outcome so higher layers can short-circuit cleanly.

## Key Rules
- Apply deny rules before wildcard expansion; `*` means every tool that remains allowed, not every tool in the raw registry.
- Support structured specs for special tool families such as child-agent tools, and carry subtype restrictions forward for downstream enforcement.
- Deduplicate resolved tools while preserving first-match request order so logging and auditing remain stable.
- Return clear invalid-spec diagnostics instead of silently dropping unknown or disallowed requests.
- If an upstream layer has already prefiltered the pool for this thread, do not run a conflicting second filter pass.

## Example Application
When a plugin agent ships its own frontmatter tools array containing wildcards, specific commands, and custom disallow rules, lean on this skill to ensure the resulting capability pool only exposes approved tools and surfaces any invalid spec names before execution starts.

## Anti-Patterns (What NOT to do)
- Don’t ignore global or thread-specific deny rules; letting forbidden tools slip through bypasses the runtime’s safety model.
- Don’t treat `'*'` as “everything” before filtering; the wildcard means “everything that is still allowed after policy is applied.”
