---
name: portable-skill-loader-progressive-disclosure
description: "Keep the universal skill compact yet discoverable by loading minimal frontmatter first and heavy content on demand."
metadata:
  author: ychampion
---

# SKILL: Portable Skill Loader Progressive Disclosure
**Domain:** skill-loading
**Trigger:** Use when an agent must scan thousands of skills but only load detailed prompts for the handful that are actually invoked.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Separate discovery from loading. During startup, scan only lightweight metadata such as the skill name, summary, trigger text, and file location to build a searchable index. Load the full instruction body only after the agent actually selects that skill, and cache the resolved metadata and file identities so repeated lookups stay cheap. Deduplicate by canonical path, and skip invalid or ignored skill directories without failing the whole scan.

## Key Rules
- Read only lightweight metadata during discovery; defer the full skill body until invocation time.
- Resolve canonical paths so duplicate folders, symlinks, and mirrored mounts do not appear as separate skills.
- Treat malformed frontmatter or missing files as warnings to skip, not as fatal startup errors.
- Cache discovery results per source and invalidate them only when the relevant roots or settings change.

## Example Application
When building a CLI skill browser for a large monorepo, index every skill folder using only summary metadata at startup, then load the full instructions only for the skills the user or model actually opens.

## Anti-Patterns (What NOT to do)
- Don’t eagerly read every `SKILL.md` file during startup; that blocks discovery and may exceed token budgets.
- Don’t treat invalid frontmatter as fatal—skip the skill instead of crashing.
