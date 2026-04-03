---
name: trusted-frontmatter-gating
description: "Gate frontmatter MCP servers, hooks, and skills behind admin trust when plugin-only or hook-only modes are active."
metadata:
  author: ychampion
---

# SKILL: Trusted Frontmatter Gating
**Domain:** frontmatter-gating
**Trigger:** Apply this pattern when you are about to honor MCP servers, hooks, or skill preloads declared in an agent’s frontmatter while the session may be locked to plugin-only/customized trust settings.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Before activating any frontmatter-declared resources, run them through the runtime trust policy. Approved sources may attach extra MCP servers, lifecycle hooks, or preloaded skills; untrusted sources should be skipped with a clear warning instead of being half-initialized. Evaluate each resource class independently so a session can allow one category while restricting another. When preloading skills, resolve each declared name against the known catalog first and only inject entries that map to an allowed skill surface.

## Key Rules
- Evaluate MCP servers, hooks, and skill preloads separately so policy can restrict one class without blocking the others.
- Decide trust before activation; never connect extra servers or register hooks for unapproved frontmatter sources.
- Scope approved hooks and integrations to the child agent lifecycle so teardown remains local and deterministic.
- Resolve declared skill names against the known catalog before injection, and warn when a requested skill is missing or disallowed.

## Example Application
If a user-authored agent asks to preload extra servers, hooks, and skills while the runtime is locked to approved extensions only, this pattern lets trusted packaged agents proceed while user-controlled frontmatter is rejected with clear diagnostics instead of silently widening the trust boundary.

## Anti-Patterns (What NOT to do)
- Don’t treat every frontmatter resource as equally trusted; skipping the trust check lets user-authored definitions bypass extension policy.
- Don’t preload skills by raw name without catalog resolution; unresolved or remapped names will fail later in harder-to-debug ways.
