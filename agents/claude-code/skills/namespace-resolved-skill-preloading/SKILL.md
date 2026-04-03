---
name: namespace-resolved-skill-preloading
description: "Resolve skill names through layered namespace lookup, then preload the valid skills as visible startup messages."
metadata:
  author: ychampion
---

# SKILL: Namespace-Resolved Skill Preloading
**Domain:** agentic-loop
**Trigger:** Apply when an agent definition lists startup skills by friendly name but the registry may store those skills under plugin-qualified names.
**Source Pattern:** Distilled from reviewed startup-skill preload and namespaced-command resolution implementations.

## Core Method
Resolve each configured skill through a layered lookup: direct match, plugin-prefixed match, then suffix match across namespaced registrations. Reject missing or non-prompt commands with warnings instead of silently swallowing them, then load the remaining skills concurrently and inject their contents as explicit startup messages with metadata that shows what was preloaded. This makes startup capability bootstrapping both flexible and auditable.

## Key Rules
- Use layered resolution rather than assuming one naming convention, because plugin ecosystems mix bare names and fully qualified names.
- Validate that the resolved command is prompt-based before preloading it into the transcript.
- Load valid skills concurrently so startup does not serialize on independent skill fetches.
- Materialize preloaded skills as visible transcript messages with loading metadata instead of hiding them inside prompt assembly.

## Example Application
If a plugin agent declares `skills: [review, deployment-checks]` but the registry stores them as `plugin-x:review` and `plugin-x:deployment-checks`, resolve them through the namespace fallback chain, preload both, and surface their startup messages so the UI shows what context was injected.

## Anti-Patterns (What NOT to do)
- Do not fail the whole startup path because one configured skill is missing; warn and keep preloading the valid ones.
- Do not bury preloaded skill content in a hidden prompt string; operators need to see which startup skills were applied.
