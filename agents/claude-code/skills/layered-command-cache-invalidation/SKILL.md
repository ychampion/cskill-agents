---
name: layered-command-cache-invalidation
description: "Clear every memoized layer in a command or skill pipeline so dynamic updates invalidate outer derived views as well as inner source caches."
metadata:
  author: ychampion
---

# SKILL: Layered Command Cache Invalidation
**Domain:** Command Architecture  
**Trigger:** Use when commands, skills, or search indexes are cached in layers and a refresh must make newly added or removed entries visible immediately.  
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Treat cache invalidation as a stack problem, not a single-cache problem. When one memoized command view is built on top of other memoized loaders, clear the outer derived cache alongside the inner source caches in the same invalidation path. Otherwise the outer memoized function can keep returning its old result without ever touching the refreshed inner layers, so callers never observe the update.

## Key Rules
- Map the dependency order of cached views: raw sources, merged registries, derived command subsets, and any search or index layer built on top.
- Clear every cache layer that can satisfy requests from its own memoized result; if an outer layer can return without recomputing, it must be invalidated explicitly.
- Centralize the clears in one helper that runs whenever dynamic command or skill state changes, so mutation paths cannot forget a derived cache.
- Keep the invalidation contract close to the layering comment or dependency declaration, because partial clears often look correct in code review while remaining behavioral no-ops.
- Prefer one named reset entrypoint for the whole stack over scattered per-cache clears; callers should ask for a fresh command surface, not reason about cache topology.

## Example Application
An agentic IDE may memoize the merged command registry, memoize the slash-command projection derived from that registry, and memoize a local skill-search index built on top of both. When a new skill is installed, invalidate all three layers together. Clearing only the registry caches is insufficient if the search index still serves its own cached snapshot.

## Anti-Patterns (What NOT to do)
- Do not clear only the innermost loaders and assume outer memoized views will notice; cached derived layers can bypass recomputation entirely.
- Do not let each mutation site clear an ad hoc subset of caches; one missed caller leaves stale command surfaces in place.
- Do not describe a partial clear as a refresh if users can still hit an old search index, command palette, or tool registry afterward.
